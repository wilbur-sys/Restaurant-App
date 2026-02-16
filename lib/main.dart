import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:restaurant_app/data/api/restaurant_api_service.dart';
import 'package:restaurant_app/data/preferences/reminder_preferences.dart';
import 'package:restaurant_app/helper/background_service.dart';
import 'package:restaurant_app/helper/notification_helper.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/provider/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/provider/settings_provider.dart';
import 'package:restaurant_app/provider/theme_provider.dart';

import 'package:restaurant_app/screen/detail/detail_screen.dart';
import 'package:restaurant_app/screen/main/main_screen.dart';

import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/style/theme/restaurant_theme.dart';
import 'package:restaurant_app/screen/settings/settings_screen.dart';
import 'package:workmanager/workmanager.dart';
import 'package:restaurant_app/provider/navigation_provider.dart';

void main() async {
  // memastikan binding Flutter siap sebelum init async
  WidgetsFlutterBinding.ensureInitialized();

  // inisialisasi helper notifikasi untuk reminder
  final notificationHelper = NotificationHelper();
  await notificationHelper.init();

  // inisialisasi Workmanager untuk background task reminder
  await Workmanager().initialize(callbackDispatcher);

  // inisialisasi preferences untuk menyimpan status reminder
  final reminderPreferences = ReminderPreferences();

  runApp(
    // MultiProvider untuk inject semua provider global
    MultiProvider(
      providers: [
        // provider untuk bottom navigation
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        // provider untuk ambil list restoran dari API
        ChangeNotifierProvider(
          create: (_) =>
              RestaurantListProvider(apiService: RestaurantApiService()),
        ),

        // provider untuk mengelola data restoran favorit
        ChangeNotifierProvider(
          create: (_) => FavoriteProvider()..loadFavorites(),
        ),

        // provider untuk fitur pencarian restoran
        ChangeNotifierProvider(
          create: (_) =>
              RestaurantSearchProvider(apiService: RestaurantApiService()),
        ),

        // provider untuk mengelola tema aplikasi
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // provider untuk pengaturan reminder notifikasi
        ChangeNotifierProvider(
          create: (_) =>
              SettingsProvider(reminderPreferences, notificationHelper),
        ),
      ],

      // widget utama aplikasi
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // mengambil theme provider untuk menentukan mode tema
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      // navigatorKey dipakai untuk navigasi dari background service
      navigatorKey: navigatorKey,

      title: 'Restaurant App',

      // tema terang aplikasi
      theme: RestaurantTheme.lightTheme,

      // tema gelap aplikasi
      darkTheme: RestaurantTheme.darkTheme,

      // mode tema mengikuti pilihan user
      themeMode: themeProvider.themeMode,

      // route awal saat app dibuka
      initialRoute: NavigationRoute.mainRoute.name,

      // daftar semua route yang tersedia
      routes: {
        NavigationRoute.mainRoute.name: (_) => MainScreen(),
        NavigationRoute.detailRoute.name: (_) => const DetailScreen(),
        NavigationRoute.settingsRoute.name: (_) => const SettingsScreen(),
      },
    );
  }
}
