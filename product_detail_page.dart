// lib/pages/product_detail_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/card_controller.dart';
import '../controllers/product_controller.dart';
import '../models/product.dart';

class ProductDetailPage extends StatelessWidget {
  ProductDetailPage({Key? key}) : super(key: key);

  final productController = Get.find<ProductController>();
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    final argId = Get.arguments as int?;
    if (argId == null) {
      return Scaffold(body: Center(child: Text('No product selected')));
    }

    Product? p = productController.findById(argId);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(p?.title ?? 'Product'),
        actions: [
          IconButton(onPressed: () => Get.toNamed('/cart'), icon: Icon(Icons.shopping_cart)),
        ],
      ),
      body: p == null
          ? FutureBuilder(
              future: productController.fetchInitialProducts(), // fallback fetch
              builder: (ctx, snap) {
                return Center(child: CircularProgressIndicator());
              },
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (p.images.isNotEmpty)
                      ? SizedBox(
                          height: 300,
                          child: PageView(
                            children: p.images.map<Widget>((img) {
                              return Image.network(img.toString(), fit: BoxFit.cover);
                            }).toList(),
                          ),
                        )
                      : Image.network(p.thumbnail, height: 300, fit: BoxFit.cover),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(p.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 18),
                        SizedBox(width: 6),
                        Text('${p.rating}'),
                        Spacer(),
                        Text('\$${p.price}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(p.description),
                  ),
                  SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              cartController.addToCart(p);
                              Get.snackbar('Added', '${p.title} added to cart');
                            },
                            child: Text('Add to Cart'),
                          ),
                        ),
                        SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => Get.back(),
                          child: Text('Back'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
    );
  }
}
