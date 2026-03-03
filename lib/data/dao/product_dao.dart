import 'package:floor/floor.dart';
import '../models/product_model.dart';

@dao
abstract class ProductDao {
  @Query('SELECT * FROM products ORDER BY id DESC')
  Future<List<ProductModel>> getAllProducts();

  @insert
  Future<void> insertProduct(ProductModel product);

  @update
  Future<void> updateProduct(ProductModel product);

  @delete
  Future<void> deleteProduct(ProductModel product);
}
