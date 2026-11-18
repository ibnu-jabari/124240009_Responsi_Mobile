import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/product.dart';
import '../services/api_service.dart';
import '../services/cart_service.dart';
import '../utils/app_colors.dart';
import '../utils/format.dart';
import '../widgets/cart_button.dart';
import '../widgets/net_image.dart';

/// Detail produk. Data diambil dari API berdasarkan [productId].
class DetailPage extends StatefulWidget {
  final int productId;

  const DetailPage({super.key, required this.productId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Product> _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchProduct(widget.productId);
  }

  void _muatUlang() {
    setState(() {
      _future = ApiService.fetchProduct(widget.productId);
    });
  }

  /// Tombol bawah: UI berbeda tergantung produk sudah ada di keranjang atau belum.
  Widget _tombolKeranjang(Product product) {
    return ValueListenableBuilder<Box>(
      valueListenable: CartService.listenable,
      builder: (context, box, _) {
        final sudahAda = CartService.contains(product.id);

        return FilledButton.icon(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.disabled,
            disabledForegroundColor: Colors.white,
            minimumSize: const Size.fromHeight(52),
            shape: const StadiumBorder(),
          ),
          // null = tombol nonaktif (abu-abu)
          onPressed: sudahAda
              ? null
              : () {
                  CartService.add(product);
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      const SnackBar(
                        content: Text('Produk dimasukkan ke keranjang'),
                        backgroundColor: AppColors.primary,
                      ),
                    );
                },
          icon: Icon(sudahAda ? Icons.check : Icons.add_shopping_cart),
          label: Text(
            sudahAda ? 'Sudah di Keranjang' : 'Masukkan ke Keranjang',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        );
      },
    );
  }

  Widget _isi(Product product) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              // Hero image: paling atas dan besar, memudar ke warna latar di bawah
              SizedBox(
                height: 380,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      color: Colors.white,
                      child: NetImage(url: product.image, fit: BoxFit.cover),
                    ),
                    const Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 90,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              AppColors.backgroundTransparent,
                              AppColors.background,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama produk
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Harga
                    Text(
                      formatHarga(product.price),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Rating dan jumlah review
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 20,
                          color: AppColors.star,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '(${product.ratingCount} review)',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    // Deskripsi
                    const Text(
                      'Deskripsi Produk',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Tombol masuk keranjang (tetap di bawah)
        Container(
          color: AppColors.background,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: _tombolKeranjang(product),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tombol kembali (panah) otomatis ada di AppBar, plus tombol ke Cart Page.
      appBar: AppBar(
        title: const Text('Detail'),
        actions: const [CartButton(), SizedBox(width: 4)],
      ),
      body: FutureBuilder<Product>(
        future: _future,
        builder: (context, snapshot) {
          // Loading indicator
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Gagal memuat detail produk. Periksa koneksi internet.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: _muatUlang,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
            );
          }

          return _isi(snapshot.data!);
        },
      ),
    );
  }
}
