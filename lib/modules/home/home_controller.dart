import 'package:get/get.dart';
import 'package:my_kasir/core/services/database_service.dart';
import 'package:my_kasir/data/models/category_model.dart';
import 'package:my_kasir/data/models/product_model.dart';
import 'package:my_kasir/data/repositories/category_repositories.dart';
import 'package:my_kasir/data/repositories/product_repositories.dart';

class HomeController extends GetxController {
  late final ProductRepository _productRepo;
  late final CategoryRepository _categoryRepo;

  // Categories for display
  var categories = <CategoryModel>[].obs;

  // Observables
  var allProducts = <ProductModel>[].obs;
  var filteredProducts = <ProductModel>[].obs;
  var isLoading = true.obs;
  var searchQuery = "".obs;
  var selectedCategoryId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final db = Get.find<DatabaseService>().database;
    _productRepo = ProductRepository(db);
    _categoryRepo = CategoryRepository(db);
    refreshData();
  }

  Future<void> refreshData() async {
    isLoading(true);
    await fetchCategories();
    await fetchProducts();
    isLoading(false);
  }

  Future<void> fetchCategories() async {
    try {
      isLoading(true);
      final categoriesResponse = await _categoryRepo.getAll();
      categories.assignAll(categoriesResponse);
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);
      final products = await _productRepo.getAll();
      allProducts.assignAll(products);
      _applyFilter();
    } finally {
      isLoading(false);
    }
  }

  void updateCategory(int id) {
    selectedCategoryId.value = id;
    selectedCategoryId.refresh();
    _applyFilter();
  }

  void updateSearch(String query) {
    searchQuery.value = query;
    _applyFilter();
  }

  void _applyFilter() {
    // PENTING: Ambil nilai .value ke variabel lokal SEBELUM masuk ke fungsi .where
    // Ini memastikan Obx tahu bahwa fungsi ini bergantung pada kedua variabel ini
    final currentSearch = searchQuery.value.toLowerCase();
    final currentCatId = selectedCategoryId.value;

    var result = allProducts.where((product) {
      // Gunakan variabel lokal di sini
      bool matchesSearch =
          product.name.toLowerCase().contains(currentSearch) ||
          (product.sku?.toLowerCase().contains(currentSearch) ?? false);

      bool matchesCategory =
          currentCatId == 0 || product.categoryId == currentCatId;

      return matchesSearch && matchesCategory;
    }).toList();

    filteredProducts.assignAll(result);
  }

  @override
  void refresh() {
    refreshData();
  }
}
