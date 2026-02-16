import 'package:flutter/material.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';

// Widget untuk nampilin header detail restoran (gambar + nama + rating)
class DetailHeader extends StatelessWidget {
  final Restaurant restaurant; // data restoran yang ditampilkan
  final String heroTag; // tag untuk animasi Hero antar halaman

  const DetailHeader({
    super.key,
    required this.restaurant,
    required this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Hero dipakai supaya gambar bisa animasi smooth dari list ke detail
        Hero(
          tag: heroTag,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              12,
            ), // bikin sudut gambar rounded
            child: Image.network(
              // ambil gambar dari API berdasarkan pictureId
              'https://restaurant-api.dicoding.dev/images/large/${restaurant.pictureId}',
              width: double.infinity,
              fit: BoxFit.cover, // biar gambar menyesuaikan container
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Tampilkan nama restoran dan rating
        Text(
          '${restaurant.name} • ⭐ ${restaurant.rating}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
