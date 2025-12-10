import 'package:flutter/material.dart';
import '../models/product_model.dart';


class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.grey, offset: Offset(2, 3), blurRadius: 2),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.vertical(
              top: Radius.circular(20),
            ),
            child: Container(
              height: 200,
              color: Colors.grey[400],
              child: Image.network(product.thumbnail, fit: BoxFit.cover),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                Text(
                  product.brand,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
                ),
                Text(
                  "${product.rating.toString()} ⭐",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow[800],
                  ),
                ),
                Text(
                  "\$ ${product.price.toString()}",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      print("Product Button Clicked");
                    },
                    child: Text("View Details", style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
