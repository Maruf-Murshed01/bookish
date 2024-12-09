import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/book_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/services_screen.dart';
import 'screens/buyer_screen.dart';
import 'screens/seller_screen.dart';
import 'screens/contact_screen.dart';
import 'screens/cart_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BookProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Resale App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routes: {
        '/': (ctx) => const HomeScreen(),
        '/login': (ctx) => const LoginScreen(),
        '/services': (ctx) => const ServicesScreen(),
        '/buyer': (ctx) => const BuyerScreen(),
        '/seller': (ctx) => const SellerScreen(),
        '/contact': (ctx) => const ContactScreen(),
        '/cart': (ctx) => const CartScreen(),
      },
    );
  }
}
