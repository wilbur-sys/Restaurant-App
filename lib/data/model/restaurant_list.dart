// model utama untuk menyimpan data restaurant
class Restaurant {
  // id unik restaurant
  final String id;

  // nama restaurant
  final String name;

  // deskripsi restaurant
  final String description;

  // id gambar restaurant
  final String pictureId;

  // kota lokasi restaurant
  final String city;

  // rating restaurant
  final double rating;

  // constructor untuk inisialisasi data restaurant
  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  // factory untuk convert JSON ke object Restaurant
  factory Restaurant.fromJson(Map<String, dynamic> json) {
    // ambil semua field restaurant dari JSON
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}
