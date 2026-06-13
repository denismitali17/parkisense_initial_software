import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ParkiSenseApp());
}

class ParkiSenseApp extends StatelessWidget {
  const ParkiSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkiSense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1F3864),
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}