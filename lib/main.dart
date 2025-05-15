import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/game_screen.dart';
import 'providers/game_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        title: 'Taureaux et Chevaux',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF6B4423), // Couleur marron pour le thème taureau
            primary: const Color(0xFF6B4423),
            secondary: const Color(0xFF8B4513),
            tertiary: const Color(0xFFD2691E),
            background: const Color(0xFFFFF8DC),
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF6B4423),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF8B4513),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF6B4423)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF8B4513), width: 2),
            ),
          ),
        ),
        home: const GameScreen(),
      ),
    );
  }
} 