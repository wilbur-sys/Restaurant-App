import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:restaurant_app/data/api/restaurant_api_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/static/navigation_route.dart';

// navigatorKey untuk navigasi dari notifikasi
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// class helper untuk handle semua fitur notifikasi
class NotificationHelper {
  // instance plugin notifikasi
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // fungsi untuk inisialisasi notifikasi
  Future<void> init() async {
    // inisialisasi timezone
    tz.initializeTimeZones();

    // set timezone ke Asia/Jakarta
    tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));

    // konfigurasi icon notifikasi android
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // gabungkan semua pengaturan notifikasi
    const initializationSettings = InitializationSettings(
      android: androidSettings,
    );

    // buat channel notifikasi android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'daily_channel',
      'Daily Reminder',
      description: 'Daily lunch reminder',
      importance: Importance.max,
    );

    // daftarkan channel ke sistem android
    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    // inisialisasi plugin notifikasi
    await _plugin.initialize(
      settings: initializationSettings,

      // dijalankan saat notifikasi diklik
      onDidReceiveNotificationResponse: (details) async {
        // ambil restaurantId dari payload
        final String? restaurantId = details.payload;

        // cek kalau payload tidak null
        if (restaurantId != null) {
          try {
            // ambil detail restaurant dari API
            final apiService = RestaurantApiService();
            final response = await apiService.getRestaurantDetail(restaurantId);
            final detail = response.restaurant;

            // convert ke object Restaurant
            final restaurant = Restaurant(
              id: detail.id,
              name: detail.name,
              description: detail.description,
              pictureId: detail.pictureId,
              city: detail.city,
              rating: detail.rating,
            );

            // navigasi ke halaman detail restaurant
            Future.microtask(() {
              // cek navigator tersedia
              if (navigatorKey.currentState != null) {
                // pindah ke halaman detail dengan argument
                navigatorKey.currentState?.pushNamed(
                  NavigationRoute.detailRoute.name,
                  arguments: {
                    "restaurant": restaurant,
                    "heroTag": "notification-${restaurant.id}",
                  },
                );
              }
            });
          } catch (e) {
            // log error kalau gagal ambil detail
            debugPrint("Gagal fetch detail: $e");
          }
        }
      },
    );
  }

  // fungsi untuk menjadwalkan notifikasi harian
  Future<void> scheduleDailyReminder({
    required String body,
    required String restaurantId,
  }) async {
    // jadwalkan notifikasi jam 11 siang setiap hari
    await _plugin.zonedSchedule(
      id: 0,
      title: "Rekomendasi Makan Siang 🍽️",
      body: body,
      scheduledDate: _nextInstanceOfElevenAM(),
      notificationDetails: _notificationDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: restaurantId,
    );
  }

  // fungsi untuk membatalkan notifikasi
  Future<void> cancelReminder() async {
    // cancel notifikasi berdasarkan id
    await _plugin.cancel(id: 0);
  }

  // fungsi untuk menentukan jadwal notifikasi berikutnya
  tz.TZDateTime _nextInstanceOfElevenAM() {
    // ambil waktu sekarang
    final now = tz.TZDateTime.now(tz.local);

    // set waktu target jam 11 siang
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 11);

    // kalau sudah lewat jam 11, jadwalkan besok
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    // return waktu notifikasi
    return scheduled;
  }

  // konfigurasi detail notifikasi
  NotificationDetails _notificationDetails() {
    // pengaturan khusus android
    const androidDetails = AndroidNotificationDetails(
      'daily_channel',
      'Daily Reminder',
      channelDescription: 'Daily lunch reminder',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
      playSound: true,
      enableVibration: true,
      fullScreenIntent: true,
    );

    // return notification details
    return const NotificationDetails(android: androidDetails);
  }
}
