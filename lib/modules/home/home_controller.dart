import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/services/database_service.dart';
import 'package:my_kasir/data/repositories/category_repositories.dart';
import 'package:my_kasir/data/repositories/product_repositories.dart';
import 'package:my_kasir/data/models/product_model.dart';

class HomeController extends GetxController {
  late final ProductRepository _productRepo;
  late final CategoryRepository _categoryRepo;

  // All data from database
  final products = <ProductModel>[].obs;
  final categories = <Map<String, dynamic>>[].obs;

  // Filtered data for display
  final filteredProducts = <ProductModel>[].obs;

  // Search
  final searchQuery = ''.obs;
  final selectedCategoryId = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final db = Get.find<DatabaseService>().database;
    _productRepo = ProductRepository(db);
    _categoryRepo = CategoryRepository(db);
    loadData();
  }

  Future<void> loadData() async {
    // Load products
    products.value = await _productRepo.getAll();
    filteredProducts.assignAll(products);

    // Load categories and add "All" at the beginning
    final dbCategories = await _categoryRepo.getAll();

    final allCategories = <Map<String, dynamic>>[
      {'id': 0, 'name': 'All', 'icon': Icons.apps},
      ...dbCategories.map((c) => {
        'id': c.id,
        'name': c.name,
        'icon': Icons.category,
      }),
    ];

    categories.assignAll(allCategories);
  }

  void filterByCategory(int categoryId) {
    selectedCategoryId.value = categoryId;

    if (categoryId == 0) {
      // Show all products
      filteredProducts.assignAll(products);
    } else {
      // Filter by category
      filteredProducts.assignAll(
        products.where((p) => p.categoryId == categoryId),
      );
    }

    // Apply search filter if there's a search query
    if (searchQuery.value.isNotEmpty) {
      searchProducts(searchQuery.value);
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;

    if (query.isEmpty) {
      // Just apply category filter
      filterByCategory(selectedCategoryId.value);
      return;
    }

    final searchLower = query.toLowerCase();

    // First filter by category if needed
    var baseList = selectedCategoryId.value == 0
        ? products
        : products.where((p) => p.categoryId == selectedCategoryId.value);

    // Then filter by search query
    filteredProducts.assignAll(
      baseList.where((p) =>
        p.name.toLowerCase().contains(searchLower) ||
        (p.sku?.toLowerCase().contains(searchLower) ?? false)),
    );
  }

  @override
  void refresh() {
    loadData();
  }
}
