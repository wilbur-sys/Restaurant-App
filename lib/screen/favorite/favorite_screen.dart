import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';

// Screen untuk menampilkan daftar restaurant favorit
class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Restaurant')), // judul halaman
      // listen perubahan data favorite dari provider
      body: Consumer<FavoriteProvider>(
        builder: (context, provider, _) {
          // tampilkan loading saat data masih diambil dari database
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // tampilkan pesan kalau belum ada favorite
          if (provider.favorites.isEmpty) {
            return const Center(child: Text('Belum ada restoran favorit'));
          }

          // tampilkan list restaurant favorite
          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: provider.favorites.length,

            itemBuilder: (context, index) {
              final restaurant = provider.favorites[index];

              return RestaurantCard(
                restaurant: restaurant,

                // hero tag biar animasi smooth saat pindah screen
                heroTag: 'favorite-${restaurant.id}',

                onTap: () async {
                  // preload gambar biar gak flicker saat buka detail
                  final image = NetworkImage(
                    'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                  );

                  await precacheImage(image, context);

                  // pastikan context masih aktif
                  if (!context.mounted) return;

                  // navigasi ke halaman detail
                  Navigator.pushNamed(
                    context,
                    NavigationRoute.detailRoute.name,
                    arguments: {
                      'restaurant': restaurant,
                      'heroTag': 'favorite-${restaurant.id}',
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
