import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';
import '../services/firestore_service.dart';

class CartProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Book> _cartItems = [];
  Stream<DocumentSnapshot>? cartStream;
  double _totalAmount = 0;

  List<Book> get cartItems => [..._cartItems];
  double get totalAmount => _totalAmount;

  CartProvider() {
    _initializeStream();
  }

  void _initializeStream() {
    try {
      cartStream = _firestoreService.getCartItems();
      cartStream?.listen((snapshot) async {
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          final List<String> bookIds = List<String>.from(data['items'] ?? []);
          
          _cartItems = [];
          _totalAmount = 0;
          
          for (String bookId in bookIds) {
            final bookDoc = await _firestoreService.getBookDetails(bookId);
            if (bookDoc.exists) {
              final bookData = bookDoc.data() as Map<String, dynamic>;
              final book = Book.fromJson({...bookData, 'id': bookDoc.id});
              _cartItems.add(book);
              _totalAmount += book.sellingPrice;
            }
          }
          
          notifyListeners();
        } else {
          _cartItems = [];
          _totalAmount = 0;
          notifyListeners();
        }
      });
    } catch (e) {
      print('Error initializing cart stream: $e');
    }
  }

  Future<void> addToCart(Book book) async {
    try {
      await _firestoreService.addToCart(book.id);
      notifyListeners();
    } catch (e) {
      print('Error adding to cart: $e');
      rethrow;
    }
  }

  Future<void> removeFromCart(String bookId) async {
    try {
      await _firestoreService.removeFromCart(bookId);
      notifyListeners();
    } catch (e) {
      print('Error removing from cart: $e');
      rethrow;
    }
  }
}
