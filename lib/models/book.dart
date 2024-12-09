class Book {
  final String id;
  final String name;
  final String writerName;
  final double marketPrice;
  final double sellingPrice;
  final String location;
  final String condition;
  final String sellerId;
  final String genre;

  Book({
    required this.id,
    required this.name,
    required this.writerName,
    required this.marketPrice,
    required this.sellingPrice,
    required this.location,
    required this.condition,
    required this.sellerId,
    required this.genre,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'writerName': writerName,
      'marketPrice': marketPrice,
      'sellingPrice': sellingPrice,
      'location': location,
      'condition': condition,
      'sellerId': sellerId,
      'genre': genre,
    };
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'],
      writerName: json['writerName'],
      marketPrice: json['marketPrice'].toDouble(),
      sellingPrice: json['sellingPrice'].toDouble(),
      location: json['location'],
      condition: json['condition'],
      sellerId: json['sellerId'],
      genre: json['genre'],
    );
  }
}
