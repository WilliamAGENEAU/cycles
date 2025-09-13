import 'package:flutter/material.dart';

Widget temperatureCard({
  required TextEditingController controller,
  required BuildContext context,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    color: colorScheme.surfaceContainerHigh,
    child: Padding(
      padding: const EdgeInsets.all(18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Température basale au réveil',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: '36.65',
                    hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Text(
                '°C',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
