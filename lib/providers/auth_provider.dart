import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  String _userType = '';

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        // Load user type when user logs in
        _loadUserType();
      } else {
        _userType = '';
      }
      notifyListeners();
    });
  }

  bool get isLoggedIn => _user != null;
  String? get userEmail => _user?.email;
  String? get userId => _user?.uid;
  String get userType => _userType;

  Future<void> _loadUserType() async {
    if (_user != null) {
      try {
        final doc = await _firestore.collection('users').doc(_user!.uid).get();
        if (doc.exists) {
          _userType = doc.data()?['userType'] ?? '';
          notifyListeners();
        }
      } catch (e) {
        print('Error loading user type: $e');
      }
    }
  }

  Future<void> setUserType(String type) async {
    if (_user != null) {
      try {
        await _firestore.collection('users').doc(_user!.uid).set({
          'userType': type,
          'email': _user!.email,
        }, SetOptions(merge: true));
        _userType = type;
        notifyListeners();
      } catch (e) {
        print('Error setting user type: $e');
        rethrow;
      }
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      await _loadUserType();
      notifyListeners();
    } catch (e) {
      print('Error signing in: $e');
      rethrow;
    }
  }

  Future<void> register(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      _user = userCredential.user;
      notifyListeners();
    } catch (e) {
      print('Error registering: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      _user = null;
      _userType = '';
      notifyListeners();
    } catch (e) {
      print('Error logging out: $e');
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Error resetting password: $e');
      rethrow;
    }
  }
}
