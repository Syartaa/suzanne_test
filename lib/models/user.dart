import 'dart:convert';

class User {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? gender; // Optional
  final String? id; // Optional for responses like login or registration success
  final String? token; // ✅ Add token for authentication

  User({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.gender,
    this.id,
    this.token,
  });

  // Factory method to create a User object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    print("Parsing User JSON: $json"); // Add this debug print
    return User(
      firstName: json['first_name'] is String ? json['first_name'] : '',
      lastName: json['last_name'] is String ? json['last_name'] : '',
      email: json['email'] is String ? json['email'] : '',
      password: json['password'] is String ? json['password'] : '',
      gender: json['gender'] is String ? json['gender'] : null,
      id: json['id'] is String ? json['id'] : json['id'].toString(),
      token: json['token'] is String
          ? json['token']
          : null, // ✅ Extract token from API response
    );
  }

  // Method to convert a User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'password': password,
      'gender': gender,
      'id': id,
      'token': token,
    };
  }

  @override
  String toString() {
    return 'User(firstName: $firstName, lastName: $lastName, email: $email, gender: $gender, id: $id, token: $token)';
  }
}
