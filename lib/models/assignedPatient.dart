class CurrentPatient {
  String name;
  String email;
  String id;
  CurrentPatient({required this.name, required this.email, required this.id});
  factory CurrentPatient.fromJson(Map<String, dynamic> json) {
    return CurrentPatient(
      name: json['name'],
      email: json['email'],
      id: json['id'],
    );
  }
  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'id': id,
      };

  @override
  String toString() {
    return 'CurrentPatient(name: $name, email: $email, id: $id)';
  }
}
