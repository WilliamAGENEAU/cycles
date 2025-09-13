// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Card générique pour options avec icônes SVG ou images
Widget iconOptionsCard({
  required String title,
  required List<String> labels, // Noms affichés sous les icônes
  required List<String> icons, // chemins des SVG ou PNG/JPG
  required BuildContext context,
  required List<String> selected, // liste des options sélectionnées
  required void Function(List<String>) onChanged,
  bool singleSelection =
      false, // true = un seul choix (glaire), false = multi (douleurs/humeurs)
  Color? activeColor, // couleur quand sélectionné
  Color? inactiveColor, // couleur quand pas sélectionné
  Color? onColor,
}) {
  final colorScheme = Theme.of(context).colorScheme;
  final active = activeColor ?? colorScheme.errorContainer;
  final inactive = inactiveColor ?? colorScheme.surfaceContainerHighest;

  Widget buildIcon(String path, bool isSelected, Color color) {
    if (path.toLowerCase().endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      );
    } else {
      return Image.asset(
        path,
        width: 48,
        height: 48,
        color: null, // Pas de recoloration pour PNG/JPG
        fit: BoxFit.contain,
      );
    }
  }

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
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: icons.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (context, i) {
                final isSelected = selected.contains(labels[i]);
                return GestureDetector(
                  onTap: () {
                    if (singleSelection) {
                      onChanged([labels[i]]);
                    } else {
                      final updated = List<String>.from(selected);
                      if (isSelected) {
                        updated.remove(labels[i]);
                      } else {
                        updated.add(labels[i]);
                      }
                      onChanged(updated);
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
                          color: isSelected ? active : inactive,
                          boxShadow: isSelected
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
                          child: buildIcon(
                            icons[i],
                            isSelected,
                            isSelected
                                ? activeColor!
                                : (onColor ?? colorScheme.onSurface),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? activeColor!
                              : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}
