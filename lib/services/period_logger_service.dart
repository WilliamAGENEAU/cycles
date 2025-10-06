import 'package:cycles/database/repositories/periods_repository.dart';
import 'package:cycles/models/flows/flow_enum.dart';
import 'package:cycles/models/period_logs/period_day.dart';
import 'package:cycles/utils/exceptions.dart';
import 'package:cycles/widgets/sheets/symptom_entry_sheet.dart';
import 'package:flutter/material.dart';

class PeriodLoggerService {
  static Future<bool> showAndLogPeriod(
    BuildContext context,
    DateTime selectedDate,
  ) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => SymptomEntrySheet(selectedDate: selectedDate),
    );
    final periodsRepo = PeriodsRepository();

    if (result == null || !context.mounted) {
      return false;
    }

    try {
      final DateTime? date = result['date'];
      if (date == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Date was not provided.')),
        );
        return false; // Failure
      }

      final newEntry = PeriodDay(
        date: date,
        symptoms: result['symptoms'] ?? [],
        flow: result['flow'] ?? FlowRate.none,
        painLevel: result['painLevel'] ?? 0,
        temperature: result['temperature'] != null
            ? double.tryParse(result['temperature'].toString())
            : null,
      );

      try {
        await periodsRepo.createPeriodLog(newEntry);
      } on DuplicateLogException catch (e) {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
        return false;
      } on FutureDateException catch (e) {
        if (!context.mounted) return false;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
        return false;
      }

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Log saved!')));
      }
      return true;
    } catch (e) {
      debugPrint('Error logging period: $e');
      if (!context.mounted) return false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to save log. Please try again.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }
  }
}
