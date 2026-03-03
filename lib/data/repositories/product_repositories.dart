import '../database/app_database.dart';
import '../models/product_model.dart';

class ProductRepository {
  final AppDatabase db;

  ProductRepository(this.db);

  Future<List<ProductModel>> getAll() {
    return db.productDao.getAllProducts();
  }

  Future<void> insert(ProductModel product) {
    return db.productDao.insertProduct(product);
  }

  Future<void> update(ProductModel product) {
    return db.productDao.updateProduct(product);
  }

  Future<void> delete(ProductModel product) {
    return db.productDao.deleteProduct(product);
  }
}
