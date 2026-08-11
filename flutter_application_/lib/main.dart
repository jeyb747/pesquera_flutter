import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/home_screen.dart';
import 'widgets/pesquera_style.dart';

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
        textTheme: GoogleFonts.cinzelTextTheme(),
        colorScheme: ColorScheme.fromSeed(
          seedColor: PesqueraStyle.navy,
          primary: PesqueraStyle.navy,
          secondary: PesqueraStyle.yellow,
        ),
        scaffoldBackgroundColor: PesqueraStyle.softBlue,
        appBarTheme: const AppBarTheme(
          backgroundColor: PesqueraStyle.navy,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: PesqueraStyle.yellow,
            foregroundColor: PesqueraStyle.ink,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
