import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/book_api_service.dart';

class BookstoreScreen extends StatefulWidget {
  const BookstoreScreen({super.key});

  @override
  State<BookstoreScreen> createState() => _BookstoreScreenState();
}

class _BookstoreScreenState extends State<BookstoreScreen> {
  final BookApiService _apiService = BookApiService();
  late Future<List<Book>> _booksFuture;
  String _currentCategory = 'tecnologia programação';

  @override
  void initState() {
    super.initState();
    _booksFuture = _apiService.fetchBooks(query: _currentCategory);
  }

  Future<void> _reloadBooks() async {
    setState(() {
      _booksFuture = _apiService.fetchBooks(query: _currentCategory);
    });
  }

  void _onBuyPressed(Book book) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"${book.title}" adicionado ao carrinho!'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livraria Digital'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RefreshIndicator(
        onRefresh: _reloadBooks,
        child: FutureBuilder<List<Book>>(
          future: _booksFuture,
          builder: (context, snapshot) {
            // Estado 1: Carregando
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Carregando catálogo de livros...'),
                  ],
                ),
              );
            }

            // Estado 2: Erro na requisição
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      Text(
                        snapshot.error.toString().replaceAll('Exception: ', ''),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: _reloadBooks,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Tentar Novamente'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Estado 3: Catálogo vazio
            final books = snapshot.data ?? [];
            if (books.isEmpty) {
              return const Center(
                child: Text('Nenhum livro encontrado no momento.'),
              );
            }

            // Estado 4: Sucesso - ListView Dinâmica
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Capa do Livro
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: book.thumbnailUrl != null
                              ? Image.network(
                                  book.thumbnailUrl!,
                                  width: 75,
                                  height: 110,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => _buildPlaceholderCover(),
                                )
                              : _buildPlaceholderCover(),
                        ),
                        const SizedBox(width: 14),
                        // Informações e Preço
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                book.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                book.authors,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    book.priceLabel,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: book.isForSale
                                          ? Colors.green[700]
                                          : Colors.grey[600],
                                    ),
                                  ),
                                  if (book.isForSale)
                                    FilledButton.tonalIcon(
                                      onPressed: () => _onBuyPressed(book),
                                      icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                                      label: const Text('Comprar'),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPlaceholderCover() {
    return Container(
      width: 75,
      height: 110,
      color: Colors.grey[300],
      child: const Icon(Icons.book, size: 36, color: Colors.grey),
    );
  }
}