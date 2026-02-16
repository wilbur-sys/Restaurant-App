import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/provider/favorite_provider.dart';

// Widget icon favorite untuk tambah / hapus restoran dari favorite
class FavoriteIconWidget extends StatelessWidget {
  final Restaurant restaurant; // data restoran yang akan di toggle favorite

  const FavoriteIconWidget({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    // context.select dipakai supaya widget cuma rebuild kalau status favorite berubah
    final isFavorite = context.select<FavoriteProvider, bool>(
      (provider) => provider.isFavorite(restaurant.id),
    );

    return IconButton(
      icon: Icon(
        isFavorite
            ? Icons.favorite
            : Icons.favorite_border, // ubah icon sesuai status
        color: Colors.red,
      ),
      onPressed: () async {
        final provider = context.read<FavoriteProvider>();

        // kalau sudah favorite maka hapus, kalau belum maka tambahkan
        if (isFavorite) {
          await provider.removeFavorite(restaurant.id);
        } else {
          await provider.addFavorite(restaurant);
        }
      },
    );
  }
}
