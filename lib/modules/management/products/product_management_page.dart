import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_kasir/core/theme/app_colors.dart';
import 'package:my_kasir/data/models/product_model.dart';
import 'package:my_kasir/widgets/custom_app_bar.dart';
import 'product_controller.dart';

class ProductManagementPage extends StatelessWidget {
  const ProductManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(ProductController());
    final searchCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: CustomAppBar(
        title: 'PRODUCTS',
        actions: [
          IconButton(
            onPressed: () => _showFormProduct(context, ctrl),
            icon: const Icon(Icons.add_box_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Section
          _buildSearchHeader(ctrl, searchCtrl),

          // Category Filter
          _buildCategoryFilter(ctrl),

          // List Produk
          Expanded(
            child: Obx(() {
              if (ctrl.isLoading.value)
                return const Center(child: CircularProgressIndicator());
              if (ctrl.products.isEmpty) return _buildEmptyState();

              return ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: ctrl.products.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final product = ctrl.products[index];
                  return _buildProductItem(context, product, ctrl);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchHeader(
    ProductController ctrl,
    TextEditingController searchCtrl,
  ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: TextField(
        controller: searchCtrl,
        onChanged: (v) => ctrl.searchProducts(v),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Cari SKU atau Nama...',
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search, color: Colors.white54),
          filled: true,
          fillColor: Colors.white.withOpacity(0.15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }

  Widget _buildCategoryFilter(ProductController ctrl) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(() {
        final selectedId = ctrl.selectedCategoryId.value;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: ctrl.categories.length + 1,
          itemBuilder: (context, index) {
            final isAll = index == 0;
            final int categoryId = isAll
                ? 0
                : (ctrl.categories[index - 1].id ?? 0);
            final String categoryName = isAll
                ? "Semua"
                : ctrl.categories[index - 1].name;

            final bool isSelected = selectedId == categoryId;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                checkmarkColor: Colors.white,
                key: ValueKey('cat_$categoryId'),
                label: Text(categoryName),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) ctrl.updateCategory(categoryId);
                },
                selectedColor: AppColors.primaryMedium,
                backgroundColor: Colors.grey[300],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primaryMedium
                        : Colors.transparent,
                  ),
                ),
                elevation: 0,
                pressElevation: 0,
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildProductItem(
    BuildContext context,
    ProductModel product,
    ProductController ctrl,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildLeadingIcon(product),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  ctrl.getCategoryName(product.categoryId),
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                if (product.sku != null && product.sku!.isNotEmpty)
                  Text(
                    "SKU: ${product.sku}",
                    style: const TextStyle(
                      color: AppColors.primaryDark,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "Rp ${product.finalPrice.toInt()}",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(width: 10),
                    _buildStockBadge(product.stock),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton(
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
                  () => _showFormProduct(context, ctrl, product: product),
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
                  () => _showConfirmDelete(product, ctrl),
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
        ],
      ),
    );
  }

  Widget _buildLeadingIcon(ProductModel product) {
    return Container(
      width: 55,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        image: product.imagePath != null && product.imagePath!.isNotEmpty
            ? DecorationImage(
                image: FileImage(File(product.imagePath!)),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: product.imagePath == null || product.imagePath!.isEmpty
          ? Icon(
              Icons.inventory_2_outlined,
              color: AppColors.primaryDark.withOpacity(0.5),
            )
          : null,
    );
  }

  Widget _buildStockBadge(int stock) {
    final color = stock < 5 ? Colors.red : Colors.green;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "Stok: $stock",
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showFormProduct(
    BuildContext context,
    ProductController ctrl, {
    ProductModel? product,
  }) {
    // Set awal jika edit
    ctrl.selectedImagePath.value = product?.imagePath ?? '';

    final nameCtrl = TextEditingController(text: product?.name ?? '');
    final skuCtrl = TextEditingController(text: product?.sku ?? '');
    final priceCtrl = TextEditingController(
      text: product?.originalPrice.toString() ?? '',
    );
    final stockCtrl = TextEditingController(
      text: product?.stock.toString() ?? '0',
    );
    int? selectedId = product?.categoryId;

    void generateSKU() {
      final timestamp = DateTime.now().millisecondsSinceEpoch
          .toString()
          .substring(7);
      final randomStr = (nameCtrl.text.length >= 2)
          ? nameCtrl.text.substring(0, 2).toUpperCase()
          : "PRD";
      skuCtrl.text = "$randomStr-$timestamp";
    }

    Get.bottomSheet(
      isScrollControlled: true,
      Builder(
        builder: (sheetContext) => Container(
          padding: const EdgeInsets.all(24),
          constraints: BoxConstraints(maxHeight: Get.height * 0.85),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                product == null ? "TAMBAH PRODUK" : "EDIT PRODUK",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 20),

              // SEKSI PICK IMAGE
              GestureDetector(
                onTap: () => _showImagePickerSource(ctrl),
                child: Obx(
                  () => Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[300]!),
                      image: ctrl.selectedImagePath.value.isNotEmpty
                          ? DecorationImage(
                              image: FileImage(
                                File(ctrl.selectedImagePath.value),
                              ),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: ctrl.selectedImagePath.value.isEmpty
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo_outlined,
                                color: Colors.grey,
                              ),
                              Text(
                                "Foto",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Obx(
                () => DropdownButtonFormField<int>(
                  value: selectedId,
                  items: ctrl.categories
                      .map(
                        (c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(
                            c.name,
                            style: const TextStyle(
                              color: AppColors.textDark,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => selectedId = v,
                  decoration: InputDecoration(
                    labelText: "Pilih Kategori",
                    labelStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                  icon: const Icon(Icons.arrow_drop_down, color: AppColors.primaryDark),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  style: const TextStyle(color: AppColors.textDark),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: "Nama Produk",
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: skuCtrl,
                decoration: InputDecoration(
                  labelText: "SKU / Barcode",
                  labelStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  suffixIcon: IconButton(
                    onPressed: generateSKU,
                    icon: const Icon(
                      Icons.auto_awesome_rounded,
                      color: AppColors.primaryDark,
                    ),
                    tooltip: "Generate Otomatis",
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Harga Jual",
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: stockCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Stok",
                        labelStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () async {
                    if (selectedId == null || nameCtrl.text.isEmpty) return;
                    final m =
                        (product ??
                                ProductModel(
                                  categoryId: selectedId!,
                                  name: nameCtrl.text,
                                  originalPrice:
                                      double.tryParse(priceCtrl.text) ?? 0,
                                ))
                            .copyWith(
                              categoryId: selectedId,
                              name: nameCtrl.text,
                              sku: skuCtrl.text,
                              originalPrice:
                                  double.tryParse(priceCtrl.text) ?? 0,
                              stock: int.tryParse(stockCtrl.text) ?? 0,
                              // imagePath akan dihandle di controller
                            );
                    await ctrl.saveProduct(m, isEdit: product != null);
                    if (sheetContext.mounted) {
                      Navigator.pop(sheetContext);
                    }
                  },
                  child: const Text(
                    "SIMPAN",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40), // Spasi ekstra untuk keyboard
            ],
          ),
        ),
        ),
      ),
    );
  }

  void _showImagePickerSource(ProductController ctrl) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Kamera"),
              onTap: () {
                Get.back();
                ctrl.pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Galeri"),
              onTap: () {
                Get.back();
                ctrl.pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmDelete(ProductModel product, ProductController ctrl) {
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
                "Hapus Produk?",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),

              // Message
              Text(
                "Yakin ingin menghapus ${product.name}?",
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
                        await ctrl.softDelete(product.id!);
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
          Icon(Icons.inventory_2_outlined, size: 70, color: Colors.grey[300]),
          const SizedBox(height: 10),
          const Text("Belum ada produk.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
