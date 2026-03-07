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
          color: Colors.white,
          elevation: 4,
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'edit',
              onTap: () => Future.delayed(
                Duration.zero,
                () => _showAddEditDialog(context, ctrl, category: category),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primaryDark),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              onTap: () => Future.delayed(
                Duration.zero,
                () => _showDeleteDialog(category, ctrl),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.badgeRed.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_outline, size: 18, color: AppColors.badgeRed),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Hapus',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.badgeRed,
                    ),
                  ),
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

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          category == null ? Icons.add_circle_outline : Icons.edit_outlined,
                          color: AppColors.primaryDark,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          category == null ? "Tambah Kategori" : "Edit Kategori",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.close, size: 18, color: Colors.grey[600]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Form Field
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8F9FA),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: TextField(
                      controller: nameCtrl,
                      autofocus: true,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Nama Kategori",
                        labelStyle: TextStyle(color: Colors.grey, fontSize: 14),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Status Toggle
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primaryDark.withValues(alpha: 0.08)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isActive ? AppColors.primaryDark.withValues(alpha: 0.3) : Colors.grey[300]!,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isActive ? Icons.check_circle_outline : Icons.cancel_outlined,
                          color: isActive ? AppColors.primaryDark : Colors.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Status Aktif",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark,
                                ),
                              ),
                              Text(
                                isActive ? "Kategori akan ditampilkan" : "Kategori disembunyikan",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isActive ? AppColors.primaryDark : Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: isActive,
                          activeTrackColor: AppColors.primaryDark.withValues(alpha: 0.5),
                          activeThumbColor: AppColors.primaryDark,
                          onChanged: (v) => setState(() => isActive = v),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            "Batal",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (nameCtrl.text.trim().isNotEmpty) {
                              await ctrl.saveCategory(nameCtrl.text.trim(), isActive, category);
                              if (context.mounted) {
                                Navigator.pop(context);
                              }
                            } else {
                              Get.snackbar(
                                "Error",
                                "Nama kategori tidak boleh kosong",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                                snackPosition: SnackPosition.BOTTOM,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            "Simpan",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void _showDeleteDialog(CategoryModel category, CategoryController ctrl) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Builder(
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon warning
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.badgeRed.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.delete_outline, color: AppColors.badgeRed, size: 32),
                  ),
                  const SizedBox(height: 16),

                  // Title
                  const Text(
                    "Hapus Kategori?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Message
                  Text(
                    "Kategori '${category.name}' akan dipindahkan ke tempat sampah.",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            "Batal",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await ctrl.deleteCategory(category.id!);
                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.badgeRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Hapus",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
      barrierDismissible: true,
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
