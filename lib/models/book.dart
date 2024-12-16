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
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      writerName: json['writerName']?.toString() ?? '',
      marketPrice: (json['marketPrice'] as num?)?.toDouble() ?? 0.0,
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble() ?? 0.0,
      location: json['location']?.toString() ?? '',
      condition: json['condition']?.toString() ?? 'Like New',
      sellerId: json['sellerId']?.toString() ?? '',
      genre: json['genre']?.toString() ?? 'Programming',
    );
  }

  Book copyWith({
    String? id,
    String? name,
    String? writerName,
    double? marketPrice,
    double? sellingPrice,
    String? location,
    String? condition,
    String? sellerId,
    String? genre,
  }) {
    return Book(
      id: id ?? this.id,
      name: name ?? this.name,
      writerName: writerName ?? this.writerName,
      marketPrice: marketPrice ?? this.marketPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      location: location ?? this.location,
      condition: condition ?? this.condition,
      sellerId: sellerId ?? this.sellerId,
      genre: genre ?? this.genre,
    );
  }
}
