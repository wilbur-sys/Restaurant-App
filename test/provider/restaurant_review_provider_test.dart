import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/data/model/customer_review.dart';
import 'package:restaurant_app/provider/restaurant_review_provider.dart';
import 'package:restaurant_app/data/api/restaurant_api_service.dart';

void main() {
  // grup pengujian untuk fitur review restoran
  group('RestaurantReviewProvider Test', () {
    test('Provider initializes correctly', () {
      // inisialisasi provider dengan fake api service
      final provider = RestaurantReviewProvider(apiService: FakeApiService());

      // memastikan provider terinisialisasi dengan benar
      expect(provider, isNotNull);
    });
  });
}

// fake class untuk simulasi layanan api service
class FakeApiService extends RestaurantApiService {
  @override
  Future<List<CustomerReview>> addReview({
    required String id,
    required String name,
    required String review,
  }) async {
    // Mengembalikan list kosong sebagai nilai dummy agar tipe data cocok
    return Future.value([]);
  }
}
