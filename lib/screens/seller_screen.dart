import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../providers/book_provider.dart';
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

  @override
  void dispose() {
    _nameController.dispose();
    _writerController.dispose();
    _marketPriceController.dispose();
    _sellingPriceController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _showBookDialog({Book? book}) {
    if (book != null) {
      _nameController.text = book.name;
      _writerController.text = book.writerName;
      _marketPriceController.text = book.marketPrice.toString();
      _sellingPriceController.text = book.sellingPrice.toString();
      _locationController.text = book.location;
      _selectedCondition = book.condition;
      _selectedGenre = book.genre;
    } else {
      _nameController.clear();
      _writerController.clear();
      _marketPriceController.clear();
      _sellingPriceController.clear();
      _locationController.clear();
      _selectedCondition = 'Like New';
      _selectedGenre = 'Programming';
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
                      value?.isEmpty ?? true ? 'Required field' : null,
                ),
                TextFormField(
                  controller: _writerController,
                  decoration: const InputDecoration(labelText: 'Writer Name'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required field' : null,
                ),
                TextFormField(
                  controller: _marketPriceController,
                  decoration: const InputDecoration(labelText: 'Market Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required field' : null,
                ),
                TextFormField(
                  controller: _sellingPriceController,
                  decoration: const InputDecoration(labelText: 'Selling Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required field' : null,
                ),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(labelText: 'Location'),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Required field' : null,
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
                  items: ['Programming', 'Fiction', 'Science']
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final bookProvider = context.read<BookProvider>();
                final newBook = Book(
                  id: book?.id ?? DateTime.now().toString(),
                  name: _nameController.text,
                  writerName: _writerController.text,
                  marketPrice: double.parse(_marketPriceController.text),
                  sellingPrice: double.parse(_sellingPriceController.text),
                  location: _locationController.text,
                  condition: _selectedCondition,
                  sellerId: 'seller1',
                  genre: _selectedGenre,
                );

                if (book != null) {
                  bookProvider.updateBook(newBook);
                } else {
                  bookProvider.addBook(newBook);
                }

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      book == null
                          ? 'Book added successfully!'
                          : 'Book updated successfully!',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: Text(book == null ? 'Add Book' : 'Save Changes'),
          ),
        ],
      ),
    );
  }

  void _deleteBook(Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Book'),
        content: Text('Are you sure you want to delete "${book.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<BookProvider>().deleteBook(book.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Book deleted successfully!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Books'),
      ),
      drawer: const AppDrawer(),
      body: Consumer<BookProvider>(
        builder: (context, bookProvider, child) {
          final books = bookProvider.books;
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(book.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Author: ${book.writerName}'),
                      Text('Market Price: \$${book.marketPrice}'),
                      Text('Selling Price: \$${book.sellingPrice}'),
                      Text('Condition: ${book.condition}'),
                      Text('Location: ${book.location}'),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showBookDialog(book: book),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () => _deleteBook(book),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showBookDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
