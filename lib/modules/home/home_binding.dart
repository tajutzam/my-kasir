import 'package:get/get.dart';
import 'package:my_kasir/core/services/database_service.dart';
import 'package:my_kasir/data/repositories/category_repositories.dart';
import 'package:my_kasir/data/repositories/product_repositories.dart';
import 'package:my_kasir/modules/home/home_controller.dart';
import 'package:my_kasir/modules/main/main_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    final db = Get.find<DatabaseService>().database;

    var productRepo = ProductRepository(db);
    var categoryRepo = CategoryRepository(db);

    Get.lazyPut<HomeController>(
      () => HomeController(productRepo, categoryRepo),
    );
  }
}
