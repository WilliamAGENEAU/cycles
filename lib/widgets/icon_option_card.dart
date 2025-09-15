// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Widget iconOptionsCard({
  required String title,
  required List<String> labels, // noms sous les icônes
  required List<String> icons, // chemins des SVG ou PNG/JPG
  required BuildContext context,
  required List<String>
  selected, // liste des options sélectionnées (doit venir du parent)
  required void Function(List<String>) onChanged,
  bool singleSelection = false, // glaire = true, autres = false
  Color? activeColor,
  Color? inactiveColor,
}) {
  final colorScheme = Theme.of(context).colorScheme;

  // fallback couleurs
  final Color active = activeColor ?? colorScheme.primaryContainer;
  final Color inactive = inactiveColor ?? colorScheme.surfaceContainerHighest;

  Widget buildIcon(String path, double size, Color? color) {
    final isSvg = path.toLowerCase().endsWith('.svg');
    if (isSvg) {
      // si color == null -> on garde les couleurs originales du SVG
      return color != null
          ? SvgPicture.asset(
              path,
              width: size,
              height: size,
              colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
            )
          : SvgPicture.asset(path, width: size, height: size);
    } else {
      // PNG/JPG : si color == null on n'applique pas de recolor, sinon on applique tint
      return Image.asset(
        path,
        width: size + 8,
        height: size + 8,
        fit: BoxFit.contain,
        color: color, // si null, pas de recolor
      );
    }
  }

  Widget buildOption(int i) {
    final bool isSelected = selected.contains(labels[i]);
    final String lowTitle = title.toLowerCase();
    final bool isHumor =
        lowTitle.contains('humeur') || lowTitle.contains('humeurs');
    final bool isPain =
        lowTitle.contains('douleur') || lowTitle.contains('douleurs');
    final bool isGlaire =
        lowTitle.contains('glaire') || lowTitle.contains('glaires');

    // Taille des icônes (humeurs un peu plus grandes)
    final double iconSize = isHumor ? 36 : 28;

    // Déterminer si on recolore l'icône ; glaires = NO recolor (null)
    Color? iconColor;
    if (isGlaire) {
      iconColor = null; // ne pas recolorer les icônes des glaires
    } else if (isPain || isHumor) {
      // douleurs : inactive = blanc, active = noir
      iconColor = isSelected ? Colors.black : Colors.white;
    } else {
      // fallback : recolor avec la logique active/inactiveTheme
      iconColor = isSelected
          ? colorScheme.onPrimary
          : colorScheme.onSurfaceVariant;
    }

    // couleur du label (garder lisible selon icône recolor)
    Color labelColor;
    if (isGlaire) {
      labelColor = isSelected ? activeColor! : colorScheme.onSurfaceVariant;
    } else if (isPain) {
      labelColor = isSelected ? activeColor! : colorScheme.onSurfaceVariant;
    } else if (isHumor) {
      labelColor = isSelected ? activeColor! : colorScheme.onSurfaceVariant;
    } else {
      labelColor = isSelected
          ? colorScheme.onPrimary
          : colorScheme.onSurfaceVariant;
    }

    return GestureDetector(
      onTap: () {
        if (singleSelection) {
          if (isSelected) {
            onChanged([]);
          } else {
            onChanged([labels[i]]);
          }
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
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected ? active : inactive,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: colorScheme.shadow.withOpacity(0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 2,
                        offset: const Offset(0, 1),
                      ),
                    ],
            ),
            child: Center(
              child: buildIcon(
                icons[i],
                iconSize,
                iconColor, // null => pas de recolor
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 72,
            child: Text(
              labels[i],
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: labelColor,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContent() {
    if (icons.length <= 4) {
      // distribution homogène si <= 4 : on utilise Expanded pour répartir sur toute la largeur
      return Row(
        children: List.generate(icons.length, (i) {
          return Expanded(child: Center(child: buildOption(i)));
        }),
      );
    } else {
      // scroll horizontal si > 4
      return SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          itemCount: icons.length,
          separatorBuilder: (_, _) => const SizedBox(width: 16),
          itemBuilder: (context, i) {
            return buildOption(i);
          },
        ),
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
          const SizedBox(height: 12),
          buildContent(),
        ],
      ),
    ),
  );
}
