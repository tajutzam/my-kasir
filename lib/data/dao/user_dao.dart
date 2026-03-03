import 'package:floor/floor.dart';
import '../models/user_model.dart';

@dao
abstract class UserDao {
  @Query('SELECT * FROM users ORDER BY id DESC')
  Future<List<UserModel>> getAllUsers();

  @Query('SELECT * FROM users WHERE id = :id')
  Future<UserModel?> getUserById(int id);

  @Query('SELECT * FROM users WHERE email = :email LIMIT 1')
  Future<UserModel?> getUserByEmail(String email);

  @Query('SELECT * FROM users WHERE email = :email AND password = :password LIMIT 1')
  Future<UserModel?> login(String email, String password);

  @insert
  Future<int> insertUser(UserModel user);

  @update
  Future<void> updateUser(UserModel user);

  @delete
  Future<void> deleteUser(UserModel user);
}
