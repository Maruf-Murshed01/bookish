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
import 'screens/register_screen.dart';
import 'screens/reviews_screen.dart';
import 'screens/sales_report_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      routes: {
        '/': (ctx) => const HomeScreen(),
        '/login': (ctx) => const LoginScreen(),
        '/register': (ctx) => const RegisterScreen(),
        '/services': (ctx) => const ServicesScreen(),
        '/buyer': (ctx) => const BuyerScreen(),
        '/seller': (ctx) => const SellerScreen(),
        '/contact': (ctx) => const ContactScreen(),
        '/cart': (ctx) => const CartScreen(),
        '/reviews': (ctx) => const ReviewsScreen(),
        '/sales-report': (ctx) => const SalesReportScreen(),
      },
    );
  }
}
