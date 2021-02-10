import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './cart.dart';
import './product.dart';

class OrderItem with ChangeNotifier {
  final String id;
  final double amount;
  final DateTime dateTime;
  final List<CartItem> products;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    const url = 'https://shop-app-test-5aef2-default-rtdb.firebaseio.com/orders.json';
    try {
      final List<OrderItem> loadedCartItems = [];
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData != null ) {
        extractedData.forEach((orderId, orderData) {
          final List<CartItem> products = [];
          for (int i = 0; i < orderData['products'].length; i++) {
            final cartItemData = orderData['products'][0];
            products.add(CartItem(
              id: cartItemData['id'],
              quantity: cartItemData['quantity'],
              product: Product(
                id: cartItemData['product']['id'],
                title: cartItemData['product']['title'],
                price: cartItemData['product']['price'],
                description: cartItemData['product']['description'],
                imageUrl: cartItemData['product']['imageUrl'],
                isFavorite: cartItemData['product']['isFavorite'],
              ),
            ));
          }

          loadedCartItems.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: products,
          ));

        });
      }
      _orders = loadedCartItems;
      notifyListeners();
    } catch(error) {
      throw error;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shop-app-test-5aef2-default-rtdb.firebaseio.com/orders.json';
    final dateTime = DateTime.now();
    try {
      final response = await http.post(url, body: json.encode({
        'amount': total,
        'dateTime': dateTime.toString(),
        'products': cartProducts.map((cartItem) {
          return {
            'id': cartItem.id,
            'quantity': cartItem.quantity,
            'product': {
              'id': cartItem.product.id,
              'title': cartItem.product.title,
              'description': cartItem.product.description,
              'price': cartItem.product.price,
              'imageUrl': cartItem.product.imageUrl,
              'isFavorite': cartItem.product.isFavorite,
            },
          };
        }).toList()
      }),);
      final newOrder = OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        dateTime: dateTime,
        products: cartProducts,
      );
      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}