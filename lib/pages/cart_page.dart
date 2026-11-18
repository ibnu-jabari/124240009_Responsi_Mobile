import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../services/cart_service.dart';
import '../utils/app_colors.dart';
import '../utils/format.dart';
import '../widgets/net_image.dart';
import 'detail_page.dart';

/// Keranjang: daftar produk yang disimpan di Hive.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6EBDF),
      // Tombol kembali otomatis ada karena halaman ini dibuka lewat Navigator.push.
      appBar: AppBar(
        title: const Text('Keranjang'),
        backgroundColor: AppColors.background,
      ),
      // Setiap isi box Hive berubah (hapus item), tampilan dibangun ulang.
      body: ValueListenableBuilder<Box>(
        valueListenable: CartService.listenable,
        builder: (context, box, _) {
          final items = CartService.all();

          if (items.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.shopping_cart_outlined,
                      size: 56,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(height: 12),
                    Text(
                      'Keranjang masih kosong',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    // Klik produk -> Detail Page
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailPage(productId: product.id),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          // Gambar
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: NetImage(
                              url: product.image,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Nama
                                Text(
                                  product.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Harga
                                Text(
                                  formatHarga(product.price),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                // Rating
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      size: 15,
                                      color: AppColors.star,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      product.rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Tombol hapus dari keranjang
                          IconButton(
                            icon: const Icon(Icons.delete_rounded),
                            color: AppColors.danger,
                            tooltip: 'Hapus dari keranjang',
                            onPressed: () => CartService.remove(product.id),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
