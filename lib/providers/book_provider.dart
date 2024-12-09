import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

class BookProvider with ChangeNotifier {
  List<Book> _books = [];
  final String _storageKey = 'books';

  List<Book> get books => [..._books];

  BookProvider() {
    loadBooks();
  }

  Future<void> loadBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? booksJson = prefs.getString(_storageKey);
    
    if (booksJson != null) {
      final List<dynamic> decodedData = json.decode(booksJson);
      _books = decodedData.map((item) => Book.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> saveBooks() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = json.encode(
      _books.map((book) => book.toJson()).toList(),
    );
    await prefs.setString(_storageKey, encodedData);
  }

  Future<void> addBook(Book book) async {
    _books.add(book);
    await saveBooks();
    notifyListeners();
  }

  Future<void> updateBook(Book updatedBook) async {
    final index = _books.indexWhere((book) => book.id == updatedBook.id);
    if (index >= 0) {
      _books[index] = updatedBook;
      await saveBooks();
      notifyListeners();
    }
  }

  Future<void> deleteBook(String bookId) async {
    _books.removeWhere((book) => book.id == bookId);
    await saveBooks();
    notifyListeners();
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
