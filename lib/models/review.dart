class Review {
  final String id;
  final String name;
  final String email;
  final String bookName;
  final String authorName;
  final String review;
  final DateTime timestamp;

  Review({
    required this.id,
    required this.name,
    required this.email,
    required this.bookName,
    required this.authorName,
    required this.review,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'bookName': bookName,
      'authorName': authorName,
      'review': review,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map, String id) {
    return Review(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bookName: map['bookName'] ?? '',
      authorName: map['authorName'] ?? '',
      review: map['review'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}
