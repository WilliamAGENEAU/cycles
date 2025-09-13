import 'package:flutter/material.dart';

Widget saignementCard({
  required int bleeding,
  required void Function(int) onChanged,
  required BuildContext context,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final labels = ['Aucun', 'Léger', 'Modéré', 'Abondant'];
  final colors = [
    colorScheme.surfaceVariant,
    colorScheme.tertiaryContainer,
    colorScheme.errorContainer,
    colorScheme.error,
  ];

  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    color: colorScheme.surfaceContainerHigh,
    child: Padding(
      padding: const EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saignements',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (i) {
              final selected = bleeding == i;
              return GestureDetector(
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 220),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? colors[i] : colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: colorScheme.shadow.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    labels[i],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: selected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    ),
  );
}
