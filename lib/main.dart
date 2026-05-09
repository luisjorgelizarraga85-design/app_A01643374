import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const CellCounterApp());
}

class CellCounterApp extends StatelessWidget {
  const CellCounterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cell Counter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0077B6),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}