import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/restaurant_list_provider.dart';
import 'package:restaurant_app/data/api/restaurant_api_service.dart';
import 'package:restaurant_app/screen/home/home_screen.dart';

// fake class untuk simulasi api service pada pengujian widget
class FakeApiService extends RestaurantApiService {}

void main() {
  testWidgets('HomeScreen displays correctly', (WidgetTester tester) async {
    // merender widget home screen dengan provider dummy
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          // menyediakan list provider untuk kebutuhan ui home screen
          ChangeNotifierProvider(
            create: (_) => RestaurantListProvider(apiService: FakeApiService()),
          ),
        ],
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    // menunggu proses render widget selesai
    await tester.pump();

    // memastikan widget scaffold ditemukan pada home screen
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
