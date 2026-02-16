import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/data/model/customer_review.dart';
import 'package:restaurant_app/provider/restaurant_review_provider.dart';
import 'package:restaurant_app/provider/result_state.dart';

// Widget section untuk tambah review dan nampilin review pelanggan
class ReviewSection extends StatefulWidget {
  final TextEditingController nameController; // controller input nama
  final TextEditingController reviewController; // controller input review
  final String restaurantId; // id restaurant buat kirim review

  const ReviewSection({
    super.key,
    required this.nameController,
    required this.reviewController,
    required this.restaurantId,
  });

  @override
  State<ReviewSection> createState() => _ReviewSectionState();
}

class _ReviewSectionState extends State<ReviewSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // judul form review
        Text('Tambah Review', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),

        // input nama user
        TextField(
          controller: widget.nameController,
          decoration: const InputDecoration(
            labelText: 'Nama',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),

        // input isi review
        TextField(
          controller: widget.reviewController,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Review',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),

        // tombol kirim review, listen state dari provider
        Consumer<RestaurantReviewProvider>(
          builder: (context, provider, _) {
            final state = provider.state;

            // kalau berhasil kirim review
            if (provider.hasSubmitted &&
                state is HasData<List<CustomerReview>>) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                widget.nameController.clear(); // reset input
                widget.reviewController.clear();
                FocusScope.of(context).unfocus(); // tutup keyboard

                // tampilkan notifikasi sukses
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Review berhasil dikirim'),
                    behavior: SnackBarBehavior.floating,
                    duration: Duration(seconds: 2),
                  ),
                );

                provider.resetSubmission();
              });
            }

            // kalau gagal kirim review
            if (provider.hasSubmitted && state is Error) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message.isNotEmpty
                          ? state.message
                          : 'Gagal mengirim review. Silakan coba lagi.',
                    ),
                    backgroundColor: Colors.redAccent,
                    behavior: SnackBarBehavior.floating,
                  ),
                );

                provider.resetSubmission();
              });
            }

            return ElevatedButton(
              onPressed: state is Loading
                  ? null // disable tombol saat loading
                  : () {
                      // validasi input ga boleh kosong
                      if (widget.nameController.text.isEmpty ||
                          widget.reviewController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Nama maupun review tidak boleh kosong',
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        return;
                      }

                      provider.markSubmitted(); // tandai sudah submit

                      // kirim review lewat provider
                      provider.submitReview(
                        restaurantId: widget.restaurantId,
                        name: widget.nameController.text,
                        review: widget.reviewController.text,
                      );
                    },

              // tampilkan loading indicator saat proses kirim
              child: state is Loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Kirim Review'),
            );
          },
        ),

        const SizedBox(height: 24),

        // judul list review
        Text(
          'Review Pelanggan',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        // tampilkan daftar review dari provider
        Consumer<RestaurantReviewProvider>(
          builder: (context, provider, _) {
            final state = provider.state;

            if (state is HasData<List<CustomerReview>>) {
              // kalau belum ada review
              if (state.data.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text('Belum ada review'),
                );
              }

              // tampilkan semua review dalam bentuk list card
              return Column(
                children: state.data.map((review) {
                  return Card(
                    child: ListTile(
                      title: Text(review.name), // nama reviewer
                      subtitle: Text(review.review), // isi review
                      trailing: Text(
                        review.date, // tanggal review
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                }).toList(),
              );
            }

            // tampilkan error kalau gagal load review
            if (state is Error) {
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ],
    );
  }
}
