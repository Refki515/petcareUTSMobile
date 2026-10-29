import 'package:flutter/material.dart';
import 'view/home_page.dart';

void main() {
  runApp(const PetCareApp());
}

class PetCareApp extends StatelessWidget {
  const PetCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    const accent = Color(0xFFFFAE45);
    final colors =
        ColorScheme.fromSeed(
          seedColor: accent,
          brightness: Brightness.light,
        ).copyWith(
          primary: accent,
          onPrimary: const Color(0xFF342513),
          surface: const Color(0xFFF6F6F5),
          onSurface: const Color(0xFF202020),
          onSurfaceVariant: const Color(0xFF73716D),
          outlineVariant: const Color(0xFFEAE8E4),
          primaryContainer: const Color(0xFFFFEED5),
          onPrimaryContainer: const Color(0xFF80501C),
        );
    OutlineInputBorder inputBorder(Color color) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color),
    );
    return MaterialApp(
      title: 'PetCare',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
        colorScheme: colors,
        scaffoldBackgroundColor: colors.surface,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.8,
            height: 1.22,
          ),
          headlineSmall: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.6,
            height: 1.25,
          ),
          titleLarge: TextStyle(fontSize: 19, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16, height: 1.6),
          bodyMedium: TextStyle(fontSize: 14, height: 1.55),
          bodySmall: TextStyle(fontSize: 12, height: 1.5),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: colors.surface,
          foregroundColor: colors.onSurface,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Roboto',
            color: colors.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(color: colors.onSurfaceVariant, fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: inputBorder(colors.outlineVariant),
          enabledBorder: inputBorder(colors.outlineVariant),
          focusedBorder: inputBorder(accent),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.white,
          selectedColor: colors.primary,
          side: BorderSide(color: colors.outlineVariant),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          labelStyle: TextStyle(
            fontFamily: 'Roboto',
            color: colors.onSurface,
            fontSize: 13,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
          showCheckmark: false,
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            minimumSize: const Size(48, 48),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: const Color(0xFF8B5700)),
        ),
        dividerTheme: DividerThemeData(
          color: colors.outlineVariant,
          thickness: 1,
          space: 1,
        ),
      ),
      home: const PetCareShell(),
    );
  }
}
