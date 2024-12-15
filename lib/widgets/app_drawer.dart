import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: Center(
              child: Text(
                'Book Resale Platform',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          if (authProvider.isLoggedIn) ...[
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Buy Books'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/buyer');
              },
            ),
            ListTile(
              leading: const Icon(Icons.store),
              title: const Text('Sell Books'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/seller');
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('My Cart'),
              onTap: () {
                Navigator.pushReplacementNamed(context, '/cart');
              },
            ),
          ],
          ListTile(
            leading: const Icon(Icons.contact_support),
            title: const Text('Contact Us'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/contact');
            },
          ),
          if (authProvider.isLoggedIn) ...[
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                authProvider.logout();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ],
      ),
    );
  }
}
