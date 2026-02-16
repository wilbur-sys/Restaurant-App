import 'package:restaurant_app/data/model/restaurant_detail.dart';

// model untuk menyimpan response detail restaurant dari API
class RestaurantDetailResponse {
  // status apakah terjadi error atau tidak
  final bool error;

  // pesan response dari API
  final String message;

  // object restaurant detail yang didapat dari API
  final RestaurantDetail restaurant;

  // constructor untuk inisialisasi data response
  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  // factory untuk convert JSON ke object RestaurantDetailResponse
  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    // ambil data error, message, dan restaurant dari JSON
    return RestaurantDetailResponse(
      error: json['error'],
      message: json['message'],
      restaurant: RestaurantDetail.fromJson(json['restaurant']),
    );
  }
}
