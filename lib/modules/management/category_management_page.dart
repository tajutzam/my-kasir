import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/services/database_service.dart';
import 'package:my_kasir/core/theme/app_colors.dart';
import 'package:my_kasir/core/utils/app_utils.dart';
import 'package:my_kasir/data/models/category_model.dart';

class CategoryManagementPage extends StatefulWidget {
  const CategoryManagementPage({super.key});

  @override
  State<CategoryManagementPage> createState() => _CategoryManagementPageState();
}

class _CategoryManagementPageState extends State<CategoryManagementPage> {
  final DatabaseService dbService = Get.find<DatabaseService>();
  final searchController = TextEditingController();
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    try {
      final data = await dbService.database.categoryDao.getAllCategories();
      categories.value = data;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load categories',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.badgeRed,
        colorText: AppColors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<CategoryModel> get filteredCategories {
    if (searchQuery.value.isEmpty) {
      return categories;
    }
    return categories
        .where((cat) =>
            cat.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
        .toList();
  }

  Future<void> showAddEditDialog({CategoryModel? category}) async {
    final nameController = TextEditingController(text: category?.name ?? '');
    final isActive = category?.isActiveBool ?? true;

    final result = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                category == null ? 'Add Category' : 'Edit Category',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  prefixIcon: const Icon(Icons.label_outline),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: AppColors.scaffold,
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: AppColors.textGrey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (nameController.text.trim().isEmpty) {
                          Get.snackbar(
                            'Validation',
                            'Please enter a category name',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: AppColors.textDark,
                            colorText: AppColors.white,
                          );
                          return;
                        }
                        Get.back(result: true);
                        await saveCategory(
                          nameController.text.trim(),
                          isActive,
                          category,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );

    if (result != true) {
      nameController.dispose();
    }
  }

  Future<void> saveCategory(
    String name,
    bool isActive,
    CategoryModel? existingCategory,
  ) async {
    try {
      final now = DateTime.now();
      if (existingCategory == null) {
        // Add new
        final newCategory = CategoryModel(
          name: name,
          isActive: isActive ? 1 : 0,
          createdAt: now,
          updatedAt: now,
        );
        await dbService.database.categoryDao.insertCategory(newCategory);
        Get.snackbar(
          'Success',
          'Category added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primaryDark,
          colorText: AppColors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        // Update existing
        final updatedCategory = existingCategory.copyWith(
          name: name,
          isActive: isActive ? 1 : 0,
          updatedAt: now,
        );
        await dbService.database.categoryDao.updateCategory(updatedCategory);
        Get.snackbar(
          'Success',
          'Category updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.primaryDark,
          colorText: AppColors.white,
          duration: const Duration(seconds: 2),
        );
      }
      await loadCategories();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save category',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.badgeRed,
        colorText: AppColors.white,
      );
    }
  }

  Future<void> showDeleteDialog(CategoryModel category) async {
    await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.badgeRed.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: AppColors.badgeRed,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Delete Category?',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Are you sure you want to delete "${category.name}"? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textGrey,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: AppColors.textGrey.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: AppColors.textGrey),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Get.back(result: true);
                        await deleteCategory(category);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.badgeRed,
                        foregroundColor: AppColors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> deleteCategory(CategoryModel category) async {
    try {
      await dbService.database.categoryDao.softDeleteCategory(
        category.id!,
        DateTime.now().millisecondsSinceEpoch,
      );
      await loadCategories();
      Get.snackbar(
        'Deleted',
        'Category deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.textDark,
        colorText: AppColors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete category',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.badgeRed,
        colorText: AppColors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom App Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: AppColors.white,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    color: AppColors.textDark,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                        Obx(() => Text(
                              '${categories.length} categories',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textGrey,
                              ),
                            )),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => showAddEditDialog(),
                    icon: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primaryDark,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: TextField(
                controller: searchController,
                onChanged: (value) => searchQuery.value = value,
                decoration: InputDecoration(
                  hintText: 'Search categories...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            searchController.clear();
                            searchQuery.value = '';
                          },
                          icon: const Icon(Icons.clear_rounded),
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: AppColors.scaffold,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
            ),

            // Categories List
            Expanded(
              child: Obx(() {
                if (isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final filtered = filteredCategories;

                if (filtered.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          searchQuery.value.isEmpty
                              ? Icons.category_outlined
                              : Icons.search_off_rounded,
                          size: 64,
                          color: AppColors.textGrey.withValues(alpha: 0.5),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          searchQuery.value.isEmpty
                              ? 'No categories yet'
                              : 'No categories found',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textGrey,
                          ),
                        ),
                        if (searchQuery.value.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextButton(
                              onPressed: () => showAddEditDialog(),
                              child: Text(
                                'Add your first category',
                                style: TextStyle(
                                  color: AppColors.primaryDark,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final category = filtered[index];
                    return _buildCategoryCard(category);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(CategoryModel category) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDark.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryDark.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              category.name[0].toUpperCase(),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ),
        title: Text(
          category.name,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  category.isActiveBool
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  size: 13,
                  color: category.isActiveBool
                      ? AppColors.primaryDark
                      : AppColors.textGrey,
                ),
                const SizedBox(width: 3),
                Text(
                  category.isActiveBool ? 'Active' : 'Inactive',
                  style: TextStyle(
                    fontSize: 11,
                    color: category.isActiveBool
                        ? AppColors.primaryDark
                        : AppColors.textGrey,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 13,
                  color: AppColors.textGrey,
                ),
                const SizedBox(width: 3),
                Text(
                  AppUtils.formatDate(category.createdAt),
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => showAddEditDialog(category: category),
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryMedium.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.edit_outlined,
                  size: 16,
                  color: AppColors.primaryMedium,
                ),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 4),
            IconButton(
              onPressed: () => showDeleteDialog(category),
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.badgeRed.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline_rounded,
                  size: 16,
                  color: AppColors.badgeRed,
                ),
              ),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
