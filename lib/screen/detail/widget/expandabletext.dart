import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/provider/expandable_text_provider.dart';

// Komponen teks deskripsi yang dapat disembunyikan atau ditampilkan sepenuhnya
class ExpandableText extends StatelessWidget {
  final String text;
  final int maxLines;

  const ExpandableText({super.key, required this.text, this.maxLines = 4});

  @override
  Widget build(BuildContext context) {
    // Pemantauan status ekspansi teks melalui provider
    final provider = context.watch<ExpandableTextProvider>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Penampilan konten teks dengan batas baris dinamis
        Text(
          text,
          textAlign: TextAlign.justify,
          maxLines: provider.isExpanded ? null : maxLines,
          overflow: provider.isExpanded
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),

        // Kontrol interaksi untuk mengubah status visibilitas teks
        GestureDetector(
          onTap: () => context.read<ExpandableTextProvider>().toggle(),
          child: Text(
            provider.isExpanded ? 'Read less' : 'Read more',
            style: const TextStyle(
              color: Colors.blue,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
