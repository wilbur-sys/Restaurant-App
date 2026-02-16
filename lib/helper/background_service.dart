import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';
import 'package:restaurant_app/data/api/restaurant_api_service.dart';
import 'package:restaurant_app/data/preferences/restaurant_cache_preferences.dart';
import 'package:restaurant_app/helper/notification_helper.dart';

// konstanta nama task untuk fetch restaurant
const String fetchRestaurantTask = "fetchRestaurantTask";

// fungsi entry point untuk background task
@pragma('vm:entry-point')
void callbackDispatcher() {
  // jalankan task yang didaftarkan di workmanager
  Workmanager().executeTask((task, inputData) async {
    // log untuk memastikan workmanager berjalan
    debugPrint("WORKMANAGER RUNNING");

    // inisialisasi flutter binding di background
    WidgetsFlutterBinding.ensureInitialized();

    // registrasi plugin supaya bisa dipakai di isolate
    DartPluginRegistrant.ensureInitialized();

    try {
      // buat instance API service
      final api = RestaurantApiService();

      // ambil list restaurant dari API
      final result = await api.getRestaurantList();

      // simpan list restaurant
      final restaurants = result.restaurants;

      // cek kalau list restaurant tidak kosong
      if (restaurants.isNotEmpty) {
        // acak list untuk dapat restaurant random
        restaurants.shuffle();

        // ambil restaurant pertama
        final random = restaurants.first;

        // log nama restaurant random
        debugPrint("Random restaurant: ${random.name}");

        // buat instance cache preferences
        final cache = RestaurantCachePreferences();

        // simpan restaurant random ke cache
        await cache.saveRestaurant(
          id: random.id,
          name: random.name,
          pictureId: random.pictureId,
          rating: random.rating,
        );

        // buat instance notification helper
        final notificationHelper = NotificationHelper();

        // inisialisasi notification
        await notificationHelper.init();

        // batalkan reminder sebelumnya
        await notificationHelper.cancelReminder();

        // jadwalkan reminder baru dengan restaurant random
        await notificationHelper.scheduleDailyReminder(
          body: random.name,
          restaurantId: random.id,
        );
      }

      // return true kalau task berhasil
      return Future.value(true);
    } catch (e) {
      // return false kalau terjadi error
      return Future.value(false);
    }
  });
}
