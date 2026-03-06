import 'package:floor/floor.dart';

@Entity(tableName: 'users')
class UserModel {
  @primaryKey
  final int? id;

  final String fullName;
  final String email;
  final String password; // In production, this should be hashed!
  final String? phone;
  final int createdAtMillis;
  final int updatedAtMillis;

  // Getters for convenience
  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(createdAtMillis);
  DateTime get updatedAt => DateTime.fromMillisecondsSinceEpoch(updatedAtMillis);

  UserModel({
    this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAtMillis = createdAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
        updatedAtMillis = updatedAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;

  // CopyWith method
  UserModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? password,
    String? phone,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      phone: phone ?? this.phone,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
