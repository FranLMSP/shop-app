import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/http_exception.dart';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    /* Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ), */
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://shop-app-test-5aef2-default-rtdb.firebaseio.com/products.json';
    try {
      final List<Product> loadedProducts = [];
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData != null) {
        extractedData.forEach((productId, productData) {
          loadedProducts.add(Product(
            id: productId,
            title: productData['title'],
            price: productData['price'],
            description: productData['description'],
            imageUrl: productData['imageUrl'],
            isFavorite: productData['isFavorite'],
          ));
        });
      }
      _items = loadedProducts;
      notifyListeners();
    } catch(error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://shop-app-test-5aef2-default-rtdb.firebaseio.com/products.json';
    try {
      final response = await http.post(url, body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }),);
      final newProduct = Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((item) => item.id == product.id);
    if (index >= 0) {
      final url = 'https://shop-app-test-5aef2-default-rtdb.firebaseio.com/products/${product.id}.json';
      await http.patch(url, body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }),);
      _items[index] = product;
      notifyListeners();
    } else {
      print('Product item not found');
    }
  }

  Future<void> deleteProduct(String productId) async {
    final url = 'https://shop-app-test-5aef2-default-rtdb.firebaseio.com/products/$productId.json';
    final existingIndex = _items.indexWhere((product) => product.id == productId);
    Product product = _items[existingIndex];
    _items.removeAt(existingIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingIndex, product);
      notifyListeners();
      throw HttpException('Could not delete the product.');
    }
    product = null;
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

}