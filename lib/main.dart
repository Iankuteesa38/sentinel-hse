import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const SentinelHSEApp());
}

class SentinelHSEApp extends StatelessWidget {
  const SentinelHSEApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sentinel HSE',
      debugShowCheckedModeBanner: false,
      
      theme: AppTheme.lightTheme,
      home: const DashboardPage(),
    );
  }
}