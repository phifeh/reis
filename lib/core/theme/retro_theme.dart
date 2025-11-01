import 'package:flutter/material.dart';

class RetroTheme {
  // Retro-inspired color palette - warm, earthy, meditative
  static const Color warmBeige = Color(0xFFF5E6D3);
  static const Color softCream = Color(0xFFFFF8E7);
  static const Color vintageOrange = Color(0xFFE07A5F);
  static const Color dustyRose = Color(0xFFD4A5A5);
  static const Color sageBrown = Color(0xFF8B7355);
  static const Color deepTaupe = Color(0xFF6B5B4F);
  static const Color charcoal = Color(0xFF3D3D3D);
  static const Color softMint = Color(0xFFB8D4C6);
  static const Color paleOlive = Color(0xFFCAC4B0);
  static const Color mutedTeal = Color(0xFF81B29A);

  // Typography - serif fonts for that vintage feel
  static const String serifFont = 'Spectral';
  static const String monoFont = 'Courier';

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      colorScheme: ColorScheme.light(
        primary: vintageOrange,
        onPrimary: softCream,
        secondary: mutedTeal,
        onSecondary: softCream,
        surface: warmBeige,
        onSurface: charcoal,
        error: dustyRose,
        onError: softCream,
        tertiary: sageBrown,
        surfaceContainerHighest: paleOlive,
      ),

      scaffoldBackgroundColor: softCream,

      // AppBar with retro feel
      appBarTheme: AppBarTheme(
        backgroundColor: warmBeige,
        foregroundColor: charcoal,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontFamily: serifFont,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: charcoal,
          letterSpacing: 1.2,
        ),
        iconTheme: const IconThemeData(
          color: deepTaupe,
          size: 24,
        ),
      ),

      // Card with vintage paper feel
      cardTheme: const CardThemeData(
        color: warmBeige,
        elevation: 2,
        shadowColor: Color(0x1A3D3D3D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          side: BorderSide(
            color: Color(0x4DCAC4B0),
            width: 1,
          ),
        ),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),

      // Floating Action Button - retro round button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: vintageOrange,
        foregroundColor: softCream,
        elevation: 4,
        shape: CircleBorder(),
      ),

      // Text theme with serif fonts
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: serifFont,
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: charcoal,
          letterSpacing: -0.25,
        ),
        displayMedium: TextStyle(
          fontFamily: serifFont,
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: charcoal,
        ),
        displaySmall: TextStyle(
          fontFamily: serifFont,
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: charcoal,
        ),
        headlineLarge: TextStyle(
          fontFamily: serifFont,
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: charcoal,
          letterSpacing: 0.5,
        ),
        headlineMedium: TextStyle(
          fontFamily: serifFont,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: charcoal,
        ),
        headlineSmall: TextStyle(
          fontFamily: serifFont,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: charcoal,
        ),
        titleLarge: TextStyle(
          fontFamily: serifFont,
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: deepTaupe,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          fontFamily: serifFont,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: deepTaupe,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          fontFamily: serifFont,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: deepTaupe,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontFamily: serifFont,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: charcoal,
          letterSpacing: 0.5,
          height: 1.6,
        ),
        bodyMedium: TextStyle(
          fontFamily: serifFont,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: charcoal,
          letterSpacing: 0.25,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontFamily: serifFont,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: sageBrown,
          letterSpacing: 0.4,
          height: 1.4,
        ),
        labelLarge: TextStyle(
          fontFamily: serifFont,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: deepTaupe,
          letterSpacing: 1.25,
        ),
        labelMedium: TextStyle(
          fontFamily: monoFont,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: sageBrown,
          letterSpacing: 1.0,
        ),
        labelSmall: TextStyle(
          fontFamily: monoFont,
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: sageBrown,
          letterSpacing: 0.5,
        ),
      ),

      // Icon theme
      iconTheme: const IconThemeData(
        color: deepTaupe,
        size: 24,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: paleOlive.withOpacity(0.4),
        thickness: 1,
        space: 24,
      ),

      // Input decoration with vintage feel
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: warmBeige,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          borderSide: BorderSide(color: paleOlive, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(2)),
          borderSide: BorderSide(color: paleOlive.withOpacity(0.5), width: 1),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
          borderSide: BorderSide(color: vintageOrange, width: 2),
        ),
        labelStyle: const TextStyle(
          fontFamily: serifFont,
          color: sageBrown,
          fontSize: 14,
        ),
        hintStyle: TextStyle(
          fontFamily: serifFont,
          color: sageBrown.withOpacity(0.6),
          fontSize: 14,
        ),
        contentPadding: const EdgeInsets.all(16),
      ),

      // Elevated button with retro feel
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: vintageOrange,
          foregroundColor: softCream,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          textStyle: const TextStyle(
            fontFamily: serifFont,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.0,
          ),
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: deepTaupe,
          textStyle: const TextStyle(
            fontFamily: serifFont,
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.75,
          ),
        ),
      ),

      // Chip theme for tags
      chipTheme: const ChipThemeData(
        backgroundColor: paleOlive,
        selectedColor: mutedTeal,
        labelStyle: TextStyle(
          fontFamily: monoFont,
          fontSize: 11,
          color: charcoal,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      ),
    );
  }

  // Custom decorations for retro feel
  static BoxDecoration paperTexture = BoxDecoration(
    color: warmBeige,
    boxShadow: [
      BoxShadow(
        color: charcoal.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(2, 2),
      ),
    ],
  );

  static BoxDecoration vintageCard = BoxDecoration(
    color: softCream,
    border: Border.all(color: paleOlive.withOpacity(0.3), width: 1),
    boxShadow: [
      BoxShadow(
        color: charcoal.withOpacity(0.05),
        blurRadius: 4,
        offset: const Offset(1, 1),
      ),
    ],
  );

  // Time formatting in retro mono style
  static String formatRetroTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static String formatRetroDate(DateTime date) {
    const months = [
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ];
    final day = date.day.toString().padLeft(2, '0');
    final month = months[date.month - 1];
    final year = date.year;
    return '$day $month $year';
  }
}
