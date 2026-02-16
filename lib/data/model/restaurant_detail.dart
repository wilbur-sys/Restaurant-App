// model untuk menyimpan data detail restaurant
class RestaurantDetail {
  // id unik restaurant
  final String id;

  // nama restaurant
  final String name;

  // deskripsi restaurant
  final String description;

  // kota lokasi restaurant
  final String city;

  // alamat lengkap restaurant
  final String address;

  // id gambar restaurant
  final String pictureId;

  // rating restaurant
  final double rating;

  // data menu makanan dan minuman
  final Menus menus;

  // constructor untuk inisialisasi data restaurant detail
  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.city,
    required this.address,
    required this.pictureId,
    required this.rating,
    required this.menus,
  });

  // factory untuk convert JSON ke object RestaurantDetail
  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    // ambil semua data restaurant dari JSON
    return RestaurantDetail(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      city: json['city'],
      address: json['address'],
      pictureId: json['pictureId'],
      rating: json['rating'].toDouble(),
      menus: Menus.fromJson(json['menus']),
    );
  }
}

// model untuk menyimpan daftar menu
class Menus {
  // list makanan yang tersedia
  final List<MenuItem> foods;

  // list minuman yang tersedia
  final List<MenuItem> drinks;

  // constructor untuk inisialisasi menu
  Menus({required this.foods, required this.drinks});

  // factory untuk convert JSON ke object Menus
  factory Menus.fromJson(Map<String, dynamic> json) {
    // convert JSON foods dan drinks ke List<MenuItem>
    return Menus(
      foods: List<MenuItem>.from(
        json['foods'].map((x) => MenuItem.fromJson(x)),
      ),
      drinks: List<MenuItem>.from(
        json['drinks'].map((x) => MenuItem.fromJson(x)),
      ),
    );
  }
}

// model untuk menyimpan item menu (food/drink)
class MenuItem {
  // nama item menu
  final String name;

  // constructor untuk inisialisasi nama menu
  MenuItem({required this.name});

  // factory untuk convert JSON ke object MenuItem
  factory MenuItem.fromJson(Map<String, dynamic> json) {
    // ambil nama menu dari JSON
    return MenuItem(name: json['name']);
  }
}
