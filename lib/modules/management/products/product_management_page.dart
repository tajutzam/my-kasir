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
          IconButton(
            onPressed: () => _showProductOptions(context, product, ctrl),
            icon: const Icon(Icons.more_horiz),
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
      Container(
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
                        (c) =>
                            DropdownMenuItem(value: c.id, child: Text(c.name)),
                      )
                      .toList(),
                  onChanged: (v) => selectedId = v,
                  decoration: const InputDecoration(
                    labelText: "Pilih Kategori",
                  ),
                ),
              ),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Nama Produk"),
              ),
              TextField(
                controller: skuCtrl,
                decoration: InputDecoration(
                  labelText: "SKU / Barcode",
                  suffixIcon: IconButton(
                    onPressed: generateSKU,
                    icon: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.blueGrey,
                    ),
                    tooltip: "Generate Otomatis",
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Harga Jual",
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      controller: stockCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Stok"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () {
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
                    ctrl.saveProduct(m, isEdit: product != null);
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

  void _showProductOptions(
    BuildContext context,
    ProductModel product,
    ProductController ctrl,
  ) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Produk'),
              onTap: () {
                Get.back();
                _showFormProduct(context, ctrl, product: product);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Hapus Produk',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () => _showConfirmDelete(product, ctrl),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmDelete(ProductModel product, ProductController ctrl) {
    Get.defaultDialog(
      title: "Hapus Produk",
      middleText: "Yakin ingin menghapus ${product.name}?",
      textConfirm: "Hapus",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.badgeRed,
      onConfirm: () => ctrl.softDelete(product.id!),
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
