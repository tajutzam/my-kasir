import 'package:floor/floor.dart';
import '../models/transaction_item_model.dart';

@dao
abstract class TransactionItemDao {
  @Query('SELECT * FROM transaction_items ORDER BY id DESC')
  Future<List<TransactionItemModel>> getAllTransactionItems();

  @Query('SELECT * FROM transaction_items WHERE id = :id')
  Future<TransactionItemModel?> getTransactionItemById(int id);

  @Query('SELECT * FROM transaction_items WHERE transaction_id = :transactionId')
  Future<List<TransactionItemModel>> getItemsByTransactionId(int transactionId);

  @Query('SELECT * FROM transaction_items WHERE product_id = :productId')
  Future<List<TransactionItemModel>> getItemsByProductId(int productId);

  @insert
  Future<int> insertTransactionItem(TransactionItemModel item);

  @insert
  Future<void> insertTransactionItems(List<TransactionItemModel> items);

  @update
  Future<void> updateTransactionItem(TransactionItemModel item);

  @delete
  Future<void> deleteTransactionItem(TransactionItemModel item);

  @Query('DELETE FROM transaction_items WHERE transaction_id = :transactionId')
  Future<void> deleteItemsByTransactionId(int transactionId);

  // Statistics
  @Query('SELECT SUM(quantity) FROM transaction_items')
  Future<int?> getTotalItemsSold();

  @Query('SELECT SUM(subtotal) FROM transaction_items')
  Future<double?> getTotalSubtotal();
}
