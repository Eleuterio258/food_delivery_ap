import 'dart:convert';

class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final String phone;
  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });
  final String type = 'user';

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'phone': phone,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
      phone: map['phone'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
