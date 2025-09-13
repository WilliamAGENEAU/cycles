import 'package:flutter/material.dart';

class CircleOption<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final VoidCallback onTap;
  final Widget child;

  const CircleOption({
    super.key,
    required this.value,
    required this.groupValue,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final bool selected = value == groupValue;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.all(selected ? 14 : 10),
        decoration: BoxDecoration(
          color: selected ? Color(0xFFF48FB1) : Colors.white,
          shape: BoxShape.circle,
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 6),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
          border: Border.all(
            color: selected ? Colors.transparent : Colors.grey.shade200,
          ),
        ),
        child: DefaultTextStyle(
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontSize: 13,
          ),
          child: child,
        ),
      ),
    );
  }
}
