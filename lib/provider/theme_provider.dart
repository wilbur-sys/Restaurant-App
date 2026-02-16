import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider ini ngatur state tema (light / dark mode)
class ThemeProvider extends ChangeNotifier {
  // Key untuk simpan status tema di SharedPreferences
  static const _themeKey = 'isDarkMode';

  // Default tema light saat pertama kali dijalankan
  ThemeMode _themeMode = ThemeMode.light;

  // Getter supaya UI bisa ambil tema saat ini
  ThemeMode get themeMode => _themeMode;

  // Constructor langsung load tema yang tersimpan
  ThemeProvider() {
    _loadTheme();
  }

  // Ambil status tema dari SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool(_themeKey) ?? false;

    // Tentukan themeMode berdasarkan nilai yang disimpan
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // update UI setelah tema dimuat
  }

  // Fungsi untuk ganti tema dan simpan ke SharedPreferences
  Future<void> toggleTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);

    // Update themeMode sesuai pilihan user
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners(); // refresh UI biar tema langsung berubah
  }

  // Getter untuk cek apakah mode dark aktif
  bool get isDarkMode => _themeMode == ThemeMode.dark;
}
