import 'package:floor/floor.dart';
import '../models/product_model.dart';

@dao
abstract class ProductDao {
  @Query('SELECT * FROM products WHERE is_deleted = 0 ORDER BY id DESC')
  Future<List<ProductModel>> getAllProducts();

  @Query('SELECT * FROM products WHERE id = :id AND is_deleted = 0')
  Future<ProductModel?> getProductById(int id);

  @Query('SELECT * FROM products WHERE sku = :sku AND is_deleted = 0')
  Future<ProductModel?> getProductBySku(String sku);

  @Query(
    'SELECT * FROM products WHERE category_id = :categoryId AND is_deleted = 0 ORDER BY id DESC',
  )
  Future<List<ProductModel>> getProductsByCategory(int categoryId);

  @Query(
    'SELECT * FROM products WHERE name LIKE :searchQuery OR sku LIKE :searchQuery AND is_deleted = 0 ORDER BY id DESC',
  )
  Future<List<ProductModel>> searchProducts(String searchQuery);

  @Query(
    'SELECT * FROM products WHERE stock < :minStock AND is_deleted = 0 AND is_active = 1 ORDER BY stock ASC',
  )
  Future<List<ProductModel>> getLowStockProducts(int minStock);

  @Query(
    'SELECT * FROM products WHERE is_active = 1 AND is_deleted = 0 ORDER BY name ASC',
  )
  Future<List<ProductModel>> getActiveProducts();

  @Query(
    'SELECT * FROM products WHERE stock > 0 AND is_active = 1 AND is_deleted = 0 ORDER BY name ASC',
  )
  Future<List<ProductModel>> getInStockProducts();

  // Soft delete
  @Query(
    'UPDATE products SET is_deleted = 1, deleted_at = :deletedAtMillis, is_active = 0 WHERE id = :id',
  )
  Future<void> softDeleteProduct(int id, int deletedAtMillis);

  // Restore
  @Query(
    'UPDATE products SET is_deleted = 0, deleted_at = NULL, is_active = 1 WHERE id = :id',
  )
  Future<void> restoreProduct(int id);

  // Toggle active
  @Query('UPDATE products SET is_active = :isActive WHERE id = :id')
  Future<void> toggleActive(int id, int isActive);

  @insert
  Future<int> insertProduct(ProductModel product);

  @update
  Future<void> updateProduct(ProductModel product);

  @delete
  Future<void> deleteProduct(ProductModel product);

  // Statistics
  @Query('SELECT COUNT(*) FROM products WHERE is_deleted = 0')
  Future<int?> countProducts();

  @Query(
    'SELECT COUNT(*) FROM products WHERE stock < :minStock AND is_deleted = 0 AND is_active = 1',
  )
  Future<int?> countLowStockProducts(int minStock);

  @Query('SELECT SUM(stock) FROM products WHERE is_deleted = 0')
  Future<int?> getTotalStock();
}
