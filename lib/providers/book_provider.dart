import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';
import '../services/firestore_service.dart';

class BookProvider with ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  List<Book> _books = [];
  bool _isLoading = false;
  String? _error;

  List<Book> get books => [..._books];
  bool get isLoading => _isLoading;
  String? get error => _error;

  BookProvider() {
    fetchBooks();
  }

  Future<void> fetchBooks() async {
    if (_isLoading) return;
    
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final snapshot = await _firestoreService.getBooks();
      _books = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Book.fromJson({...data, 'id': doc.id});
      }).toList();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      print('Error fetching books: $e');
    }
  }

  Future<void> addBook(Book book) async {
    try {
      await _firestoreService.addBook(
        name: book.name,
        writerName: book.writerName,
        marketPrice: book.marketPrice,
        sellingPrice: book.sellingPrice,
        location: book.location,
        condition: book.condition,
        genre: book.genre,
      );
      await fetchBooks(); // Refresh the books list
    } catch (e) {
      print('Error adding book: $e');
      rethrow;
    }
  }

  Future<void> updateBook(Book updatedBook) async {
    try {
      await _firestoreService.updateBook(updatedBook.id, {
        'name': updatedBook.name,
        'writerName': updatedBook.writerName,
        'marketPrice': updatedBook.marketPrice,
        'sellingPrice': updatedBook.sellingPrice,
        'location': updatedBook.location,
        'condition': updatedBook.condition,
        'genre': updatedBook.genre,
      });
      await fetchBooks(); // Refresh the books list
    } catch (e) {
      print('Error updating book: $e');
      rethrow;
    }
  }

  Future<void> deleteBook(String bookId) async {
    try {
      await _firestoreService.deleteBook(bookId);
      await fetchBooks(); // Refresh the books list
    } catch (e) {
      print('Error deleting book: $e');
      rethrow;
    }
  }

  Stream<QuerySnapshot> getSellerBooks(String sellerId) {
    return _firestoreService.getBooksBySeller(sellerId);
  }

  List<Book> getFilteredBooks({String? genre, RangeValues? priceRange}) {
    return _books.where((book) {
      bool matchesGenre = genre == null || genre == 'All' || book.genre == genre;
      bool matchesPrice = priceRange == null ||
          (book.sellingPrice >= priceRange.start &&
              book.sellingPrice <= priceRange.end);
      return matchesGenre && matchesPrice;
    }).toList();
  }
}
