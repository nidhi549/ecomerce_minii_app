// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/card_controller.dart';
import 'controllers/product_controller.dart';
import 'pages/product_list_page.dart';
import 'pages/product_detail_page.dart';
import 'pages/cart_page.dart';

void main() {
  runApp(EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  EcommerceApp({Key? key}) : super(key: key);

  // Bind controllers globally
  final bindings = [
    BindingsBuilder(() {
      Get.put(ProductController());
      Get.put(CartController());
    })
  ];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce Mini App',
      initialBinding: BindingsBuilder(() {
        Get.put(ProductController());
        Get.put(CartController());
      }),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => ProductListPage()),
        GetPage(name: '/detail', page: () => ProductDetailPage()),
        GetPage(name: '/cart', page: () => CartPage()),
      ],
    );
  }
}
