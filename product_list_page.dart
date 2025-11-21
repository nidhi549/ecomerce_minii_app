// lib/pages/product_list_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/card_controller.dart';
import '../controllers/product_controller.dart';

class ProductListPage extends StatelessWidget {
  ProductListPage({Key? key}) : super(key: key);

  final productController = Get.find<ProductController>();
  final cartController = Get.find<CartController>();
  final ScrollController _scrollController = ScrollController();

  void _setupScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        productController.fetchMoreProducts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _setupScrollListener();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(        backgroundColor: Colors.white,

        title: Text('Products'),
        actions: [
          Obx(() {
            final count = cartController.items.fold<int>(0, (p, c) => p + c.quantity);
            return IconButton(
              icon: Stack(
                children: [
                  Icon(Icons.shopping_cart),
                  if (count > 0)
                    Positioned(
                      right: 0,
                      child: CircleAvatar(
                        radius: 8,
                        backgroundColor: Colors.red,
                        child: Text(
                          '$count',
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ),
                    )
                ],
              ),
              onPressed: () => Get.toNamed('/cart'),
            );
          })
        ],
      ),
      body: Obx(() {
        if (productController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (productController.errorMessage.value != null) {
          return Center(child: Text('Error: ${productController.errorMessage.value}'));
        }

        final products = productController.products;

        return RefreshIndicator(
          onRefresh: productController.fetchInitialProducts,
          child: GridView.builder(
            controller: _scrollController,
            padding: EdgeInsets.all(8),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.68,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: products.length + (productController.isLoadingMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= products.length) {
                // loading indicator at bottom
                return Center(child: CircularProgressIndicator());
              }
              final p = products[index];
              return GestureDetector(
                onTap: () => Get.toNamed('/detail', arguments: p.id),
                child: SizedBox(
                  height: 200,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AspectRatio(
                            aspectRatio: 1.2,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                                image: DecorationImage(
                                  image: NetworkImage(p.thumbnail),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(p.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('\$${p.price}', style: TextStyle(fontSize: 16)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Icon(Icons.star, size: 14),
                                    SizedBox(width: 4),
                                    Text(p.rating.toString()),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                                child: ElevatedButton(
                                  onPressed: () {
                                    cartController.addToCart(p);
                                    Get.snackbar('Added', '${p.title} added to cart', snackPosition: SnackPosition.BOTTOM);
                                  },
                                  child: Text('Add'),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
