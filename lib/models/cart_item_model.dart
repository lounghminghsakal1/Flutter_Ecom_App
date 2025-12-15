class CartItem {
  final int productId;
  final String title;
  final String thumbnail;
  final double price;
  int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.quantity,
  });

  double get total => price * quantity;
}