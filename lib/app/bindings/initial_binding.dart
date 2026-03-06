import 'package:get/get.dart';
import 'package:my_kasir/modules/cart/cart_controller.dart';
import '../../core/services/database_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<DatabaseService>(() async => DatabaseService().init());
    Get.lazyPut<CartController>(() => CartController());
  }
}
