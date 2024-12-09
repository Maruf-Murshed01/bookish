import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_drawer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Resale Platform'),
        actions: [
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              if (authProvider.isLoggedIn) {
                return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => authProvider.logout(),
                );
              }
              return IconButton(
                icon: const Icon(Icons.login),
                onPressed: () => Navigator.pushNamed(context, '/login'),
              );
            },
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: Stack(
        children: [
          // Background Image
          Image.asset(
            'assets/home.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          // Content overlay
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                Text(
                  '',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  '',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),
                // Conditional Login/Home Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: ElevatedButton(
                          onPressed: () => authProvider.isLoggedIn
                              ? Navigator.pushNamed(context, '/')
                              : Navigator.pushNamed(context, '/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Text(
                            authProvider.isLoggedIn
                                ? 'Welcome Buddy!'
                                : 'Login',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
