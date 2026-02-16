import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/data/api/restaurant_api_service.dart';

void main() {
  // grup pengujian untuk fitur pencarian restoran
  group('RestaurantSearchProvider Test', () {
    test('Provider initializes correctly', () {
      // inisialisasi provider dengan fake api service
      final provider = RestaurantSearchProvider(apiService: FakeApiService());

      // memastikan provider terinisialisasi dengan benar
      expect(provider, isNotNull);
    });
  });
}

// fake class untuk simulasi layanan api service pada fitur pencarian
class FakeApiService extends RestaurantApiService {
  @override
  Future<List<Restaurant>> searchRestaurant(String query) async {
    // Hapus 's' di searchRestaurant
    // Mengembalikan list kosong agar tipe datanya sesuai (List<Restaurant>)
    return Future.value([]);
  }
}
