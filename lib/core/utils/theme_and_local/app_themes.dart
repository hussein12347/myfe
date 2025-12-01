import 'package:flutter/material.dart';

class AppThemes {
  // دالة مساعدة لإنشاء ثيم فاتح
  static ThemeData _createLightTheme({
    required Color primary,
    required Color secondary,
    Color onPrimary = Colors.white,
    Color onSecondary = Colors.black,
  }) {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFDFDFD),
      primaryColor: primary,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          color: Color(0xFF1E1E1E),
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
      primaryTextTheme: const TextTheme(
        titleLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: Colors.white,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
        onSurface: Colors.black,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFFF2F4F7),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(
          color: Color(0xFF6C757D),
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.black87,
      ),
    );
  }

  // دالة مساعدة لإنشاء ثيم داكن
  static ThemeData _createDarkTheme({
    required Color primary,
    required Color secondary,
    Color onPrimary = Colors.white,
    Color onSecondary = Colors.black,
  }) {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xff100B29),
      primaryColor: const Color(0xff100B20),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xff100B20),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: Colors.white,
        onPrimary: onPrimary,
        onSecondary: onSecondary,
        onSurface: Colors.black,
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
      primaryTextTheme: const TextTheme(
        titleLarge: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xff1E1E2C),
        selectedItemColor: secondary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Cairo',
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(fontFamily: 'Cairo'),
        type: BottomNavigationBarType.fixed,
        elevation: 12,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Color(0xff1E1E2C),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
          borderSide: BorderSide.none,
        ),
        hintStyle: TextStyle(
          color: Colors.white70,
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    );
  }

  // قوائم الثيمات
  static final Map<String, ThemeData> lightThemes = {
    'blue': _createLightTheme(
      primary: Colors.blue,
      secondary: Colors.lightBlue,
    ),
    'red': _createLightTheme(
      primary: Colors.red,
      secondary: Colors.redAccent,
    ),
    'green': _createLightTheme(
      primary: Colors.green,
      secondary: Colors.greenAccent,
    ),

    'purple': _createLightTheme(
      primary: Colors.purple,
      secondary: Colors.purpleAccent,
    ),
    'orange': _createLightTheme(
      primary: Colors.orange,
      secondary: Colors.orangeAccent,
    ),
    'teal': _createLightTheme(
      primary: Colors.teal,
      secondary: Colors.tealAccent,
    ),
    'pink': _createLightTheme(
      primary: Colors.pink,
      secondary: Colors.pinkAccent,
    ),
    'cyan': _createLightTheme(
      primary: Colors.cyan,
      secondary: Colors.cyanAccent,
    ),
    'indigo': _createLightTheme(
      primary: Colors.indigo,
      secondary: Colors.indigoAccent,
    ),
    'brown': _createLightTheme(
      primary: Colors.brown,
      secondary: Colors.brown[300]!,
    ),

    'amber': _createLightTheme(
      primary: Colors.amber,
      secondary: Colors.amberAccent,
      onPrimary: Colors.black,
    ),
    'deepPurple': _createLightTheme(
      primary: Colors.deepPurple,
      secondary: Colors.deepPurpleAccent,
    ),

  };

  static final Map<String, ThemeData> darkThemes = {
    'blue': _createDarkTheme(
      primary: Colors.blue,
      secondary: Colors.lightBlueAccent,
    ),
    'red': _createDarkTheme(
      primary: Colors.red,
      secondary: Colors.redAccent,
    ),
    'green': _createDarkTheme(
      primary: Colors.green,
      secondary: Colors.greenAccent,
    ),

    'purple': _createDarkTheme(
      primary: Colors.purple,
      secondary: Colors.purpleAccent,
    ),
    'orange': _createDarkTheme(
      primary: Colors.orange,
      secondary: Colors.orangeAccent,
    ),
    'teal': _createDarkTheme(
      primary: Colors.teal,
      secondary: Colors.tealAccent,
    ),
    'pink': _createDarkTheme(
      primary: Colors.pink,
      secondary: Colors.pinkAccent,
    ),
    'cyan': _createDarkTheme(
      primary: Colors.cyan,
      secondary: Colors.cyanAccent,
    ),
    'indigo': _createDarkTheme(
      primary: Colors.indigo,
      secondary: Colors.indigoAccent,
    ),
    'brown': _createDarkTheme(
      primary: Colors.brown,
      secondary: Colors.brown[300]!,
    ),

    'amber': _createDarkTheme(
      primary: Colors.amber,
      secondary: Colors.amberAccent,
      onPrimary: Colors.black,
    ),
    'deepPurple': _createDarkTheme(
      primary: Colors.deepPurple,
      secondary: Colors.deepPurpleAccent,
    ),

  };
}