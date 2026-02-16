import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/provider/result_state.dart';
import 'package:restaurant_app/provider/restaurant_search_provider.dart';
import 'package:restaurant_app/screen/home/restaurant_card_widget.dart';
import 'package:restaurant_app/static/navigation_route.dart';

// Screen untuk fitur pencarian restoran
// Menggunakan provider untuk handle state hasil pencarian
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // supaya layout tetap aman saat keyboard muncul
      resizeToAvoidBottomInset: true,

      appBar: AppBar(title: const Text('Cari Restoran')),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Consumer untuk ambil provider dan trigger pencarian
            Consumer<RestaurantSearchProvider>(
              builder: (context, provider, _) {
                return TextField(
                  decoration: const InputDecoration(
                    hintText: 'Cari restoran...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),

                  // setiap text berubah, langsung panggil fungsi search
                  onChanged: provider.searchRestaurant,
                );
              },
            ),

            const SizedBox(height: 16),

            // Consumer untuk handle tampilan berdasarkan state
            Consumer<RestaurantSearchProvider>(
              builder: (context, provider, _) {
                final state = provider.state;

                // tampilkan loading saat proses fetch data
                if (state is Loading) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                // jika data berhasil didapat
                if (state is HasData<List<Restaurant>>) {
                  // tampilkan pesan jika belum ada hasil pencarian
                  if (state.data.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 32),
                      child: Center(
                        child: Text('Masukkan kata kunci pencarian'),
                      ),
                    );
                  }

                  // tampilkan list hasil pencarian restoran
                  return ListView.builder(
                    shrinkWrap: true,

                    // disable scroll karena parent sudah scrollable
                    physics: const NeverScrollableScrollPhysics(),

                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      // ambil data restaurant berdasarkan index
                      final restaurant = state.data[index];

                      return RestaurantCard(
                        restaurant: restaurant,

                        // heroTag unik untuk animasi hero transition
                        heroTag: 'search-${restaurant.id}',

                        onTap: () async {
                          // preload image supaya animasi hero lebih smooth
                          final image = NetworkImage(
                            'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
                          );

                          await precacheImage(image, context);

                          // pastikan context masih valid sebelum navigasi
                          if (!context.mounted) return;

                          // navigasi ke halaman detail dengan kirim argument
                          Navigator.pushNamed(
                            context,
                            NavigationRoute.detailRoute.name,
                            arguments: {
                              'restaurant': restaurant,
                              'heroTag': 'search-${restaurant.id}',
                            },
                          );
                        },
                      );
                    },
                  );
                }

                // tampilkan pesan error jika gagal fetch data
                if (state is Error) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 32),
                    child: Center(child: Text(state.message)),
                  );
                }

                // default empty widget jika belum ada state
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
