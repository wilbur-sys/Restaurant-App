import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/restaurant_api_service.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/provider/result_state.dart';

// Provider ini dipakai buat handle fitur pencarian restoran dan ngatur state hasilnya
class RestaurantSearchProvider extends ChangeNotifier {
  // Service untuk akses API search restoran
  final RestaurantApiService apiService;

  // Constructor untuk inject apiService ke provider
  RestaurantSearchProvider({required this.apiService});

  // State awal diisi list kosong supaya UI tetap aman
  ResultState _state = HasData<List<Restaurant>>([]);

  // Getter supaya state bisa diakses dari UI
  ResultState get state => _state;

  // Function untuk cari restoran berdasarkan query dari user
  Future<void> searchRestaurant(String query) async {
    // Kalau query kosong, reset state ke list kosong
    if (query.isEmpty) {
      _state = HasData<List<Restaurant>>([]);
      notifyListeners();
      return;
    }

    try {
      // Set state ke loading supaya UI bisa nampilin progress
      _state = Loading();
      notifyListeners();

      // Panggil API untuk cari restoran sesuai query
      final result = await apiService.searchRestaurant(query);

      // Kalau hasil kosong, set state error biar user tau
      if (result.isEmpty) {
        _state = Error('Restoran tidak ditemukan');
      } else {
        // Kalau ada hasil, simpan ke state
        _state = HasData<List<Restaurant>>(result);
      }

      // Notify UI kalau state berubah
      notifyListeners();
    } catch (e) {
      // Kalau terjadi error saat fetch data
      _state = Error('Terjadi kesalahan saat pencarian');
      notifyListeners();
    }
  }
}
