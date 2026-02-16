import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/data/model/customer_review.dart';
import 'package:restaurant_app/data/model/restaurant_detail_response.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import '../model/restaurant_list_response.dart';

// class ini dipakai untuk handle semua request API restaurant
class RestaurantApiService {
  // base URL API dari dicoding
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  // ambil semua data restaurant dari endpoint list
  Future<RestaurantListResponse> getRestaurantList() async {
    // kirim request GET ke endpoint list
    final response = await http.get(Uri.parse('$_baseUrl/list'));

    // cek apakah request berhasil
    if (response.statusCode == 200) {
      // convert JSON response ke object RestaurantListResponse
      return RestaurantListResponse.fromJson(json.decode(response.body));
    } else {
      // lempar error kalau gagal load data
      throw Exception('Gagal memuat daftar restoran');
    }
  }

  // ambil detail restaurant berdasarkan id
  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    // request GET ke endpoint detail dengan id
    final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));

    // cek apakah response sukses
    if (response.statusCode == 200) {
      // convert JSON ke object RestaurantDetailResponse
      return RestaurantDetailResponse.fromJson(json.decode(response.body));
    } else {
      // error kalau gagal ambil detail
      throw Exception('Failed to load restaurant detail');
    }
  }

  // cari restaurant berdasarkan query
  Future<List<Restaurant>> searchRestaurant(String query) async {
    // request GET ke endpoint search dengan parameter query
    final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));

    // cek apakah request berhasil
    if (response.statusCode == 200) {
      // decode response JSON
      final result = json.decode(response.body);

      // convert list JSON ke List<Restaurant>
      return List<Restaurant>.from(
        result['restaurants'].map((x) => Restaurant.fromJson(x)),
      );
    } else {
      // error kalau pencarian gagal
      throw Exception('Gagal mencari restoran');
    }
  }

  // tambah review baru ke restaurant
  Future<List<CustomerReview>> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    // kirim request POST ke endpoint review
    final response = await http.post(
      Uri.parse('$_baseUrl/review'),

      // header untuk format JSON
      headers: {'Content-Type': 'application/json'},

      // body berisi id, nama, dan review
      body: jsonEncode({'id': id, 'name': name, 'review': review}),
    );

    // cek apakah request berhasil dibuat
    if (response.statusCode == 201 || response.statusCode == 200) {
      // decode response JSON
      final result = json.decode(response.body);

      // convert ke List<CustomerReview>
      return List<CustomerReview>.from(
        result['customerReviews'].map((x) => CustomerReview.fromJson(x)),
      );
    } else {
      // error kalau gagal tambah review
      throw Exception('Gagal menambahkan review');
    }
  }

  // ambil 1 restaurant random dari list
  Future<Restaurant> getRandomRestaurant() async {
    // ambil semua restaurant dulu
    final response = await getRestaurantList();

    // simpan ke variable list
    final list = response.restaurants;

    // acak urutan list
    list.shuffle();

    // ambil restaurant pertama dari hasil shuffle
    return list.first;
  }
}
