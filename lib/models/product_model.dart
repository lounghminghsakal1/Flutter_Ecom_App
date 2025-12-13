class Product {
  final int id;
  final String title;
  final String brand;
  final String thumbnail;
  final num price;
  final num rating;
  final String? description;
  final num? discountPercentage;
  final List<String>? images;
  final String? category;

  Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.thumbnail,
    required this.price,
    required this.rating,
    this.description,
    this.discountPercentage,
    this.images,
    this.category,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      brand: json['brand'] ?? "",
      thumbnail: json['thumbnail'],
      price: json['price'],
      rating: json['rating'],
      description: json['description'],
      discountPercentage: json['discountPercentage'],
      images: json['images'] != null 
          ? List<String>.from(json['images']) 
          : [json['thumbnail']],
      category: json['category'],
    );
  }

  double get originalPrice {
    if (discountPercentage != null && discountPercentage! > 0) {
      return price / (1 - discountPercentage! / 100);
    }
    return price.toDouble();
  }
}