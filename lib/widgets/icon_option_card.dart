import 'package:cycles/widgets/circle_options.dart';
import 'package:flutter/material.dart';

Widget iconOptionsCard(
  String title,
  List<String> options,
  String current,
  void Function(String) onSelect,
) {
  return Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    child: Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 12),
          Wrap(
            spacing: 12,
            children: options.map((o) {
              final selected = (o == current);
              return CircleOption<String>(
                value: o,
                groupValue: current,
                onTap: () => onSelect(o),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.circle,
                      size: 12,
                      color: selected ? Colors.white : Colors.grey,
                    ),
                    SizedBox(height: 6),
                    Text(o, style: TextStyle(fontSize: 11)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ),
  );
}
