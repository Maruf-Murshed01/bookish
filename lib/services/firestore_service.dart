import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Books Collection
  Future<void> addBook({
    required String name,
    required String writerName,
    required double marketPrice,
    required double sellingPrice,
    required String location,
    required String condition,
    required String genre,
  }) async {
    try {
      await _firestore.collection('books').add({
        'name': name,
        'writerName': writerName,
        'marketPrice': marketPrice,
        'sellingPrice': sellingPrice,
        'location': location,
        'condition': condition,
        'genre': genre,
        'sellerId': _auth.currentUser?.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add book: $e');
    }
  }

  // Get all books for sale
  Future<QuerySnapshot> getBooks() {
    return _firestore
        .collection('books')
        .orderBy('createdAt', descending: true)
        .get();
  }

  // Get books by seller
  Stream<QuerySnapshot> getBooksBySeller(String sellerId) {
    return _firestore
        .collection('books')
        .where('sellerId', isEqualTo: sellerId)
        .snapshots();
  }

  // Cart Operations
  Future<void> addToCart(String bookId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    try {
      final cartRef = _firestore.collection('carts').doc(userId);
      await cartRef.set({
        'items': FieldValue.arrayUnion([bookId]),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  Future<void> removeFromCart(String bookId) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    try {
      final cartRef = _firestore.collection('carts').doc(userId);
      await cartRef.update({
        'items': FieldValue.arrayRemove([bookId]),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to remove from cart: $e');
    }
  }

  Stream<DocumentSnapshot> getCartItems() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    return _firestore.collection('carts').doc(userId).snapshots();
  }

  // Get book details
  Future<DocumentSnapshot> getBookDetails(String bookId) {
    return _firestore.collection('books').doc(bookId).get();
  }

  // Delete book
  Future<void> deleteBook(String bookId) async {
    try {
      await _firestore.collection('books').doc(bookId).delete();
    } catch (e) {
      throw Exception('Failed to delete book: $e');
    }
  }

  // Update book
  Future<void> updateBook(String bookId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('books').doc(bookId).update(data);
    } catch (e) {
      throw Exception('Failed to update book: $e');
    }
  }
}
