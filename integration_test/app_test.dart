import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:restaurant_app/main.dart' as app;
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/screen/detail/widget/favorite_icon_widget.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Jeda waktu untuk pengamatan visual proses pengujian
  Future<void> delay([int seconds = 2]) async {
    await Future.delayed(Duration(seconds: seconds));
  }

  testWidgets(
    'Full User Flow: Home, Detail, Review, Search, Favorite, Settings',
    (tester) async {
      // Inisialisasi aplikasi dan tunggu hingga UI stabil
      app.main();
      await tester.pumpAndSettle();
      await delay();

      // Pilih item restoran pertama di halaman utama
      final restaurantCard = find.byType(RestaurantCard).first;
      await tester.tap(restaurantCard);
      await tester.pumpAndSettle();
      await delay();

      // Aktivasi fitur favorit pada halaman detail
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await tester.tap(find.byType(FavoriteIconWidget));
      await tester.pumpAndSettle();
      await delay();

      // Scroll ke bawah untuk akses form review
      final scrollable = find.byType(SingleChildScrollView);
      await tester.drag(scrollable, const Offset(0, -1000));
      await tester.pumpAndSettle();
      await delay();

      // Input nama pengulas dan tutup keyboard virtual
      await tester.enterText(find.byType(TextField).at(0), 'Tester Pro');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await delay(1);

      // Input teks review dan tutup keyboard virtual
      await tester.enterText(
        find.byType(TextField).at(1),
        'Rasanya mantap sekali!',
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      await delay();

      // Pastikan tombol kirim terlihat di layar sebelum interaksi
      await tester.drag(scrollable, const Offset(0, -300));
      await tester.pumpAndSettle();
      await delay();

      // Eksekusi pengiriman review dan tunggu respon API
      final submitBtn = find.widgetWithText(ElevatedButton, 'Kirim Review');
      expect(submitBtn, findsOneWidget);
      await tester.tap(submitBtn);
      await tester.pumpAndSettle(const Duration(seconds: 3));
      await delay();

      // Navigasi ke daftar review untuk verifikasi data baru
      await tester.drag(scrollable, const Offset(0, -600));
      await tester.pumpAndSettle();

      // Validasi munculnya nama pengulas pada daftar review
      final myReview = find.text('Tester Pro');
      expect(myReview, findsWidgets);
      await delay(2);

      // Kembali ke halaman utama
      await tester.pageBack();
      await tester.pumpAndSettle();
      await delay();

      // Masuk ke menu pencarian melalui navigasi bawah
      await tester.tap(find.text('Search'));
      await tester.pumpAndSettle();
      await delay();

      // Uji fitur pencarian dengan keyword spesifik
      await tester.enterText(find.byType(TextField), 'melting');
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await delay();
      expect(find.byType(RestaurantCard), findsWidgets);

      // Masuk ke halaman koleksi favorit
      await tester.tap(find.text('Favorite'));
      await tester.pumpAndSettle();
      await delay();

      // Pilih item favorit untuk masuk ke detail
      final favItem = find.byType(RestaurantCard).first;
      await tester.tap(favItem);
      await tester.pumpAndSettle();
      await delay();

      // Hapus item dari daftar favorit (Unfavorite)
      await tester.tap(find.byType(FavoriteIconWidget));
      await tester.pumpAndSettle();
      await delay();

      // Kembali ke daftar favorit dan pastikan data sudah terhapus
      await tester.pageBack();
      await tester.pumpAndSettle();
      await delay();
      expect(find.text('Belum ada restoran favorit'), findsOneWidget);
      await delay();

      // Masuk ke halaman pengaturan
      await tester.tap(find.text('Pengaturan'));
      await tester.pumpAndSettle();
      await delay();

      // Uji fungsionalitas pergantian tema (Dark Mode)
      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();
      await delay(3);
    },
  );
}
