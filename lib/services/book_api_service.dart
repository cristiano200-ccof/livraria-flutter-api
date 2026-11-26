import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book_model.dart';

class BookApiService {
  Future<List<Book>> fetchBooks({String query = 'flutter'}) async {
    try {
      final uri = Uri.https('openlibrary.org', '/search.json', {
        'q': query,
        'limit': '20',
      });

      final response = await http.get(uri).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        final List<dynamic> docs = data['docs'] ?? [];

        return docs.map((item) => Book.fromJson(item)).toList();
      } else {
        throw Exception('Falha ao consultar catálogo (Erro ${response.statusCode})');
      }
    } on TimeoutException {
      throw Exception('A loja demorou muito para responder. Tente novamente.');
    } catch (e) {
      throw Exception('Erro de conexão ao carregar os livros: $e');
    }
  }
}