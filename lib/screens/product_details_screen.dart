import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/cart_item_model.dart';
import '../services/cart_manager.dart';
import 'cart_screen.dart';

import '../models/wishlist_item_model.dart';
import '../services/wishlist_manager.dart';
import 'wishlist_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  ProductDetailsScreen({required this.productId});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  Product? product;
  List<Product> similarProducts = [];
  bool isLoading = true;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      // Fetch product details
      final response = await http.get(
        Uri.parse('https://dummyjson.com/products/${widget.productId}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final prod = Product.fromJson(data);

        // Fetch similar products from same category
        if (prod.category != null && prod.category!.isNotEmpty) {
          final similarResponse = await http.get(
            Uri.parse(
              'https://dummyjson.com/products/category/${prod.category}',
            ),
          );

          if (similarResponse.statusCode == 200) {
            final similarData = json.decode(similarResponse.body);
            setState(() {
              product = prod;
              similarProducts = (similarData['products'] as List)
                  .map((p) => Product.fromJson(p))
                  .where((p) => p.id != widget.productId)
                  .take(4)
                  .toList();
              isLoading = false;
            });
          }
        } else {
          setState(() {
            product = prod;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (product == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Product not found')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "${product?.title} details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                height: 400,
                color: Colors.grey[200],
                child: Image.network(product!.thumbnail, fit: BoxFit.contain),
              ),

              // Product Details
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand
                    if (product!.brand.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Text(
                          product!.brand,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    // Title
                    Text(
                      product!.title,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),

                    // Rating
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          return Icon(
                            index < product!.rating.floor()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.black,
                            size: 20,
                          );
                        }),
                        SizedBox(width: 8),
                        Text(
                          '${product!.rating.toStringAsFixed(1)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    // Description
                    if (product!.description != null &&
                        product!.description!.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(bottom: 24),
                        child: Text(
                          product!.description!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            height: 1.5,
                          ),
                        ),
                      ),

                    // Price
                    Row(
                      children: [
                        Text(
                          '\$${product!.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        if (product!.discountPercentage != null &&
                            product!.discountPercentage! > 0)
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Text(
                              '\$${product!.originalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Quantity Selector
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.remove, color: Colors.white),
                            onPressed: decrementQuantity,
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 48,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            '$quantity',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add, color: Colors.white),
                            onPressed: incrementQuantity,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Buttons
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                            onPressed: () {
                              final cartItem = CartItem(
                                productId: product!.id,
                                title: product!.title,
                                thumbnail: product!.thumbnail,
                                price: product!.price.toDouble(),
                                quantity: quantity,
                              );

                              CartManager().addItem(cartItem);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: Text(
                                    'Added $quantity item(s) to cart',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor: Colors.green,
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(12),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Add to Cart',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              final wishlistItem = WishlistItem(
                                productId: product!.id,
                                title: product!.title,
                                thumbnail: product!.thumbnail,
                                price: product!.price.toDouble(),
                              );

                              WishlistManager().addItem(wishlistItem);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    'Added to Wishlist',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 3),
                                  margin: EdgeInsets.all(12),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[600],
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Text(
                              'Add to Wishlist',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Similar Products Section
                    if (similarProducts.isNotEmpty) ...[
                      SizedBox(height: 40),
                      Text(
                        'Similar Products',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),

                      SizedBox(
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: similarProducts.length,
                          itemBuilder: (context, index) {
                            final similar = similarProducts[index];
                            return GestureDetector(
                              onTap: () {
                                // Reset quantity when navigating to new product
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailsScreen(
                                      productId: similar.id,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 160,
                                margin: EdgeInsets.only(right: 16),
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(12),
                                          ),
                                          child: Image.network(
                                            similar.thumbnail,
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (similar.brand.isNotEmpty)
                                              Text(
                                                similar.brand,
                                                style: TextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 10,
                                                ),
                                              ),
                                            Text(
                                              similar.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '\$${similar.price.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
