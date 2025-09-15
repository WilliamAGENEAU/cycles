// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget saignementCard({
  required int bleeding, // -1 = rien sélectionné
  required void Function(int) onChanged,
  required BuildContext context,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final labels = ['Légers', 'Modérés', 'Abondants', 'Très abondants'];
  final icons = [
    'assets/icons/light.svg',
    'assets/icons/light2.svg',
    'assets/icons/medium.svg',
    'assets/icons/heavy.svg',
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
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (i) {
              final bool selected = bleeding == i;
              return GestureDetector(
                onTap: () {
                  if (selected) {
                    // si on reclique → désélection
                    onChanged(-1);
                  } else {
                    onChanged(i);
                  }
                },
                child: Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selected
                            ? colorScheme.errorContainer
                            : colorScheme.error,
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
                      child: Center(
                        child: SvgPicture.asset(
                          icons[i],
                          width: 28,
                          height: 28,
                          colorFilter: ColorFilter.mode(
                            selected ? colorScheme.error : colorScheme.onError,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      labels[i],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: selected
                            ? colorScheme.error
                            : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    ),
  );
}
