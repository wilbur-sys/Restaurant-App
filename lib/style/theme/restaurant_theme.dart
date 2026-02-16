import 'package:flutter/material.dart';
import 'package:restaurant_app/style/colors/restaurant_colors.dart';
import 'package:restaurant_app/style/typography/restaurant_text_styles.dart';

// class untuk menyimpan semua konfigurasi tema aplikasi (light & dark)
class RestaurantTheme {
  // textTheme global, supaya semua text di app pakai style yang konsisten
  static TextTheme get _textTheme {
    return TextTheme(
      displayLarge: RestaurantTextStyles.displayLarge,
      displayMedium: RestaurantTextStyles.displayMedium,
      displaySmall: RestaurantTextStyles.displaySmall,
      headlineLarge: RestaurantTextStyles.headlineLarge,
      headlineMedium: RestaurantTextStyles.headlineMedium,
      headlineSmall: RestaurantTextStyles.headlineSmall,
      titleLarge: RestaurantTextStyles.titleLarge,
      titleMedium: RestaurantTextStyles.titleMedium,
      titleSmall: RestaurantTextStyles.titleSmall,
      bodyLarge: RestaurantTextStyles.bodyLargeBold,
      bodyMedium: RestaurantTextStyles.bodyLargeMedium,
      bodySmall: RestaurantTextStyles.bodyLargeRegular,
      labelLarge: RestaurantTextStyles.labelLarge,
      labelMedium: RestaurantTextStyles.labelMedium,
      labelSmall: RestaurantTextStyles.labelSmall,
    );
  }

  // custom style AppBar, termasuk bentuk dan text style
  static AppBarTheme get _appBarTheme {
    return AppBarTheme(
      toolbarTextStyle: _textTheme.titleLarge,
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(14),
          bottomRight: Radius.circular(14),
        ),
      ),
    );
  }

  // konfigurasi tampilan bottom navigation bar
  static BottomNavigationBarThemeData get _bottomNavTheme {
    return const BottomNavigationBarThemeData(
      selectedItemColor: Colors.greenAccent,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    );
  }

  // tema terang aplikasi
  static ThemeData get lightTheme {
    return ThemeData(
      colorSchemeSeed: RestaurantColors.greenAccent.color, // warna utama tema
      brightness: Brightness.light,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
      bottomNavigationBarTheme: _bottomNavTheme.copyWith(
        backgroundColor: Colors.white,
      ),
    );
  }

  // tema gelap aplikasi
  static ThemeData get darkTheme {
    return ThemeData(
      colorSchemeSeed: RestaurantColors
          .greenAccent
          .color, // tetap pakai warna utama yang sama
      brightness: Brightness.dark,
      textTheme: _textTheme,
      useMaterial3: true,
      appBarTheme: _appBarTheme,
      bottomNavigationBarTheme: _bottomNavTheme.copyWith(
        backgroundColor: const Color(0xFF1E1E1E),
        unselectedItemColor: Colors.white60,
      ),
    );
  }
}
