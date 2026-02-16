import 'package:shared_preferences/shared_preferences.dart';

// class untuk menyimpan cache restaurant random
class RestaurantCachePreferences {
  // key untuk simpan id restaurant
  static const _idKey = "RANDOM_RESTAURANT_ID";

  // key untuk simpan nama restaurant
  static const _nameKey = "RANDOM_RESTAURANT_NAME";

  // key untuk simpan picture restaurant
  static const _pictureKey = "RANDOM_RESTAURANT_PICTURE";

  // key untuk simpan rating restaurant
  static const _ratingKey = "RANDOM_RESTAURANT_RATING";

  // simpan data restaurant ke SharedPreferences
  Future<void> saveRestaurant({
    required String id,
    required String name,
    required String pictureId,
    required double rating,
  }) async {
    // ambil instance SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // simpan semua data restaurant
    await prefs.setString(_idKey, id);
    await prefs.setString(_nameKey, name);
    await prefs.setString(_pictureKey, pictureId);
    await prefs.setDouble(_ratingKey, rating);
  }

  // ambil data restaurant yang tersimpan
  Future<Map<String, dynamic>?> getRestaurant() async {
    // ambil instance SharedPreferences
    final prefs = await SharedPreferences.getInstance();

    // ambil semua data berdasarkan key
    final id = prefs.getString(_idKey);
    final name = prefs.getString(_nameKey);
    final picture = prefs.getString(_pictureKey);
    final rating = prefs.getDouble(_ratingKey);

    // cek kalau ada data yang belum tersimpan
    if (id == null || name == null || picture == null || rating == null) {
      return null;
    }

    // return data dalam bentuk Map
    return {"id": id, "name": name, "pictureId": picture, "rating": rating};
  }
}
