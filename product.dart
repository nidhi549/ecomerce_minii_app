// lib/models/product.dart
import 'dart:convert';

class Product {
  final int id;
  final String title;
  final String description;
  final num price;
  final num rating;
  final String thumbnail;
  final List<dynamic> images;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      rating: json['rating'] ?? 0,
      thumbnail: json['thumbnail'] ?? '',
      images: json['images'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'price': price,
    'rating': rating,
    'thumbnail': thumbnail,
    'images': images,
  };

  static List<Product> listFromJson(List<dynamic> jsonList) =>
      jsonList.map((e) => Product.fromJson(e)).toList();
}
