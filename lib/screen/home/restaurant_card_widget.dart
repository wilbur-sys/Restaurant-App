import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';

// Widget card untuk menampilkan info singkat restaurant di list
class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;

  final Function() onTap; // function saat card ditekan
  final String heroTag; // hero tag untuk animasi transisi

  const RestaurantCard({
    super.key,
    required this.restaurant,
    required this.onTap,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // jalankan function saat card diklik

      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // container gambar dengan ukuran tetap biar konsisten
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 80,
                minHeight: 80,
                maxWidth: 120,
                minWidth: 120,
              ),

              // hero untuk animasi saat pindah ke detail screen
              child: Hero(
                tag: heroTag,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),

                  // load gambar restaurant dari API
                  child: Image.network(
                    'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            const SizedBox.square(dimension: 8),

            // bagian info restaurant
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // tampilkan nama restaurant
                  Text(
                    restaurant.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  // tampilkan kota restaurant
                  Row(
                    children: [
                      const Icon(Icons.pin_drop), // ikon lokasi
                      const SizedBox.square(dimension: 4),
                      Expanded(
                        child: Text(
                          restaurant.city,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox.square(dimension: 6),

                  // tampilkan rating restaurant
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellowAccent),
                      const SizedBox.square(dimension: 4),
                      Expanded(
                        child: Text(
                          restaurant.rating.toString(),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
