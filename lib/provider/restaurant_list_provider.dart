import 'package:flutter/material.dart';
import '../data/api/restaurant_api_service.dart';
import '../data/model/restaurant_list.dart';
import 'result_state.dart';

// provider untuk handle state list restaurant
class RestaurantListProvider extends ChangeNotifier {
  // instance API service untuk ambil data
  final RestaurantApiService apiService;

  // constructor dan langsung fetch list restaurant
  RestaurantListProvider({required this.apiService}) {
    fetchRestaurantList(); // otomatis load data saat provider dibuat
  }

  // state untuk menyimpan kondisi loading, success, atau error
  ResultState _state = Loading();

  // getter untuk akses state
  ResultState get state => _state;

  // fungsi untuk ambil list restaurant dari API
  Future<void> fetchRestaurantList() async {
    try {
      // set state ke loading
      _state = Loading();
      notifyListeners();

      // request data restaurant dari API
      final result = await apiService.getRestaurantList();

      // set state ke hasData kalau berhasil
      _state = HasData<List<Restaurant>>(result.restaurants);
    } catch (e) {
      // pesan error default
      String message = 'Terjadi kesalahan. Silakan coba lagi.';

      // cek kalau error karena tidak ada internet
      if (e.toString().contains('Failed to fetch') ||
          e.toString().contains('SocketException')) {
        message = 'Tidak ada koneksi internet.\nPeriksa kembali jaringan.';
      }

      // set state ke error
      _state = Error(message);
    }

    // update UI setelah proses selesai
    notifyListeners();
  }

  // fungsi untuk refresh list restaurant
  Future<void> refresh() async {
    // panggil ulang fetch data
    await fetchRestaurantList();
  }
}
