import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/navigation_provider.dart';
import 'package:restaurant_app/screen/favorite/favorite_screen.dart';
import 'package:restaurant_app/screen/home/home_screen.dart';
import 'package:restaurant_app/screen/search/search_screen.dart';
import 'package:restaurant_app/screen/settings/settings_screen.dart';

// Struktur utama aplikasi yang mengelola navigasi antar halaman
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Sinkronisasi status indeks navigasi melalui provider
    final navProvider = context.watch<NavigationProvider>();

    return Scaffold(
      // Manajemen tumpukan halaman berdasarkan indeks yang aktif
      body: IndexedStack(
        index: navProvider.currentIndex,
        children: const [
          HomeScreen(),
          SearchScreen(),
          FavoriteScreen(),
          SettingsScreen(),
        ],
      ),

      // Bilah navigasi bawah untuk perpindahan antar menu utama
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navProvider.currentIndex,
        onTap: (index) {
          // Pembaruan indeks halaman melalui kontrol provider
          context.read<NavigationProvider>().changeIndex(index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            tooltip: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
            tooltip: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorite",
            tooltip: "Favorite",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Pengaturan",
            tooltip: "Pengaturan",
          ),
        ],
      ),
    );
  }
}
