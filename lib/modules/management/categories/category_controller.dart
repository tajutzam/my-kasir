import 'package:get/get.dart';
import 'package:my_kasir/core/services/database_service.dart';
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
    final now = DateTime.now();
    if (existing == null) {
      await _categoryRepo.insert(
        CategoryModel(
          name: name,
          isActive: isActive ? 1 : 0,
          createdAt: now,
          updatedAt: now,
        ),
      );
    } else {
      await _categoryRepo.update(
        existing.copyWith(
          name: name,
          isActive: isActive ? 1 : 0,
          updatedAt: now,
        ),
      );
    }
    Get.back(); 
    loadCategories();
  }

  Future<void> deleteCategory(int id) async {
    await _categoryRepo.softDelete(id);
    loadCategories();
  }
}
