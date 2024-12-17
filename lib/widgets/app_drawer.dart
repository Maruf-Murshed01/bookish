import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    
    return Drawer(
      child: Column(
        children: [
          if (authProvider.isLoggedIn) ...[
            UserAccountsDrawerHeader(
              accountName: const Text(''),  // We don't show name
              accountEmail: Text(authProvider.userEmail ?? 'No email'),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
          ] else ...[
            const DrawerHeader(
              child: Center(
                child: Text(
                  'Book Resale Platform',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ],
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text('Home'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
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
                  title: const Text('Cart'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/cart');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.rate_review),
                  title: const Text('Book Reviews'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/reviews');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.contact_mail),
                  title: const Text('Contact Us'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/contact');
                  },
                ),
                if (authProvider.isLoggedIn)
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () async {
                      await authProvider.logout();
                      if (context.mounted) {
                        Navigator.pushReplacementNamed(context, '/');
                      }
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
