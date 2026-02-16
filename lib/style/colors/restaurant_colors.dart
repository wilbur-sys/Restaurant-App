import 'package:flutter/material.dart';

// enum untuk menyimpan daftar warna yang digunakan di aplikasi
// supaya warna konsisten dan mudah dipanggil dari satu tempat
enum RestaurantColors {
  // warna utama aplikasi, dipakai sebagai aksen UI
  greenAccent("GreenAccent", Colors.greenAccent);

  // constructor untuk menyimpan nama dan nilai warna
  const RestaurantColors(this.name, this.color);

  // nama warna, bisa dipakai untuk identifikasi atau setting
  final String name;

  // nilai warna asli yang digunakan di widget
  final Color color;
}
