import 'package:spark_prototype/models/user_addresses.dart';
import 'package:spark_prototype/models/user_favorites.dart';
import 'dart:convert';
import 'dart:typed_data';

class User {
  final int id;
  final String email;
  final String username;
  final String? createdAt;
  final Uint8List? picture;
  final List<Address> addresses;
  final List<Favorite> favorites;

  User({
    required this.id,
    required this.email,
    required this.username,
    this.createdAt,
    this.picture,
    this.addresses = const [],
    this.favorites = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      createdAt: json['created_at'],
      picture: json['picture'] != null ? base64Decode(json['picture']) : null,
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((a) => Address.fromJson(a))
          .toList() ??
          [],
      favorites: (json['favorites'] as List<dynamic>?)
          ?.map((f) => Favorite.fromJson(f))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'username': username,
    'created_at': createdAt,
    'picture': picture != null ? base64Encode(picture!) : null,
    'addresses': addresses.map((a) => a.toJson()).toList(),
    'favorites': favorites.map((f) => f.toJson()).toList(),
  };
}