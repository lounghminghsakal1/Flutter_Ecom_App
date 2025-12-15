import 'package:flutter/material.dart';
import '../models/wishlist_item_model.dart';
import '../models/cart_item_model.dart';
import '../services/wishlist_manager.dart';
import '../services/cart_manager.dart';
import '../widgets/wishlist_item_card.dart';
import 'cart_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistManager wishlistManager = WishlistManager();

  void _addToCart(WishlistItem item) {
    // Add to cart without removing from wishlist
    final cartItem = CartItem(
      productId: item.productId,
      title: item.title,
      thumbnail: item.thumbnail,
      price: item.price,
      quantity: 1,
    );

    CartManager().addItem(cartItem);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.title} added to cart'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        
        
      ),
    );
  }

  void _removeFromWishlist(int productId) {
    setState(() {
      wishlistManager.removeItem(productId);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Item removed from wishlist'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],      
      body: wishlistManager.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your wishlist is empty',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add items you love',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  color: Colors.white,
                  child: Text(
                    'WishList Items',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),

                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: wishlistManager.items.length,
                    itemBuilder: (context, index) {
                      final item = wishlistManager.items[index];
                      return WishlistItemCard(
                        item: item,
                        onAddToCart: () => _addToCart(item),
                        onRemove: () => _removeFromWishlist(item.productId),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}