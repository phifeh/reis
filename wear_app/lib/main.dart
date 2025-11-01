import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ReisWearApp());
}

class ReisWearApp extends StatelessWidget {
  const ReisWearApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'REIS Wear',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: const Color(0xFFE07A5F),
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFE07A5F),
          secondary: Color(0xFF81B29A),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
