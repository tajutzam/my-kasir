import 'package:get/get.dart';
import 'package:my_kasir/core/services/database_service.dart';
import 'package:my_kasir/data/repositories/product_repositories.dart';
import 'package:my_kasir/data/models/product_model.dart';

class OffersController extends GetxController {
  late final ProductRepository _productRepo;

  final discountedProducts = <ProductModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final db = Get.find<DatabaseService>().database;
    _productRepo = ProductRepository(db);
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      discountedProducts.value = await _productRepo.getDiscountedProducts();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void refresh() {
    loadData();
  }
}
