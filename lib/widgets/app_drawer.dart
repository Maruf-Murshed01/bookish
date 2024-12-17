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
                    leading: const Icon(Icons.shopping_basket),
                    title: const Text('My Cart'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/cart');
                    },
                  ),
                ] else ...[
                  ListTile(
                    leading: const Icon(Icons.login),
                    title: const Text('Login'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.person_add),
                    title: const Text('Register'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                  ),
                ],
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.contact_mail),
                  title: const Text('Contact Us'),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/contact');
                  },
                ),
              ],
            ),
          ),
          if (authProvider.isLoggedIn)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await authProvider.logout();
                  if (context.mounted) {
                    Navigator.pushReplacementNamed(context, '/');
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
