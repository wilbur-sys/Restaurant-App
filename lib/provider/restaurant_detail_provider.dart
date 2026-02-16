import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_detail_response.dart';
import '../data/api/restaurant_api_service.dart';
import 'result_state.dart';

// provider untuk handle state detail restaurant
class RestaurantDetailProvider extends ChangeNotifier {
  // instance API service untuk ambil data
  final RestaurantApiService apiService;

  // id restaurant yang akan diambil detailnya
  final String restaurantId;

  // constructor dan langsung fetch detail restaurant
  RestaurantDetailProvider({
    required this.apiService,
    required this.restaurantId,
  }) {
    fetchRestaurantDetail(); // otomatis load data saat provider dibuat
  }

  // state untuk menyimpan kondisi (loading, success, error)
  ResultState _state = Loading();

  // getter untuk akses state
  ResultState get state => _state;

  // fungsi untuk ambil detail restaurant dari API
  Future<void> fetchRestaurantDetail() async {
    try {
      // set state ke loading
      _state = Loading();
      notifyListeners();

      // request detail restaurant dari API
      final result = await apiService.getRestaurantDetail(restaurantId);

      // set state ke hasData kalau berhasil
      _state = HasData<RestaurantDetailResponse>(result);
      notifyListeners();
    } catch (e) {
      // pesan error default
      String message = 'Terjadi kesalahan. Silakan coba lagi.';

      // cek kalau error karena tidak ada internet
      if (e.toString().contains('Failed to fetch') ||
          e.toString().contains('SocketException')) {
        message = 'Tidak ada koneksi internet.\nSilakan periksa jaringan Anda.';
      }

      // set state ke error
      _state = Error(message);
      notifyListeners();
    }
  }

  // fungsi untuk refresh data detail restaurant
  Future<void> refresh() async {
    // panggil ulang fetch detail
    await fetchRestaurantDetail();
  }
}
