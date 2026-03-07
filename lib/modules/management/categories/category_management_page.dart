import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/theme/app_colors.dart';
import 'package:my_kasir/core/utils/app_utils.dart';
import 'package:my_kasir/data/models/category_model.dart';
import 'package:my_kasir/widgets/custom_app_bar.dart';
import 'category_controller.dart';

class CategoryManagementPage extends StatelessWidget {
  const CategoryManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller
    final ctrl = Get.put(CategoryController());
    final searchController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFC),
      appBar: CustomAppBar(
        title: 'CATEGORY MANAGER',
        showBackButton: true,
        actions: [
          IconButton(
            onPressed: () => _showAddEditDialog(context, ctrl),
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: Column(
        children: [
          // Bagian Header Biru (Statistik & Search)
          _buildTopSection(ctrl, searchController),

          // List Kategori
          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final list = ctrl.filteredCategories;

              if (list.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _buildCategoryCard(context, list[index], ctrl);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection(
    CategoryController ctrl,
    TextEditingController searchCtrl,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Obx(
            () => Text(
              'Total ${ctrl.categories.length} Kategori Terdaftar',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: searchCtrl,
            onChanged: (v) => ctrl.searchQuery.value = v,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Cari kategori...',
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: Colors.white.withOpacity(0.12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    CategoryModel category,
    CategoryController ctrl,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: category.isActiveBool
                ? AppColors.primaryDark.withOpacity(0.1)
                : Colors.grey[200],
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              category.name.isNotEmpty ? category.name[0].toUpperCase() : '?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: category.isActiveBool
                    ? AppColors.primaryDark
                    : Colors.grey,
              ),
            ),
          ),
        ),
        title: Text(
          category.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            'Update: ${AppUtils.formatDate(category.updatedAt)}',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
        trailing: PopupMenuButton(
          icon: const Icon(Icons.more_vert, color: Colors.grey),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () => Future.delayed(
                Duration.zero,
                () => _showAddEditDialog(context, ctrl, category: category),
              ),
              child: const Row(
                children: [
                  Icon(Icons.edit_outlined, size: 20),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () => Future.delayed(
                Duration.zero,
                () => _showDeleteDialog(category, ctrl),
              ),
              child: const Row(
                children: [
                  Icon(Icons.delete_outline, size: 20, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Hapus', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddEditDialog(
    BuildContext context,
    CategoryController ctrl, {
    CategoryModel? category,
  }) {
    final nameCtrl = TextEditingController(text: category?.name ?? '');
    bool isActive = category?.isActiveBool ?? true;

    Get.defaultDialog(
      title: category == null ? "Tambah Kategori" : "Edit Kategori",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      content: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              TextField(
                controller: nameCtrl,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Nama Kategori",
                  prefixIcon: Icon(Icons.label_important_outline),
                ),
              ),
              const SizedBox(height: 10),
              SwitchListTile(
                title: const Text(
                  "Status Aktif",
                  style: TextStyle(fontSize: 14),
                ),
                value: isActive,
                activeColor: AppColors.primaryDark,
                contentPadding: EdgeInsets.zero,
                onChanged: (v) => setState(() => isActive = v),
              ),
            ],
          );
        },
      ),
      textConfirm: "Simpan",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.grey, // Sesuai instruksi: Tombol abu-abu
      onConfirm: () {
        if (nameCtrl.text.trim().isNotEmpty) {
          ctrl.saveCategory(nameCtrl.text.trim(), isActive, category);
        } else {
          Get.snackbar(
            "Error",
            "Nama kategori tidak boleh kosong",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      },
    );
  }

  void _showDeleteDialog(CategoryModel category, CategoryController ctrl) {
    Get.defaultDialog(
      title: "Hapus Kategori?",
      middleText:
          "Kategori '${category.name}' akan dipindahkan ke tempat sampah.",
      textConfirm: "Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.badgeRed,
      onConfirm: () {
        ctrl.deleteCategory(category.id!);
        Get.back();
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.category_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'Kategori tidak ditemukan',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
