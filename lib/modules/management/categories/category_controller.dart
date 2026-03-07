import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/services/database_service.dart';
import 'package:my_kasir/core/theme/app_colors.dart';
import 'package:my_kasir/data/models/category_model.dart';
import 'package:my_kasir/data/repositories/category_repositories.dart';

class CategoryController extends GetxController {
  late final CategoryRepository _categoryRepo;

  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;
  var searchQuery = ''.obs; // Tambahkan state pencarian

  @override
  void onInit() {
    super.onInit();
    _categoryRepo = CategoryRepository(Get.find<DatabaseService>().database);
    loadCategories();
  }

  // Getter untuk list yang sudah difilter berdasarkan pencarian
  List<CategoryModel> get filteredCategories {
    if (searchQuery.value.isEmpty) return categories;
    return categories
        .where(
          (cat) =>
              cat.name.toLowerCase().contains(searchQuery.value.toLowerCase()),
        )
        .toList();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    try {
      final result = await _categoryRepo.getAll();
      categories.assignAll(result);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveCategory(
    String name,
    bool isActive,
    CategoryModel? existing,
  ) async {
    try {
      // Cek duplikat nama kategori (case-insensitive)
      final trimmedName = name.trim().toLowerCase();
      final isDuplicate = categories.any((cat) {
        // Saat edit, exclude kategori yang sedang diedit dari pengecekan
        if (existing != null && cat.id == existing.id) return false;
        return cat.name.toLowerCase() == trimmedName;
      });

      if (isDuplicate) {
        _showSnackbar(
          "Duplikat",
          "Kategori '$name' sudah ada",
          AppColors.badgeRed,
        );
        return;
      }

      final now = DateTime.now();
      if (existing == null) {
        await _categoryRepo.insert(
          CategoryModel(
            name: name.trim(),
            isActive: isActive ? 1 : 0,
            createdAt: now,
            updatedAt: now,
          ),
        );
        _showSnackbar(
          "Sukses",
          "Kategori '$name' berhasil ditambahkan",
          AppColors.primaryDark,
        );
      } else {
        await _categoryRepo.update(
          existing.copyWith(
            name: name.trim(),
            isActive: isActive ? 1 : 0,
            updatedAt: now,
          ),
        );
        _showSnackbar(
          "Sukses",
          "Kategori '$name' berhasil diperbarui",
          AppColors.primaryDark,
        );
      }
      await loadCategories();
    } catch (e) {
      _showSnackbar("Error", "Gagal menyimpan kategori", AppColors.badgeRed);
    }
  }

  Future<void> deleteCategory(int id) async {
    try {
      await _categoryRepo.softDelete(id);
      await loadCategories();
      _showSnackbar(
        "Sukses",
        "Kategori berhasil dihapus",
        AppColors.primaryDark,
      );
    } catch (e) {
      _showSnackbar("Error", "Gagal menghapus kategori", AppColors.badgeRed);
    }
  }

  void _showSnackbar(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: Colors.white,
      margin: const EdgeInsets.all(15),
    );
  }
}
