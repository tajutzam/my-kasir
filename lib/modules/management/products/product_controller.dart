import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/services/database_service.dart';
import 'package:my_kasir/core/theme/app_colors.dart';
import 'package:my_kasir/data/models/product_model.dart';
import 'package:my_kasir/data/models/category_model.dart';
import 'package:my_kasir/data/repositories/category_repositories.dart';
import 'package:my_kasir/data/repositories/product_repositories.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class ProductController extends GetxController {
  late final ProductRepository _productRepo;
  late final CategoryRepository _categoryRepo;

  var products = <ProductModel>[].obs;
  var allProducts = <ProductModel>[].obs; // Store all products for filtering
  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs;
  var selectedCategoryId = 0.obs; // 0 means all categories
  var selectedImagePath = ''.obs;

  // Getter untuk filtered products
  List<ProductModel> get filteredProducts {
    List<ProductModel> result = allProducts;

    // Filter by category
    if (selectedCategoryId.value != 0) {
      result = result.where((p) => p.categoryId == selectedCategoryId.value).toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      result = result.where((p) =>
        p.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        (p.sku != null && p.sku!.toLowerCase().contains(searchQuery.value.toLowerCase()))
      ).toList();
    }

    return result;
  }

  Future<void> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: source,
      imageQuality: 30,
    );

    if (image != null) {
      selectedImagePath.value = image.path;
    }
  }

  Future<String?> _saveImageLocally(String tempPath) async {
    if (tempPath.isEmpty) return null;
    if (tempPath.contains('app_flutter')) return tempPath; // Sudah disimpan

    final directory = await getApplicationDocumentsDirectory();
    final fileName =
        'img_${DateTime.now().millisecondsSinceEpoch}${path.extension(tempPath)}';
    final savedPath = path.join(directory.path, fileName);

    await File(tempPath).copy(savedPath);
    return savedPath;
  }

  @override
  void onInit() {
    super.onInit();
    final db = Get.find<DatabaseService>().database;
    _productRepo = ProductRepository(db);
    _categoryRepo = CategoryRepository(db);
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    try {
      final results = await Future.wait([
        _productRepo.getAll(),
        _categoryRepo.getAll(),
      ]);
      allProducts.assignAll(results[0] as List<ProductModel>);
      products.assignAll(filteredProducts); // Update with filtered results
      categories.assignAll(results[1] as List<CategoryModel>);
    } finally {
      isLoading.value = false;
    }
  }

  void updateCategory(int categoryId) {
    selectedCategoryId.value = categoryId;
    products.assignAll(filteredProducts);
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    products.assignAll(filteredProducts);
  }

  Future<void> saveProduct(ProductModel product, {bool isEdit = false}) async {
    try {
      isLoading.value = true;

      String? finalPath;
      if (selectedImagePath.value.isNotEmpty) {
        finalPath = await _saveImageLocally(selectedImagePath.value);
      }

      final updatedProduct = product.copyWith(imagePath: finalPath);

      if (isEdit) {
        await _productRepo.update(updatedProduct);
      } else {
        await _productRepo.insert(updatedProduct);
      }
      await loadInitialData();
      selectedImagePath.value = '';
      _showSnackbar(
        "Sukses",
        "Produk berhasil disimpan",
        AppColors.primaryDark,
      );
    } catch (e) {
      _showSnackbar("Error", "Gagal menyimpan produk", AppColors.badgeRed);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> softDelete(int id) async {
    await _productRepo.db.productDao.softDeleteProduct(
      id,
      DateTime.now().millisecondsSinceEpoch,
    );
    await loadInitialData();
  }

  String getCategoryName(int id) {
    return categories
        .firstWhere(
          (c) => c.id == id,
          orElse: () => CategoryModel(name: 'N/A', createdAt: DateTime.now()),
        )
        .name;
  }

  void _showSnackbar(String title, String msg, Color color) {
    Get.snackbar(
      title,
      msg,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: Colors.white,
      margin: const EdgeInsets.all(15),
    );
  }
}
