import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/product.dart';
import '../utils/constants.dart';

/// Semua proses fetch dan parse API ada di sini.
class ApiService {
  // Beberapa server menolak User-Agent bawaan Dart, jadi kita kirim header umum.
  static const Map<String, String> _headers = {
    'Accept': 'application/json',
    'User-Agent':
        'Mozilla/5.0 (Linux; Android 13) AppleWebKit/537.36 Chrome/120 Mobile Safari/537.36',
  };

  /// Daftar semua produk: GET /products
  static Future<List<Product>> fetchProducts() async {
    final response = await http
        .get(Uri.parse(kBaseUrl), headers: _headers)
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat produk (kode ${response.statusCode})');
    }

    final data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return data
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Detail satu produk: GET /products/{id}
  static Future<Product> fetchProduct(int id) async {
    final response = await http
        .get(Uri.parse('$kBaseUrl/$id'), headers: _headers)
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat detail produk (kode ${response.statusCode})');
    }

    final data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return Product.fromJson(data);
  }
}
