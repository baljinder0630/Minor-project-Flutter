import 'dart:convert';

class UserModel {
  final String email;
  final String id;
  final String name;
  final String role;
  String? contactNumber;

  UserModel(
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

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] as String,
      id: map['id'] as String,
      name: map['name'] as String,
      role: map['role'] as String,
      contactNumber: map['contactNumber'] as String,
    );
  }

  @override
  String toString() {
    return 'User(email: $email, id: $id, name: $name, role: $role, contactNumber: $contactNumber)';
  }
}
