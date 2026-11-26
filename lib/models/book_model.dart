class Book {
  final String id;
  final String title;
  final String authors;
  final String description;
  final String? thumbnailUrl;
  final String priceLabel;
  final bool isForSale;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.description,
    this.thumbnailUrl,
    required this.priceLabel,
    required this.isForSale,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final String key = json['key'] ?? '';

    // Extrai autores
    final List<dynamic>? authorsList = json['author_name'];
    final String formattedAuthors = (authorsList != null && authorsList.isNotEmpty)
        ? authorsList.take(2).join(', ')
        : 'Autor desconhecido';

    // Monta URL da capa usando o cover_i da Open Library
    final int? coverId = json['cover_i'];
    final String? coverUrl = coverId != null
        ? 'https://covers.openlibrary.org/b/id/$coverId-M.jpg'
        : null;

    // Gera um preço consistente baseado no tamanho do título
    final double price = 34.90 + (key.length % 45);
    final String formattedPrice = 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';

    return Book(
      id: key,
      title: json['title'] ?? 'Título não informado',
      authors: formattedAuthors,
      description: 'Edição disponível para compra imediata.',
      thumbnailUrl: coverUrl,
      priceLabel: formattedPrice,
      isForSale: true,
    );
  }
}