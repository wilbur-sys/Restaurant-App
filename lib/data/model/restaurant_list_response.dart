import 'restaurant_list.dart';

// model untuk menyimpan response list restaurant dari API
class RestaurantListResponse {
  // status apakah terjadi error atau tidak
  final bool error;

  // pesan response dari API
  final String message;

  // list restaurant yang didapat dari API
  final List<Restaurant> restaurants;

  // constructor untuk inisialisasi data response
  RestaurantListResponse({
    required this.error,
    required this.message,
    required this.restaurants,
  });

  // factory untuk convert JSON ke object RestaurantListResponse
  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) {
    // convert JSON restaurants ke List<Restaurant>
    return RestaurantListResponse(
      error: json['error'],
      message: json['message'],
      restaurants: List<Restaurant>.from(
        json['restaurants'].map((x) => Restaurant.fromJson(x)),
      ),
    );
  }
}
