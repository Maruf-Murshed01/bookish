import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

class CartProvider with ChangeNotifier {
  List<Book> _cartItems = [];
  final String _storageKey = 'cart_items';

  List<Book> get cartItems => [..._cartItems];

  CartProvider() {
    loadCart();
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartJson = prefs.getString(_storageKey);
    
    if (cartJson != null) {
      final List<dynamic> decodedData = json.decode(cartJson);
      _cartItems = decodedData.map((item) => Book.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _cartItems.map((book) => book.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encodedData);
  }

  Future<void> addToCart(Book book) async {
    if (!_cartItems.any((item) => item.id == book.id)) {
      _cartItems.add(book);
      await saveCart();
      notifyListeners();
    }
  }

  Future<void> removeFromCart(String bookId) async {
    _cartItems.removeWhere((item) => item.id == bookId);
    await saveCart();
    notifyListeners();
  }

  double get totalAmount {
    return _cartItems.fold(0, (sum, item) => sum + item.sellingPrice);
  }

  void clearCart() {
    _cartItems.clear();
    saveCart();
    notifyListeners();
  }
}
