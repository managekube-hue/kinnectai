class User {
  final String id;
  final String name;
  final double kinScore;

  User({required this.id, required this.name, required this.kinScore});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      kinScore: json['kinScore'],
    );
  }
}

class Memory {
  final String id;
  final String content;
  final String creatorId;

  Memory({required this.id, required this.content, required this.creatorId});

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      id: json['id'],
      content: json['content'],
      creatorId: json['creatorId'],
    );
  }
}