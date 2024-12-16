import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/app_drawer.dart';

class BuyerScreen extends StatefulWidget {
  const BuyerScreen({super.key});

  @override
  State<BuyerScreen> createState() => _BuyerScreenState();
}

class _BuyerScreenState extends State<BuyerScreen> {
  String _selectedGenre = 'All';
  RangeValues _priceRange = const RangeValues(0, 1000);
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showBookDetails(BuildContext context, Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(book.name),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Author: ${book.writerName}'),
              const SizedBox(height: 8),
              Text('Genre: ${book.genre}'),
              const SizedBox(height: 8),
              Text('Condition: ${book.condition}'),
              const SizedBox(height: 8),
              Text('Market Price: \$${book.marketPrice.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text('Selling Price: \$${book.sellingPrice.toStringAsFixed(2)}'),
              const SizedBox(height: 8),
              Text('Location: ${book.location}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final cartProvider = context.read<CartProvider>();
              cartProvider.addToCart(book);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Book added to cart')),
              );
            },
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookProvider = Provider.of<BookProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    List<Book> filteredBooks = bookProvider.books.where((book) {
      final matchesGenre = _selectedGenre == 'All' || book.genre == _selectedGenre;
      final matchesPrice = book.sellingPrice >= _priceRange.start && 
                          book.sellingPrice <= _priceRange.end;
      final matchesSearch = _searchQuery.isEmpty ||
          book.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.writerName.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesGenre && matchesPrice && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buy Books'),
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search books or authors',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedGenre == 'All',
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedGenre = 'All';
                      });
                    }
                  },
                ),
                const SizedBox(width: 8),
                ...['Fiction', 'Non-Fiction', 'Science', 'History', 'Biography']
                    .map((genre) => Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(genre),
                            selected: _selectedGenre == genre,
                            onSelected: (selected) {
                              if (selected) {
                                setState(() {
                                  _selectedGenre = genre;
                                });
                              }
                            },
                          ),
                        ))
                    .toList(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Price Range'),
                RangeSlider(
                  values: _priceRange,
                  min: 0,
                  max: 1000,
                  divisions: 20,
                  labels: RangeLabels(
                    '\$${_priceRange.start.round()}',
                    '\$${_priceRange.end.round()}',
                  ),
                  onChanged: (RangeValues values) {
                    setState(() {
                      _priceRange = values;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: bookProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : bookProvider.error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error: ${bookProvider.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => bookProvider.fetchBooks(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      )
                    : filteredBooks.isEmpty
                        ? const Center(
                            child: Text('No books found'),
                          )
                        : RefreshIndicator(
                            onRefresh: () => bookProvider.fetchBooks(),
                            child: GridView.builder(
                              padding: const EdgeInsets.all(8.0),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.7,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: filteredBooks.length,
                              itemBuilder: (context, index) {
                                final book = filteredBooks[index];
                                return Card(
                                  elevation: 4,
                                  child: InkWell(
                                    onTap: () => _showBookDetails(context, book),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: Icon(
                                                Icons.book,
                                                size: 64,
                                                color: Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.7),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            book.name,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            book.writerName,
                                            style:
                                                const TextStyle(color: Colors.grey),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '\$${book.sellingPrice.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              color:
                                                  Theme.of(context).primaryColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
}
