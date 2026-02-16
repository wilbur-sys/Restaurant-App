import 'package:flutter/material.dart';

// Widget untuk nampilin list menu (makanan / minuman) secara horizontal
class MenuHorizontalList extends StatelessWidget {
  final String title; // judul section menu
  final List<String> items; // daftar nama menu

  const MenuHorizontalList({
    super.key,
    required this.title,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // tampilkan judul menu (contoh: Makanan / Minuman)
        Text(title, style: Theme.of(context).textTheme.titleMedium),

        const SizedBox(height: 8),

        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // scroll ke samping
            itemCount: items.length,

            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.only(right: 8),
                child: SizedBox(
                  width: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // icon beda tergantung jenis menu
                      Icon(
                        title.toLowerCase().contains('minum')
                            ? Icons.local_drink
                            : Icons.fastfood,
                        size: 32,
                      ),

                      const SizedBox(height: 8),

                      // tampilkan nama menu
                      Text(
                        items[index],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis, // biar ga overflow
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
