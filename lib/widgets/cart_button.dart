import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../pages/cart_page.dart';
import '../services/cart_service.dart';

/// Ikon keranjang di AppBar (dengan badge jumlah isi keranjang).
/// Kalau diklik, membuka Cart Page.
class CartButton extends StatelessWidget {
  const CartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
      valueListenable: CartService.listenable,
      builder: (context, box, _) {
        final jumlah = CartService.count;

        return IconButton(
          tooltip: 'Keranjang',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            );
          },
          icon: Badge(
            isLabelVisible: jumlah > 0,
            label: Text('$jumlah'),
            child: const Icon(Icons.shopping_cart_outlined),
          ),
        );
      },
    );
  }
}
