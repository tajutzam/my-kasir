import 'package:floor/floor.dart';
import '../models/transaction_model.dart';

@dao
abstract class TransactionDao {
  @Query('SELECT * FROM transaction ORDER BY date DESC')
  Future<List<TransactionModel>> getAllTransactions();

  @Query('SELECT * FROM transaction WHERE id = :id')
  Future<TransactionModel?> getTransactionById(int id);

  @Query('SELECT * FROM transaction WHERE invoice_number = :invoiceNumber LIMIT 1')
  Future<TransactionModel?> getTransactionByInvoiceNumber(String invoiceNumber);

  @Query('SELECT * FROM transaction WHERE date >= :startMillis AND date <= :endMillis ORDER BY date DESC')
  Future<List<TransactionModel>> getTransactionsByDateRange(int startMillis, int endMillis);

  @Query('SELECT * FROM transaction WHERE status = :status ORDER BY date DESC')
  Future<List<TransactionModel>> getTransactionsByStatus(String status);

  @Query('SELECT * FROM transaction WHERE cashier_name = :cashierName ORDER BY date DESC')
  Future<List<TransactionModel>> getTransactionsByCashier(String cashierName);

  @Query('SELECT * FROM transaction ORDER BY date DESC LIMIT :limit')
  Future<List<TransactionModel>> getRecentTransactions(int limit);

  // Statistics
  @Query('SELECT SUM(total_amount) FROM transaction WHERE status = "completed"')
  Future<double?> getTotalRevenue();

  @Query('SELECT SUM(total_amount) FROM transaction WHERE status = "completed" AND date >= :startMillis AND date <= :endMillis')
  Future<double?> getRevenueByDateRange(int startMillis, int endMillis);

  @Query('SELECT COUNT(*) FROM transaction WHERE status = "completed"')
  Future<int?> getTotalTransactions();

  @insert
  Future<int> insertTransaction(TransactionModel transaction);

  @update
  Future<void> updateTransaction(TransactionModel transaction);

  @delete
  Future<void> deleteTransaction(TransactionModel transaction);
}
