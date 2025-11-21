// lib/controllers/cart_controller.dart
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  Map<String, dynamic> toJson() => {
    'product': product.toJson(),
    'quantity': quantity,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
    );
  }
}

class CartController extends GetxController {
  final items = <CartItem>[].obs;
  final prefsKey = 'cart_items';

  @override
  void onInit() {
    super.onInit();
    loadFromPrefs();
  }

  void addToCart(Product p, {int qty = 1}) {
    final existing = items.indexWhere((it) => it.product.id == p.id);
    if (existing >= 0) {
      items[existing].quantity += qty;
      items.refresh();
    } else {
      items.add(CartItem(product: p, quantity: qty));
    }
    saveToPrefs();
  }

  void removeFromCart(int productId) {
    items.removeWhere((it) => it.product.id == productId);
    saveToPrefs();
  }

  void updateQuantity(int productId, int newQty) {
    final idx = items.indexWhere((it) => it.product.id == productId);
    if (idx >= 0) {
      if (newQty <= 0) {
        items.removeAt(idx);
      } else {
        items[idx].quantity = newQty;
        items.refresh();
      }
      saveToPrefs();
    }
  }

  void clearCart() {
    items.clear();
    saveToPrefs();
  }

  double get totalAmount {
    double total = 0;
    for (final it in items) {
      total += (it.product.price.toDouble()) * it.quantity;
    }
    return total;
  }

  // Persistence
  Future<void> saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(prefsKey, encoded);
  }

  Future<void> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(prefsKey);
    if (stored != null && stored.isNotEmpty) {
      try {
        final decoded = jsonDecode(stored) as List<dynamic>;
        final loaded = decoded.map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList();
        items.assignAll(loaded);
      } catch (e) {
        // ignore parsing errors
      }
    }
  }
}
