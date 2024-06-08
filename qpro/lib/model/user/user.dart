class User {
  final int id;
  final String name;
  final String phone;
  final String email;
  late String error;

  User({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.error,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      error: json['error'] ?? '',
      id: json['id'] ?? '',
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
    };
  }
}
