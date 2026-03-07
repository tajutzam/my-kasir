import '../database/app_database.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final AppDatabase db;

  CategoryRepository(this.db);

  Future<List<CategoryModel>> getAll() {
    return db.categoryDao.getAllCategories();
  }

  Future<CategoryModel?> getById(int id) {
    return db.categoryDao.getCategoryById(id);
  }

  Future<int> insert(CategoryModel category) {
    return db.categoryDao.insertCategory(category);
  }

  Future<void> update(CategoryModel category) {
    return db.categoryDao.updateCategory(category);
  }

  Future<void> delete(CategoryModel category) {
    return db.categoryDao.deleteCategory(category);
  }

  Future<void> softDelete(int id) {
    return db.categoryDao.softDeleteCategory(
      id,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  Future<void> toggleStatus(int id, bool isActive) {
    return db.categoryDao.updateCategoryStatus(id, isActive ? 1 : 0);
  }
}
