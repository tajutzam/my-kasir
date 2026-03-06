import '../database/app_database.dart';
import '../models/product_model.dart';

class ProductRepository {
  final AppDatabase db;

  ProductRepository(this.db);

  Future<List<ProductModel>> getAll() {
    return db.productDao.getAllProducts();
  }

  Future<ProductModel?> getById(int id) {
    return db.productDao.getProductById(id);
  }

  Future<ProductModel?> getBySku(String sku) {
    return db.productDao.getProductBySku(sku);
  }

  Future<List<ProductModel>> getByCategory(int categoryId) {
    return db.productDao.getProductsByCategory(categoryId);
  }

  Future<List<ProductModel>> search(String query) {
    return db.productDao.searchProducts('%$query%');
  }

  Future<List<ProductModel>> getLowStock(int minStock) {
    return db.productDao.getLowStockProducts(minStock);
  }

  Future<int> insert(ProductModel product) {
    return db.productDao.insertProduct(product);
  }

  Future<void> update(ProductModel product) {
    return db.productDao.updateProduct(product);
  }

  Future<void> delete(ProductModel product) {
    return db.productDao.deleteProduct(product);
  }
}
