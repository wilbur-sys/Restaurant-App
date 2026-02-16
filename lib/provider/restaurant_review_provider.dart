import 'package:flutter/material.dart';
import 'package:restaurant_app/data/api/restaurant_api_service.dart';
import 'package:restaurant_app/data/model/customer_review.dart';
import 'package:restaurant_app/provider/result_state.dart';

// provider untuk handle submit dan state customer review
class RestaurantReviewProvider extends ChangeNotifier {
  // instance API service untuk kirim review
  final RestaurantApiService apiService;

  // constructor untuk inisialisasi apiService
  RestaurantReviewProvider({required this.apiService});

  // state awal dengan data kosong
  ResultState _state = HasData<List<CustomerReview>>([]);

  // getter untuk akses state review
  ResultState get state => _state;

  bool _hasSubmitted = false;

  bool get hasSubmitted => _hasSubmitted;

  void markSubmitted() {
    _hasSubmitted = true;
    notifyListeners();
  }

  void resetSubmission() {
    _hasSubmitted = false;
  }

  // fungsi untuk kirim review ke API
  Future<void> submitReview({
    required String restaurantId,
    required String name,
    required String review,
  }) async {
    try {
      // set state ke loading saat kirim review
      _state = Loading();
      notifyListeners();

      // kirim review ke API
      final reviews = await apiService.addReview(
        id: restaurantId,
        name: name,
        review: review,
      );

      // set state ke hasData kalau berhasil
      _state = HasData<List<CustomerReview>>(reviews);
      notifyListeners();
    } catch (e) {
      // set state ke error kalau gagal kirim review
      _state = Error('Gagal mengirim review');
      notifyListeners();
    }
  }
}
