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
        throw Exception('Failed to set user type');
      }
    }
  }

  Future<String?> signup(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Create user document in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': email,
        'userType': '',
        'createdAt': FieldValue.serverTimestamp(),
      });
      
      return null; // Success, no error message
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'An account already exists for that email.';
      } else {
        return 'Error: ${e.message}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // Success, no error message
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided.';
      } else {
        return 'Error: ${e.message}';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    _userType = '';
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
