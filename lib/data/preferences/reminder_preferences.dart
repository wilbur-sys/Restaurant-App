import 'package:shared_preferences/shared_preferences.dart';

// class untuk menyimpan dan mengambil status reminder
class ReminderPreferences {
  // key yang dipakai untuk simpan status reminder
  static const _key = "DAILY_REMINDER";

  // simpan status reminder (true / false)
  Future<void> setReminder(bool value) async {
    // ambil instance SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // simpan value reminder ke storage
    await prefs.setBool(_key, value);
  }

  // ambil status reminder yang tersimpan
  Future<bool> getReminder() async {
    // ambil instance SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // return value reminder, default false kalau belum ada
    return prefs.getBool(_key) ?? false;
  }
}
