import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:restaurant_app/data/api/restaurant_api_service.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/data/model/restaurant_list_response.dart';
import 'package:restaurant_app/provider/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/result_state.dart';

// mock api service untuk simulasi request network
class MockRestaurantApiService extends Mock implements RestaurantApiService {}

void main() {
  late MockRestaurantApiService mockApiService;
  late RestaurantListProvider provider;

  // inisialisasi mock service sebelum unit test dijalankan
  setUp(() {
    mockApiService = MockRestaurantApiService();
  });

  test('State awal provider harus Loading', () {
    // menyiapkan data dummy untuk simulasi sukses api
    when(() => mockApiService.getRestaurantList()).thenAnswer(
      (_) async => RestaurantListResponse(
        error: false,
        message: 'success',
        restaurants: [],
      ),
    );

    provider = RestaurantListProvider(apiService: mockApiService);

    // memastikan state awal provider adalah loading
    expect(provider.state, isA<Loading>());
  });

  test(
    'Harus mengembalikan HasData<List<Restaurant>> ketika API berhasil',
    () async {
      // menyiapkan list data restoran dummy
      final restaurants = [
        Restaurant(
          id: 'rqdv5juczeskfw1e867',
          name: 'Melting Pot',
          description: 'Test desc',
          pictureId: '14',
          city: 'Medan',
          rating: 4.2,
        ),
      ];

      // simulasi response api saat mengembalikan data restoran
      when(() => mockApiService.getRestaurantList()).thenAnswer(
        (_) async => RestaurantListResponse(
          error: false,
          message: 'success',
          restaurants: restaurants,
        ),
      );

      provider = RestaurantListProvider(apiService: mockApiService);

      // menjalankan fungsi fetch data restoran
      await provider.fetchRestaurantList();

      // memastikan state berubah menjadi HasData dan data sesuai
      expect(provider.state, isA<HasData<List<Restaurant>>>());

      final result = provider.state as HasData<List<Restaurant>>;
      expect(result.data.length, 1);
      expect(result.data.first.name, 'Melting Pot');
    },
  );

  test('Harus mengembalikan Error ketika API gagal', () async {
    // simulasi kondisi saat api melempar exception
    when(
      () => mockApiService.getRestaurantList(),
    ).thenThrow(Exception('Failed to fetch'));

    provider = RestaurantListProvider(apiService: mockApiService);

    // menjalankan fungsi fetch data saat kondisi error
    await provider.fetchRestaurantList();

    // memastikan state berubah menjadi Error saat terjadi kegagalan
    expect(provider.state, isA<Error>());
  });
}
