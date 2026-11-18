/// Model produk, mengikuti bentuk JSON dari FakeStore API:
/// {id, title, price, description, category, image, rating: {rate, count}}
class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final double rating; // rating.rate
  final int ratingCount; // rating.count (jumlah review)

  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    required this.ratingCount,
  });

  /// Dari JSON API.
  factory Product.fromJson(Map<String, dynamic> json) {
    // "rating" di API berupa objek, bukan angka.
    final ratingJson = json['rating'];
    double rate = 0;
    int count = 0;
    if (ratingJson is Map) {
      rate = (ratingJson['rate'] as num?)?.toDouble() ?? 0;
      count = (ratingJson['count'] as num?)?.toInt() ?? 0;
    }

    return Product(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      image: json['image'] as String? ?? '',
      rating: rate,
      ratingCount: count,
    );
  }

  /// Untuk disimpan ke Hive.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating,
      'ratingCount': ratingCount,
    };
  }

  /// Dari data Hive.
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] as int,
      title: map['title'] as String,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String? ?? '',
      category: map['category'] as String? ?? '',
      image: map['image'] as String,
      rating: (map['rating'] as num).toDouble(),
      ratingCount: (map['ratingCount'] as num?)?.toInt() ?? 0,
    );
  }
}
