/// Data ringkas game (untuk list di Home dan Library).
class Produk {
  final int id;
  final String title;
  final int price;
  final int rating;
  final String thumbnail;

  const Produk({
    required this.id,
    required this.title,
    required this.price,
    required this.rating,
    required this.thumbnail,
  });

  /// Dari JSON API.
  factory Produk.fromJson(Map<String, dynamic> json) {
    return Produk(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      thumbnail: json['thumbnail'] as String? ?? '',
    );
  }

  /// Untuk disimpan ke Hive.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'rating': rating,
      'thumbnail': thumbnail,
    };
  }

  /// Dari data Hive.
  factory Produk.fromMap(Map<String, dynamic> map) {
    return Produk(
      id: map['id'] as int,
      title: map['title'] as String,
      price: map['price'] as int,
      rating: map['rating'] as int,
      thumbnail: map['thumbnail'] as String,
    );
  }
}

/// Data lengkap produk (untuk Detail Page).
class ProdukDetail {
  final int id;
  final String title;
  final int price;
  final String thumbnail;
  final int rating;
  final String description;
  final List<String> screenshots;
  
  
  const ProdukDetail({
    required this.id,
    required this.title,
    this.price = 0,
    required this.thumbnail,
    required this.rating,
    required this.description,
    required this.screenshots,
  });

  factory ProdukDetail.fromJson(Map<String, dynamic> json) {
    // screenshots bisa berupa list URL (String) atau list objek {id, image}.
    final shots = (json['screenshots'] as List<dynamic>? ?? []).map((item) {
      if (item is String) return item;
      if (item is Map) return (item['image'] ?? '').toString();
      return '';
    }).where((url) => url.isNotEmpty).toList();

    return ProdukDetail(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toInt() ?? 0,
      thumbnail: json['thumbnail'] as String? ?? '',
      rating: (json['rating'] as num).toInt(),
      description: json['description'] as String? ?? '',
      screenshots: shots,
    );
  }

  /// Ubah ke  ringkas, dipakai saat menambah ke library.
  Produk toProduk() {
    return Produk(
      id: id,
      title: title,
      price: price,
      rating: rating,
      thumbnail: thumbnail,
    );
  }
}