import '../database/app_database.dart';
import '../models/user_model.dart';

class UserRepository {
  final AppDatabase db;

  UserRepository(this.db);

  Future<List<UserModel>> getAll() {
    return db.userDao.getAllUsers();
  }

  Future<UserModel?> getById(int id) {
    return db.userDao.getUserById(id);
  }

  Future<UserModel?> getByEmail(String email) {
    return db.userDao.getUserByEmail(email);
  }

  Future<UserModel?> login(String email, String password) {
    return db.userDao.login(email, password);
  }

  Future<int> register(UserModel user) {
    return db.userDao.insertUser(user);
  }

  Future<void> update(UserModel user) {
    return db.userDao.updateUser(user);
  }

  Future<void> delete(UserModel user) {
    return db.userDao.deleteUser(user);
  }

  Future<bool> emailExists(String email) async {
    final user = await getByEmail(email);
    return user != null;
  }
}
