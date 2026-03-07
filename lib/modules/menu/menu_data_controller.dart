import 'package:get/get.dart';
import 'package:my_kasir/core/services/database_service.dart';
import 'package:my_kasir/data/repositories/category_repositories.dart';
import 'package:my_kasir/data/repositories/product_repositories.dart';
import 'package:my_kasir/data/models/category_model.dart';
import 'package:my_kasir/data/models/product_model.dart';

class MenuDataController extends GetxController {
  late final ProductRepository _productRepo;
  late final CategoryRepository _categoryRepo;

  // Products grouped by category name
  final productsByCategory = <String, List<ProductModel>>{}.obs;

  // Categories for display
  final categories = <CategoryModel>[].obs;

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    final db = Get.find<DatabaseService>().database;
    _productRepo = ProductRepository(db);
    _categoryRepo = CategoryRepository(db);
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;

    try {
      // Load all active categories
      final cats = await _categoryRepo.getAll();
      categories.assignAll(cats);

      // Load all products
      final prods = await _productRepo.getAll();

      // Group products by category
      final grouped = <String, List<ProductModel>>{};

      for (var category in cats) {
        final categoryProducts = prods
            .where((p) => p.categoryId == category.id)
            .toList();
        grouped[category.name] = categoryProducts;
      }

      productsByCategory.assignAll(grouped);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void refresh() {
    loadData();
  }
}
