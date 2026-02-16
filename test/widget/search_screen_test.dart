import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/data/api/restaurant_api_service.dart';
import 'package:restaurant_app/screen/search/search_screen.dart';

// fake class untuk simulasi api service pada pengujian fitur pencarian
class FakeApiService extends RestaurantApiService {}

void main() {
  testWidgets('SearchScreen has TextField', (WidgetTester tester) async {
    // merender search screen dengan provider yang dibutuhkan
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          // menyediakan search provider untuk kebutuhan ui pencarian
          ChangeNotifierProvider(
            create: (_) =>
                RestaurantSearchProvider(apiService: FakeApiService()),
          ),
        ],
        child: const MaterialApp(home: SearchScreen()),
      ),
    );

    // menunggu proses render widget selesai
    await tester.pump();

    // memastikan widget textfield tersedia untuk input pencarian
    expect(find.byType(TextField), findsOneWidget);
  });
}
