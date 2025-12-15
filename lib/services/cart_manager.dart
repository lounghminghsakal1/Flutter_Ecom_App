import '../models/cart_item_model.dart';

class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(CartItem item) {
    final existingIndex = _items.indexWhere((i) => i.productId == item.productId);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.productId == productId);
  }

  void updateQuantity(int productId, int newQuantity) {
    final index = _items.indexWhere((i) => i.productId == productId);
    if (index >= 0 && newQuantity > 0) {
      _items[index].quantity = newQuantity;
    }
  }

  void clearCart() {
    _items.clear();
  }

  double get grandTotal {
    return _items.fold(0, (sum, item) => sum + item.total);
  }

  int get itemCount => _items.length;
}