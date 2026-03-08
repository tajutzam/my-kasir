import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../data/database/app_database.dart';
import '../../data/models/store_profile_model.dart';
import '../../data/models/category_model.dart';

class DatabaseService extends GetxService {
  late AppDatabase database;

  static const String _dbName = 'pos_database.db';

  Future<DatabaseService> init() async {
    // FOR DEVELOPMENT: Uncomment to delete database on each launch
    // TODO: Comment this out in production
    // final dbPath = await getDatabasesPath();
    // final path = join(dbPath, _dbName);
    // try {
    //   await deleteDatabase(path);
    // } catch (e) {
    //   // Database doesn't exist, that's fine
    // }

    // Initialize database (persists data between app launches)
    database = await $FloorAppDatabase
        .databaseBuilder(_dbName)
        .build();
    await _initializeDefaultData();

    return this;
  }

  Future<void> _initializeDefaultData() async {
    // Insert default category
    final now = DateTime.now().millisecondsSinceEpoch;
    final existingCategories = await database.categoryDao.getCategoryByName('Uncategorized');
    if (existingCategories == null) {
      await database.categoryDao.insertCategory(CategoryModel(
        id: 1,
        name: 'Uncategorized',
        isActive: 1,
        createdAt: DateTime.fromMillisecondsSinceEpoch(now),
        updatedAt: DateTime.fromMillisecondsSinceEpoch(now),
      ));
    }

    // Insert default store profile
    final existingProfile = await database.storeProfileDao.getStoreProfile();
    if (existingProfile == null) {
      await database.storeProfileDao.insertStoreProfile(StoreProfileModel.defaultProfile());
    }
  }
}
