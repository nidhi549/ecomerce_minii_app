// lib/pages/cart_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/card_controller.dart';

class CartPage extends StatelessWidget {
  CartPage({Key? key}) : super(key: key);

  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor:   Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Shopping Cart'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () {
              Get.defaultDialog(
                title: 'Clear cart?',
                middleText: 'Are you sure you want to empty the cart?',
                onConfirm: () {
                  cartController.clearCart();
                  Get.back();
                },
                onCancel: () => Get.back(),
              );
            },
          )
        ],
      ),
      body: Obx(() {
        if (cartController.items.isEmpty) {
          return Center(child: Text('Your cart is empty'));
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: cartController.items.length,
                itemBuilder: (ctx, i) {
                  final it = cartController.items[i];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: Image.network(it.product.thumbnail, width: 56, fit: BoxFit.cover),
                      title: Text(it.product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text('\$${it.product.price} x ${it.quantity}'),
                      trailing: SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () => cartController.updateQuantity(it.product.id, it.quantity - 1),
                            ),
                            Text('${it.quantity}'),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () => cartController.updateQuantity(it.product.id, it.quantity + 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2))
              ]),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total', style: TextStyle(fontSize: 12)),
                        Obx(() => Text('\$${cartController.totalAmount.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // For assignment: just show a dialog/demo
                      Get.defaultDialog(
                        title: 'Checkout',
                        middleText: 'This is a demo – implement checkout as needed.',
                        onConfirm: () {
                          Get.back();
                        },
                      );
                    },
                    child: Text('Checkout'),
                  )
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}
