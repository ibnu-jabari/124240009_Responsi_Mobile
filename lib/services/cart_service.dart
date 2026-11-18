import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/product.dart';
import '../utils/constants.dart';

/// Mengelola keranjang di database lokal Hive.
/// Kunci tiap data = id produk (dalam bentuk String).
class CartService {
  static Box get _box => Hive.box(kCartBox);

  /// Dipakai ValueListenableBuilder supaya tampilan otomatis ter-update
  /// setiap isi box berubah (tambah / hapus).
  static ValueListenable<Box> get listenable => _box.listenable();

  /// Apakah produk dengan [id] sudah ada di keranjang?
  static bool contains(int id) => _box.containsKey(id.toString());

  /// Jumlah produk di keranjang.
  static int get count => _box.length;

  /// Semua produk di keranjang, urut dari yang pertama dimasukkan.
  static List<Product> all() {
    final data = _box.values
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    data.sort((a, b) {
      final waktuA = (a['addedAt'] as num?) ?? 0;
      final waktuB = (b['addedAt'] as num?) ?? 0;
      return waktuA.compareTo(waktuB);
    });

    return data.map(Product.fromMap).toList();
  }

  static Future<void> add(Product product) async {
    final data = product.toMap();
    data['addedAt'] = DateTime.now().millisecondsSinceEpoch;
    await _box.put(product.id.toString(), data);
  }

  static Future<void> remove(int id) async {
    await _box.delete(id.toString());
  }
}
