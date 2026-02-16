import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/provider/restaurant_list_provider.dart';
import 'package:restaurant_app/provider/result_state.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';
import 'package:restaurant_app/screen/widget/error_state_widget.dart';

// Screen utama yang nampilin list semua restaurant dari API
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant App')), // judul halaman
      // listen perubahan state dari RestaurantListProvider
      body: Consumer<RestaurantListProvider>(
        builder: (context, provider, _) {
          final state = provider.state;

          // tampilkan loading saat data sedang diambil
          if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          }

          // tampilkan list restaurant kalau data berhasil didapat
          if (state is HasData<List<Restaurant>>) {
            final restaurantList = state.data;

            return RefreshIndicator(
              // refresh data saat user swipe ke bawah
              onRefresh: () async {
                await context
                    .read<RestaurantListProvider>()
                    .fetchRestaurantList();
              },

              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: restaurantList.length,

                itemBuilder: (context, index) {
                  final restaurant = restaurantList[index];

                  return RestaurantCard(
                    restaurant: restaurant,

                    // hero tag buat animasi transisi ke detail
                    heroTag: 'home-${restaurant.id}',

                    onTap: () async {
                      // preload gambar biar pas buka detail lebih smooth
                      final image = NetworkImage(
                        'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                      );

                      await precacheImage(image, context);

                      // pastikan context masih valid
                      if (!context.mounted) return;

                      // navigasi ke halaman detail restaurant
                      Navigator.pushNamed(
                        context,
                        NavigationRoute.detailRoute.name,
                        arguments: {
                          'restaurant': restaurant,
                          'heroTag': 'home-${restaurant.id}',
                        },
                      );
                    },
                  );
                },
              ),
            );
          }

          // tampilkan error widget kalau gagal ambil data
          if (state is Error) {
            return ErrorStateWidget(
              message: state.message,

              // retry fetch data saat tombol ditekan
              onRetry: () {
                context.read<RestaurantListProvider>().refresh();
              },
            );
          }

          return const SizedBox(); // fallback kosong
        },
      ),
    );
  }
}
