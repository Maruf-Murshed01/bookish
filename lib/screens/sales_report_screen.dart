import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class SalesReportScreen extends StatelessWidget {
  const SalesReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for sales
    final dummySales = [
      {
        'bookName': 'The Great Gatsby',
        'buyerName': 'John Doe',
        'buyerMobile': '+8801712345678',
        'transactionId': 'TRX123456',
        'amount': 25.99,
        'date': '2024-12-17',
      },
      {
        'bookName': 'To Kill a Mockingbird',
        'buyerName': 'Jane Smith',
        'buyerMobile': '+8801798765432',
        'transactionId': 'TRX789012',
        'amount': 19.99,
        'date': '2024-12-16',
      },
      {
        'bookName': '1984',
        'buyerName': 'Bob Wilson',
        'buyerMobile': '+8801756789012',
        'transactionId': 'TRX345678',
        'amount': 22.50,
        'date': '2024-12-15',
      },
    ];

    double totalSales = dummySales.fold(0, (sum, item) => sum + (item['amount'] as double));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Report'),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Sales:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${totalSales.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dummySales.length,
              itemBuilder: (context, index) {
                final sale = dummySales[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.sell,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    title: Text(
                      sale['bookName'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Amount: \$${(sale['amount'] as double).toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Buyer Information',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Name: ${sale['buyerName']}'),
                            Text('Mobile: ${sale['buyerMobile']}'),
                            const SizedBox(height: 16),
                            Text(
                              'Transaction Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text('Transaction ID: ${sale['transactionId']}'),
                            Text('Date: ${sale['date']}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
