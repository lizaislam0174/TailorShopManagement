class User {
  final int? id;
  final String username;
  final String role;
  final String token;

  User({
    this.id,
    required this.username,
    required this.role,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? '',
      role: json['role'] ?? 'USER',
      token: json['token'] ?? '', // Based on how your backend sends the token
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'role': role,
      'token': token,
    };
  }
}
