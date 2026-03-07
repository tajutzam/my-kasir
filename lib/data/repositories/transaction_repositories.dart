import 'package:my_kasir/data/database/app_database.dart';
import 'package:my_kasir/data/models/transaction_model.dart';
import 'package:my_kasir/data/models/transaction_item_model.dart';

class TransactionRepository {
  final AppDatabase db;

  TransactionRepository(this.db);

  Future<List<TransactionModel>> getAll() =>
      db.transactionDao.getAllTransactions();

  Future<int> createTransaction(
    TransactionModel transaction,
    List<TransactionItemModel> items,
  ) async {
    final transactionId = await db.transactionDao.insertTransaction(
      transaction,
    );

    for (var item in items) {
      final itemWithId = item.copyWith(transactionId: transactionId);
      await db.transactionItemDao.insertTransactionItem(itemWithId);

      if (item.productId != null) {
        final product = await db.productDao.getProductById(item.productId!);
        if (product != null) {
          final updatedProduct = product.copyWith(
            stock: product.stock - item.quantity,
          );
          await db.productDao.updateProduct(updatedProduct);
        }
      }
    }
    return transactionId;
  }
}
