import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/library_service.dart';
import '../widgets/produk_tile.dart';
import 'detail_page.dart';

/// Tab Library: game yang dimiliki user (data dari Hive).
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Setiap isi box Hive berubah (tambah / hapus), builder dijalankan ulang.
    return ValueListenableBuilder<Box>(
      valueListenable: LibraryService.listenable,
      builder: (context, box, _) {
        final produks = LibraryService.all();

        if (produks.isEmpty) {
          return const Center(child: Text('Library masih kosong'));
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: produks.length,
          itemBuilder: (context, index) {
            final produk = produks[index];
            return ProdukTile(
              produk: produk,
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                tooltip: 'Hapus dari library',
                onPressed: () => LibraryService.remove(produk.id),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailPage(produkId: produk.id),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}