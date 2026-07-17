import 'package:flutter/material.dart';

class RiskBadge extends StatelessWidget {
  final String riskLevel;

  const RiskBadge({super.key, required this.riskLevel});

  Color getRiskColor() {
    switch (riskLevel.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.amber.shade700;
      case 'high':
        return Colors.orange;
      case 'critical':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: getRiskColor(),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        riskLevel.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
