import 'package:get/get.dart';
import 'package:my_kasir/data/repositories/transaction_repositories.dart';
import 'package:my_kasir/modules/cart/cart_controller.dart';
import 'package:my_kasir/core/services/database_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    final dbService = Get.find<DatabaseService>();
    final db = dbService.database;

    // Inject Repository
    final transactionRepo = TransactionRepository(db);

    // Inject CartController secara permanen/fenix agar tidak hilang saat navigasi
    Get.lazyPut<CartController>(
      () => CartController(transactionRepo),
      fenix: true,
    );
  }
}
