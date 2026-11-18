import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/produk.dart';
import '../utils/constants.dart';

/// Semua proses fetch dan parse API ada di sini.
class ApiService {
  /// Daftar semua produk: GET /produk
  static Future<List<Produk>> fetchProduks() async {
    final response = await http
        .get(Uri.parse('$kBaseUrl/produk'))
        .timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat daftar produk (kode ${response.statusCode})');
    }

    // utf8.decode supaya karakter khusus (mis. é) tidak rusak.
    final data = jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
    return data
        .map((item) => Produk.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  /// Detail satu game: GET /game?id={id}
  static Future<ProdukDetail> fetchProdukDetail(int id) async {
    final uri = Uri.parse('$kBaseUrl/produk').replace(
      queryParameters: {'id': id.toString()},
    );
    final response = await http.get(uri).timeout(const Duration(seconds: 20));

    if (response.statusCode != 200) {
      throw Exception('Gagal memuat detail game (kode ${response.statusCode})');
    }

    final data =
        jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
    return ProdukDetail.fromJson(data);
  }
  
}

