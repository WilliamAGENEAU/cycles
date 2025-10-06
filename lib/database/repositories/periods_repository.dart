// ignore_for_file: strict_top_level_inference

import 'package:cycles/database/app_database.dart';
import 'package:cycles/models/flows/flow_data.dart';
import 'package:cycles/models/flows/flow_enum.dart';
import 'package:cycles/models/period_logs/period_day.dart';
import 'package:cycles/models/periods/period.dart';
import 'package:cycles/utils/exceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class PeriodsRepository {
  final dbProvider = AppDatabase.instance;
  static const String _whereId = 'id = ?';

  Future<void> logPeriodFromWatch() async {
    debugPrint('Received request from watch! Logging period now...');

    try {
      final newLog = PeriodDay(
        date: DateTime.now(),
        flow: FlowRate.abondants,
        painLevel: 0,
      );

      await createPeriodLog(newLog);
      debugPrint('Successfully logged period from the watch.');
    } on DuplicateLogException {
      debugPrint('Watch log ignored: A log for today already exists.');
    } catch (e) {
      debugPrint('An error occurred while logging from the watch: $e');
    }
  }

  /// Validates a log's date, throwing exceptions for future or duplicate dates.
  Future<void> _validateLogDate(
    Database db,
    DateTime date, {
    int? idToExclude,
  }) async {
    final today = DateUtils.dateOnly(DateTime.now());
    final entryDate = DateUtils.dateOnly(date);

    if (entryDate.isAfter(today)) {
      throw FutureDateException('Logs cannot be for future dates.');
    }

    String whereClause = 'date(date) = date(?)';
    if (idToExclude != null) {
      whereClause += ' AND id != ?';
    }

    final existingLogs = await db.query(
      'period_logs',
      where: whereClause,
      whereArgs: idToExclude != null
          ? [date.toIso8601String(), idToExclude]
          : [date.toIso8601String()],
      limit: 1,
    );

    if (existingLogs.isNotEmpty) {
      throw DuplicateLogException('A log already exists for this date.');
    }
  }

  Future<void> deleteAllEntries() async {
    final db = await dbProvider.database;
    await db.transaction((txn) async {
      await txn.delete('period_logs');
      await txn.delete('periods');
    });
  }

  // Periods

  Future<Period> createPeriod(Period entry) async {
    final db = await dbProvider.database;
    final id = await db.insert('periods', entry.toMap());
    return entry.copyWith(id: id);
  }

  Future<List<Period>> readAllPeriods() async {
    final db = await dbProvider.database;
    const orderBy = 'start_date DESC';
    final result = await db.query('periods', orderBy: orderBy);

    return result.map((json) => Period.fromMap(json)).toList();
  }

  Future<Period?> readLastPeriod() async {
    final db = await dbProvider.database;
    final maps = await db.query(
      'periods',
      orderBy: 'start_date DESC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return Period.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> updatePeriod(Period period) async {
    final db = await dbProvider.database;
    return db.update(
      'periods',
      period.toMap(),
      where: _whereId,
      whereArgs: [period.id],
    );
  }

  Future<int> deletePeriod(int id) async {
    final db = await dbProvider.database;
    return await db.delete('periods', where: _whereId, whereArgs: [id]);
  }

  // Period logs

  Future<PeriodDay> createPeriodLog(PeriodDay entry) async {
    final db = await dbProvider.database;

    debugPrint(entry.toString());

    await _validateLogDate(db, entry.date);

    final id = await db.insert('period_logs', entry.toMap());

    await _recalculateAndAssignPeriods(db);

    return await readPeriodLog(id);
  }

  Future<List<PeriodDay>> readAllPeriodLogs() async {
    final db = await dbProvider.database;
    const orderBy = 'date DESC';
    final result = await db.query('period_logs', orderBy: orderBy);

    return result.map((json) => PeriodDay.fromMap(json)).toList();
  }

  Future<PeriodDay> readPeriodLog(id) async {
    final db = await dbProvider.database;

    final result = await db.query(
      'period_logs',
      where: _whereId,
      whereArgs: [id],
    );

    return result.map((json) => PeriodDay.fromMap(json)).first;
  }

  Future<int> updatePeriodLog(PeriodDay entry) async {
    final db = await dbProvider.database;

    await _validateLogDate(db, entry.date, idToExclude: entry.id);

    final int result = await db.update(
      'period_logs',
      entry.toMap(),
      where: _whereId,
      whereArgs: [entry.id],
    );

    if (result > 0) {
      await _recalculateAndAssignPeriods(db);
    }

    return result;
  }

  Future<int> deletePeriodLog(int id) async {
    final db = await dbProvider.database;
    final int result = await db.delete(
      'period_logs',
      where: _whereId,
      whereArgs: [id],
    );

    if (result > 0) {
      await _recalculateAndAssignPeriods(db);
    }

    return result;
  }

  // Other

  Future<void> _recalculateAndAssignPeriods(Database db) async {
    await db.delete('periods');

    final allEntryMaps = await db.query(
      'period_logs',
      orderBy: 'date ASC',
      where: 'flow != ?',
      whereArgs: [FlowRate.none.index],
    );
    final allEntries = allEntryMaps.map((e) => PeriodDay.fromMap(e)).toList();

    if (allEntries.isEmpty) {
      return;
    }

    List<PeriodDay> currentPeriodLogs = [];

    for (final entry in allEntries) {
      if (currentPeriodLogs.isEmpty ||
          entry.date.difference(currentPeriodLogs.last.date).inDays > 1) {
        if (currentPeriodLogs.isNotEmpty) {
          await _createPeriodFromLogs(db, currentPeriodLogs);
        }
        currentPeriodLogs = [entry];
      } else {
        currentPeriodLogs.add(entry);
      }
    }
    if (currentPeriodLogs.isNotEmpty) {
      await _createPeriodFromLogs(db, currentPeriodLogs);
    }
  }

  /// Creates a Period entry in the DB from logs with at flow rate.
  Future<void> _createPeriodFromLogs(Database db, List<PeriodDay> logs) async {
    final periodDays = logs.where((log) => log.flow != FlowRate.none).toList();

    if (periodDays.isEmpty) {
      return;
    }

    final startDate = periodDays.first.date;
    final endDate = periodDays.last.date;
    final totalDays = endDate.difference(startDate).inDays + 1;

    final newPeriodMap = {
      'start_date': startDate.millisecondsSinceEpoch,
      'end_date': endDate.millisecondsSinceEpoch,
      'total_days': totalDays,
    };

    final periodId = await db.insert('periods', newPeriodMap);

    final logIds = periodDays.map((log) => log.id!).toList();

    await db.transaction((txn) async {
      for (final logId in logIds) {
        await txn.update(
          'period_logs',
          {'period_id': periodId},
          where: _whereId,
          whereArgs: [logId],
        );
      }
    });
  }

  /// Fetches monthly flow data exclusively from logs that are part of a period.
  Future<List<MonthlyFlowData>> getMonthlyPeriodFlows() async {
    final db = await dbProvider.database;
    final List<MonthlyFlowData> allMonthlyFlows = [];

    final allPeriods = await readAllPeriods();

    for (final period in allPeriods) {
      if (period.id == null) continue;

      final logsResult = await db.query(
        'period_logs',
        where: 'period_id = ?',
        whereArgs: [period.id],
        orderBy: 'date ASC',
      );

      final flowInts = logsResult.map((log) => log['flow'] as int).toList();

      if (flowInts.isNotEmpty) {
        final monthKey = DateFormat('MMM').format(period.startDate);

        allMonthlyFlows.add(
          MonthlyFlowData(monthLabel: monthKey, flows: flowInts),
        );
      }
    }

    return allMonthlyFlows;
  }
}
