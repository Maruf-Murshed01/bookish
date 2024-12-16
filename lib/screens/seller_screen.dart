import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/app_drawer.dart';

class SellerScreen extends StatefulWidget {
  const SellerScreen({super.key});

  @override
  State<SellerScreen> createState() => _SellerScreenState();
}

class _SellerScreenState extends State<SellerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _writerController = TextEditingController();
  final _marketPriceController = TextEditingController();
  final _sellingPriceController = TextEditingController();
  final _locationController = TextEditingController();
  String _selectedCondition = 'Like New';
  String _selectedGenre = 'Programming';
  Book? _editingBook;

  @override
  void dispose() {
    _nameController.dispose();
    _writerController.dispose();
    _marketPriceController.dispose();
    _sellingPriceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _editingBook = null;
    _nameController.clear();
    _writerController.clear();
    _marketPriceController.clear();
    _sellingPriceController.clear();
    _locationController.clear();
    _selectedCondition = 'Like New';
    _selectedGenre = 'Programming';
  }

  void _showBookDialog({Book? book}) {
    _editingBook = book;
    if (book != null) {
      _nameController.text = book.name;
      _writerController.text = book.writerName;
      _marketPriceController.text = book.marketPrice.toString();
      _sellingPriceController.text = book.sellingPrice.toString();
      _locationController.text = book.location;
      _selectedCondition = book.condition;
      _selectedGenre = book.genre;
    } else {
      _resetForm();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(book == null ? 'Add New Book' : 'Edit Book'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Book Name'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter book name' : null,
                ),
                TextFormField(
                  controller: _writerController,
                  decoration: const InputDecoration(labelText: 'Author Name'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter author name' : null,
                ),
                TextFormField(
                  controller: _marketPriceController,
                  decoration: const InputDecoration(labelText: 'Market Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter market price' : null,
                ),
                TextFormField(
                  controller: _sellingPriceController,
                  decoration: const InputDecoration(labelText: 'Selling Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter selling price' : null,
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter location' : null,
                ),
                DropdownButtonFormField<String>(
                  value: _selectedCondition,
                  decoration: const InputDecoration(labelText: 'Condition'),
                  items: ['Like New', 'Good', 'Fair', 'Poor']
                      .map((condition) => DropdownMenuItem(
                            value: condition,
                            child: Text(condition),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCondition = value!;
                    });
                  },
                ),
                DropdownButtonFormField<String>(
                  value: _selectedGenre,
                  decoration: const InputDecoration(labelText: 'Genre'),
                  items: ['Programming', 'Fiction', 'Non-Fiction', 'Science']
                      .map((genre) => DropdownMenuItem(
                            value: genre,
                            child: Text(genre),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGenre = value!;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetForm();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                final bookProvider = context.read<BookProvider>();
                final authProvider = context.read<AuthProvider>();
                final userId = authProvider.userId;

                if (userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please login first')),
                  );
                  return;
                }

                final book = Book(
                  id: _editingBook?.id ?? '',
                  name: _nameController.text,
                  writerName: _writerController.text,
                  marketPrice: double.parse(_marketPriceController.text),
                  sellingPrice: double.parse(_sellingPriceController.text),
                  location: _locationController.text,
                  condition: _selectedCondition,
                  sellerId: userId,
                  genre: _selectedGenre,
                );

                try {
                  if (_editingBook != null) {
                    await bookProvider.updateBook(book);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Book updated successfully')),
                      );
                    }
                  } else {
                    await bookProvider.addBook(book);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Book added successfully')),
                      );
                    }
                  }
                  if (mounted) {
                    Navigator.pop(context);
                    _resetForm();
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                }
              }
            },
            child: Text(_editingBook == null ? 'Add Book' : 'Update Book'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final userId = authProvider.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sell Books'),
      ),
      drawer: const AppDrawer(),
      body: userId == null
          ? const Center(child: Text('Please login to sell books'))
          : Consumer<BookProvider>(
              builder: (context, bookProvider, child) {
                return StreamBuilder<QuerySnapshot>(
                  stream: bookProvider.getSellerBooks(userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final books = snapshot.data!.docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      return Book.fromJson({...data, 'id': doc.id});
                    }).toList();

                    return Column(
                      children: [
                        Expanded(
                          child: books.isEmpty
                              ? const Center(
                                  child: Text('You haven\'t added any books yet'))
                              : ListView.builder(
                                  itemCount: books.length,
                                  itemBuilder: (context, index) {
                                    final book = books[index];
                                    return Card(
                                      margin: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        title: Text(book.name),
                                        subtitle: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Author: ${book.writerName}'),
                                            Text(
                                                'Price: \$${book.sellingPrice}'),
                                            Text('Genre: ${book.genre}'),
                                          ],
                                        ),
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () =>
                                                  _showBookDialog(book: book),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () async {
                                                final confirm =
                                                    await showDialog<bool>(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: const Text(
                                                        'Delete Book'),
                                                    content: const Text(
                                                        'Are you sure you want to delete this book?'),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, false),
                                                        child:
                                                            const Text('Cancel'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context, true),
                                                        child:
                                                            const Text('Delete'),
                                                      ),
                                                    ],
                                                  ),
                                                );

                                                if (confirm == true) {
                                                  try {
                                                    await bookProvider
                                                        .deleteBook(book.id);
                                                    if (mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                          content: Text(
                                                              'Book deleted successfully'),
                                                        ),
                                                      );
                                                    }
                                                  } catch (e) {
                                                    if (mounted) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content:
                                                              Text('Error: $e'),
                                                        ),
                                                      );
                                                    }
                                                  }
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton(
                            onPressed: () => _showBookDialog(),
                            child: const Text('Add New Book'),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
    );
  }
}
