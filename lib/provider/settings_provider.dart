import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';
import 'package:restaurant_app/data/preferences/reminder_preferences.dart';
import 'package:restaurant_app/helper/background_service.dart';
import 'package:restaurant_app/helper/notification_helper.dart';

// Provider ini ngatur state untuk fitur reminder notifikasi restoran
class SettingsProvider extends ChangeNotifier {
  // Preferences buat nyimpen status reminder di local storage
  final ReminderPreferences reminderPreferences;

  // Helper buat handle penjadwalan dan cancel notifikasi
  final NotificationHelper notificationHelper;

  // Status apakah reminder aktif atau tidak
  bool _isActive = false;

  // Getter supaya UI bisa akses status reminder
  bool get isActive => _isActive;

  bool _waitingAlarmPermission = false;

  bool get waitingAlarmPermission => _waitingAlarmPermission;

  void setWaitingAlarmPermission(bool value) {
    _waitingAlarmPermission = value;
    notifyListeners();
  }

  // Constructor langsung load status reminder saat provider dibuat
  SettingsProvider(this.reminderPreferences, this.notificationHelper) {
    _load();
  }

  // Ambil status reminder dari preferences
  Future<void> _load() async {
    _isActive = await reminderPreferences.getReminder();
    notifyListeners(); // update UI setelah data didapat
  }

  // Fungsi untuk aktif/nonaktif reminder
  Future<void> toggleReminder(bool value) async {
    _isActive = value;
    notifyListeners(); // update UI saat status berubah

    // Simpan status reminder ke preferences
    await reminderPreferences.setReminder(value);

    if (value) {
      // Jadwalkan notifikasi harian
      await notificationHelper.scheduleDailyReminder(
        body: "Rekomendasi restoran siap 🍽️",
        restaurantId: "",
      );

      // Hapus task lama biar ga duplicate
      await Workmanager().cancelByUniqueName(fetchRestaurantTask);

      // Register task periodic setiap 24 jam
      await Workmanager().registerPeriodicTask(
        fetchRestaurantTask,
        fetchRestaurantTask,
        frequency: const Duration(hours: 24),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ), // hanya jalan kalau ada internet
      );

      // Jalankan task sekali saat pertama kali diaktifkan
      await Workmanager().registerOneOffTask(
        "initialFetch",
        fetchRestaurantTask,
      );
    } else {
      // Cancel semua task background kalau reminder dimatikan
      await Workmanager().cancelByUniqueName(fetchRestaurantTask);

      // Cancel notifikasi yang sudah dijadwalkan
      await notificationHelper.cancelReminder();
    }
  }
}
