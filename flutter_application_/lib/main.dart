import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0A3D62),
          primary: const Color(0xFF0A3D62),
          secondary: const Color(0xFFF1C40F),
        ),
        scaffoldBackgroundColor: const Color(0xFFFDFEFE),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0A3D62),
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF1C40F),
            foregroundColor: const Color(0xFF2C3E50),
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
