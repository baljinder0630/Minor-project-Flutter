import 'dart:convert';

class User {
  final String email;
  final String id;
  final String name;
  final String role;
  String? contactNumber;

  User(
      {required this.email,
      required this.id,
      required this.name,
      required this.role,
      this.contactNumber});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'id': id,
      'name': name,
      'role': role,
      'contactNumber': contactNumber,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
      role: map['role'] as String,
      contactNumber: map['contactNumber'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) =>
      User.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'User(email: $email, id: $id, name: $name, role: $role, contactNumber: $contactNumber)';
  }
}
