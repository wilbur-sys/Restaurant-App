import 'package:flutter/material.dart';
import 'package:restaurant_app/data/db/database_helper.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';

// provider untuk handle state favorite restaurant
class FavoriteProvider extends ChangeNotifier {
  // instance database helper untuk akses database
  final DatabaseHelper _dbHelper = DatabaseHelper();

  // list restaurant yang difavorite
  List<Restaurant> _favorites = [];

  // set id favorite untuk cek lebih cepat
  Set<String> _favoriteIds = {};

  // status loading saat ambil data
  bool _isLoading = false;

  // getter untuk akses list favorite
  List<Restaurant> get favorites => _favorites;

  // getter untuk cek status loading
  bool get isLoading => _isLoading;

  // load semua favorite dari database
  Future<void> loadFavorites() async {
    // set loading true
    _isLoading = true;
    notifyListeners();

    // ambil data favorite dari database
    _favorites = await _dbHelper.getFavorites();

    // simpan semua id favorite ke set
    _favoriteIds = _favorites.map((e) => e.id).toSet();

    // set loading false setelah selesai
    _isLoading = false;
    notifyListeners();
  }

  // tambah restaurant ke favorite
  Future<void> addFavorite(Restaurant restaurant) async {
    // log untuk debug proses add favorite
    debugPrint("ADD FAVORITE START");

    // cek kalau sudah favorite, tidak ditambahkan lagi
    if (_favoriteIds.contains(restaurant.id)) return;

    // tambah ke list dan set
    _favorites.add(restaurant);
    _favoriteIds.add(restaurant.id);
    notifyListeners();

    // simpan ke database
    await _dbHelper.insertFavorite(restaurant);

    // log selesai add favorite
    debugPrint("ADD FAVORITE END");
  }

  // hapus restaurant dari favorite
  Future<void> removeFavorite(String id) async {
    // hapus dari list favorite
    _favorites.removeWhere((r) => r.id == id);

    // hapus dari set id favorite
    _favoriteIds.remove(id);
    notifyListeners();

    // hapus dari database
    await _dbHelper.removeFavorite(id);
  }

  // cek apakah restaurant sudah difavorite
  bool isFavorite(String id) {
    // return true kalau id ada di set favorite
    return _favoriteIds.contains(id);
  }
}
