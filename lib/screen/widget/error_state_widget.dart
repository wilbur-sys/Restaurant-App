import 'package:flutter/material.dart';

// Widget untuk menampilkan state error dan tombol retry
// Dipakai saat gagal load data dari API atau proses lain
class ErrorStateWidget extends StatelessWidget {
  // pesan error yang akan ditampilkan ke user
  final String message;

  // callback untuk menjalankan ulang proses (retry)
  final VoidCallback onRetry;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        // padding horizontal supaya tampilan tidak terlalu mepet
        padding: const EdgeInsets.symmetric(horizontal: 24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // icon sebagai indikator visual kalau terjadi error
            const Icon(Icons.error_outline, size: 72, color: Colors.redAccent),

            const SizedBox(height: 16),

            // tampilkan pesan error dari parameter
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 16),

            // tombol untuk mencoba ulang proses yang gagal
            ElevatedButton(onPressed: onRetry, child: const Text('Coba Lagi')),
          ],
        ),
      ),
    );
  }
}
