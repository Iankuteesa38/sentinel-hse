import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';

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
      theme: ThemeData(
        fontFamily: 'Arial',
        useMaterial3: true,
      ),
      home: const DashboardPage(),
    );
  }
}