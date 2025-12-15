import '../models/wishlist_item_model.dart';

class WishlistManager {
  static final WishlistManager _instance = WishlistManager._internal();
  factory WishlistManager() => _instance;
  WishlistManager._internal();

  final List<WishlistItem> _items = [];

  List<WishlistItem> get items => _items;

  bool isInWishlist(int productId) {
    return _items.any((item) => item.productId == productId);
  }

  void addItem(WishlistItem item) {
    if (!isInWishlist(item.productId)) {
      _items.add(item);
    }
  }

  void removeItem(int productId) {
    _items.removeWhere((item) => item.productId == productId);
  }

  void toggleItem(WishlistItem item) {
    if (isInWishlist(item.productId)) {
      removeItem(item.productId);
    } else {
      addItem(item);
    }
  }

  int get itemCount => _items.length;
}