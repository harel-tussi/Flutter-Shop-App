import 'package:flutter/material.dart';

import './product.dart';
import '../data/dummy_data.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((proItem) => proItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addProduct(Product product) {
    final newProduct = Product(
        title: product.title,
        price: product.price,
        imageUrl: product.imageUrl,
        description: product.description,
        id: DateTime.now().toString());
    _items.add(newProduct);
    notifyListeners();
  }

  void updateProduct(String id, Product newProduct) {
    print(id);
    print(newProduct);
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    print(prodIndex);
    if (prodIndex < 0) {
      return;
    }
    _items[prodIndex] = newProduct;
    notifyListeners();
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }
}
