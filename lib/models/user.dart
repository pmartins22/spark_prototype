import 'dart:convert';
import 'dart:typed_data';

class User {
  final Uint8List? picture;
  final int id;
  final String email;
  
  User({
    this.picture,
    required this.id,
    required this.email,
    required this.username,
  });

  final String username;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      picture: json['picture'] != null ? base64Decode(json['picture']) : null,
    );
  }
}