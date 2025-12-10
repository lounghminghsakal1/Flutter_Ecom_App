class Product {
  final int id;
  final String title;
  final String brand;
  final String thumbnail;
  final num price;
  final num rating;

  Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.thumbnail,
    required this.price,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      brand: json['brand'] ?? "", //brand value may be null
      thumbnail: json['thumbnail'],
      price: json['price'],
      rating: json['rating'],
    );
  }
}
