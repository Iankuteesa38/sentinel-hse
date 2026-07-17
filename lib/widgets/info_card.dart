import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final Widget child;
  final double iconSize;
  final EdgeInsetsGeometry padding;
  final double elevation;
  final CrossAxisAlignment alignment;

  const InfoCard({
    super.key,
    required this.backgroundColor,
    required this.icon,
    required this.child,
    this.iconSize = 28,
    this.padding = const EdgeInsets.all(16),
    this.elevation = 2,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: padding,
        child: Row(
          crossAxisAlignment: alignment,
          children: [
            Icon(icon, size: iconSize),
            const SizedBox(width: 12),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
