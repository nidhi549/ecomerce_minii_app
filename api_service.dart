import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';

  /// Fetch products with pagination support using limit & skip
  static Future<Map<String, dynamic>> fetchProducts({int limit = 20, int skip = 0}) async {
    final url = Uri.parse('$baseUrl/products?limit=$limit&skip=$skip');
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final decoded = json.decode(res.body) as Map<String, dynamic>;
      final products = (decoded['products'] as List<dynamic>?) ?? [];
      final total = decoded['total'] ?? 0;
      return {
        'products': Product.listFromJson(products),
        'total': total,
      };
    } else {
      throw Exception('Failed to fetch products: ${res.statusCode}');
    }
  }

  static Future<Product> fetchProductById(int id) async {
    final url = Uri.parse('$baseUrl/products/$id');
    final res = await http.get(url);
    if (res.statusCode == 200) {
      final decoded = json.decode(res.body) as Map<String, dynamic>;
      return Product.fromJson(decoded);
    } else {
      throw Exception('Failed to fetch product: ${res.statusCode}');
    }
  }
}
