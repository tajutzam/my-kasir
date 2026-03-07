import 'package:floor/floor.dart';
import '../models/category_model.dart';

@dao
abstract class CategoryDao {
  @Query('SELECT * FROM categories WHERE is_deleted = 0 ORDER BY id DESC')
  Future<List<CategoryModel>> getAllCategories();

  @Query('SELECT * FROM categories WHERE id = :id AND is_deleted = 0')
  Future<CategoryModel?> getCategoryById(int id);

  @Query('SELECT * FROM categories WHERE name = :name AND is_deleted = 0 LIMIT 1')
  Future<CategoryModel?> getCategoryByName(String name);

  @Query('SELECT * FROM categories WHERE is_active = 1 AND is_deleted = 0 ORDER BY name ASC')
  Future<List<CategoryModel>> getActiveCategories();

  @insert
  Future<int> insertCategory(CategoryModel category);

  @update
  Future<void> updateCategory(CategoryModel category);

  @delete
  Future<void> deleteCategory(CategoryModel category);

  // Soft delete
  @Query('UPDATE categories SET is_deleted = 1, deleted_at = :deletedAtMillis, is_active = 0 WHERE id = :id')
  Future<void> softDeleteCategory(int id, int deletedAtMillis);

  // Restore
  @Query('UPDATE categories SET is_deleted = 0, deleted_at = NULL, is_active = 1 WHERE id = :id')
  Future<void> restoreCategory(int id);

  // Count
  @Query('SELECT COUNT(*) FROM categories WHERE is_deleted = 0')
  Future<int?> countCategories();

  Future<void> updateCategoryStatus(int id, int i) async {}
}
