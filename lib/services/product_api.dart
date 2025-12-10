import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/product_model.dart';

class ProductApi {
  static Future<List<Product>> fetchProducts() async {
    final uri = "https://dummyjson.com/products?limit=1000";
    final res = await http.get(Uri.parse(uri));
    if (res.statusCode != 200) {
      throw Exception("Failed to fetch products");
    }
    final List list = jsonDecode(res.body)['products'];
    return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }
}


