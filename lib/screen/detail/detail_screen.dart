import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/api/restaurant_api_service.dart';
import 'package:restaurant_app/data/model/restaurant_detail_response.dart';
import 'package:restaurant_app/data/model/restaurant_list.dart';
import 'package:restaurant_app/provider/expandable_text_provider.dart';
import 'package:restaurant_app/provider/restaurant_detail_provider.dart';
import 'package:restaurant_app/provider/restaurant_review_provider.dart';
import 'package:restaurant_app/provider/result_state.dart';
import 'package:restaurant_app/screen/detail/widget/detail_header.dart';
import 'package:restaurant_app/screen/detail/widget/expandabletext.dart';
import 'package:restaurant_app/screen/detail/widget/favorite_icon_widget.dart';
import 'package:restaurant_app/screen/detail/widget/menu_horizontal_list.dart';
import 'package:restaurant_app/screen/detail/widget/review_section.dart';
import 'package:restaurant_app/screen/widget/error_state_widget.dart';

// Screen halaman detail restaurant
class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // controller buat input nama dan review
  final TextEditingController nameController = TextEditingController();
  final TextEditingController reviewController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose(); // release memory controller
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ambil argument dari halaman sebelumnya
    final args = ModalRoute.of(context)?.settings.arguments;

    // validasi kalau argument kosong atau salah tipe
    if (args == null || args is! Map<String, dynamic>) {
      return const Scaffold(
        body: Center(child: Text('Data restoran tidak tersedia')),
      );
    }

    final Restaurant restaurant = args['restaurant']; // data restaurant
    final String heroTag = args['heroTag']; // tag hero animation

    return MultiProvider(
      providers: [
        // provider untuk ambil detail restaurant dari API
        ChangeNotifierProvider(
          create: (_) => RestaurantDetailProvider(
            apiService: RestaurantApiService(),
            restaurantId: restaurant.id,
          ),
        ),

        // provider untuk handle review restaurant
        ChangeNotifierProvider(
          create: (_) =>
              RestaurantReviewProvider(apiService: RestaurantApiService()),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(restaurant.name), // tampilkan nama restaurant
          actions: [
            FavoriteIconWidget(restaurant: restaurant),
          ], // tombol favorite
        ),

        // listen perubahan state detail provider
        body: Consumer<RestaurantDetailProvider>(
          builder: (context, provider, _) {
            final state = provider.state;

            // refresh indicator buat reload data
            return RefreshIndicator(
              onRefresh: () =>
                  context.read<RestaurantDetailProvider>().refresh(),

              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),

                // build content sesuai state
                child: _buildContent(state, restaurant, heroTag, provider),
              ),
            );
          },
        ),
      ),
    );
  }

  // fungsi untuk build UI berdasarkan state
  Widget _buildContent(
    ResultState state,
    Restaurant restaurant,
    String heroTag,
    RestaurantDetailProvider provider,
  ) {
    // tampilkan loading indicator saat fetch data
    if (state is Loading) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailHeader(restaurant: restaurant, heroTag: heroTag),
          const SizedBox(height: 24),
          const Center(child: CircularProgressIndicator()),
        ],
      );
    }

    // tampilkan data kalau berhasil ambil detail
    if (state is HasData<RestaurantDetailResponse>) {
      final detail = state.data.restaurant;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // header gambar dan info utama
          DetailHeader(restaurant: restaurant, heroTag: heroTag),

          const SizedBox(height: 8),

          // tampilkan alamat restaurant
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined, size: 18),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${detail.address}, ${detail.city}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // deskripsi restaurant dengan expandable text with provider
          ChangeNotifierProvider(
            create: (_) => ExpandableTextProvider(),
            child: ExpandableText(text: detail.description),
          ),

          const SizedBox(height: 24),

          // list menu makanan
          MenuHorizontalList(
            title: 'Menu Makanan',
            items: detail.menus.foods.map((e) => e.name).toList(),
          ),

          const SizedBox(height: 16),

          // list menu minuman
          MenuHorizontalList(
            title: 'Menu Minuman',
            items: detail.menus.drinks.map((e) => e.name).toList(),
          ),

          const SizedBox(height: 24),

          // section review dan tambah review
          ReviewSection(
            restaurantId: restaurant.id,
            nameController: nameController,
            reviewController: reviewController,
          ),
        ],
      );
    }

    // tampilkan error UI kalau gagal fetch data
    if (state is Error) {
      return Column(
        children: [
          DetailHeader(restaurant: restaurant, heroTag: heroTag),
          const SizedBox(height: 24),

          // widget error dengan tombol retry
          ErrorStateWidget(message: state.message, onRetry: provider.refresh),
        ],
      );
    }

    return const SizedBox();
  }
}
