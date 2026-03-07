import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/theme/app_colors.dart';
import 'package:my_kasir/core/utils/app_utils.dart';
import 'package:my_kasir/modules/cart/cart_controller.dart';
import 'package:my_kasir/modules/home/home_controller.dart';
import 'package:my_kasir/widgets/custom_app_bar.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});

  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: CustomAppBar(),
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Stack(
          children: [
            // LAYER 1: KONTEN UTAMA
            Column(
              children: [
                _buildSearchBar(),
                _buildCategoryChips(),
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.grey),
                      );
                    }
                    if (controller.filteredProducts.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildProductGrid();
                  }),
                ),
                // Spasi bawah agar produk terakhir tidak tertutup mini sheet
                Obx(
                  () => cartController.cartItems.isNotEmpty
                      ? const SizedBox(height: 100)
                      : const SizedBox.shrink(),
                ),
              ],
            ),

            // LAYER 2: DRAGGABLE CART SHEET
            Obx(
              () => cartController.cartItems.isNotEmpty
                  ? _buildDraggableCartSheet()
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  // --- REPAIR: Draggable Scroll Logic ---

  Widget _buildDraggableCartSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.12,
      minChildSize: 0.12,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          // Kita tidak menggunakan Column di sini agar ListView bisa memenuhi seluruh area
          child: ListView(
            controller: scrollController,
            padding: EdgeInsets.zero, // Set zero agar header menempel ke atas
            children: [
              // SEKARANG HEADER ADA DI DALAM LISTVIEW
              // Ini membuat header bisa digunakan untuk menarik sheet
              _buildSheetHeader(),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Rincian Pesanan",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    _buildCartItemList(),
                    const Divider(),
                    _buildCartSummary(),
                    const SizedBox(height: 20),
                    _buildCheckoutButton(),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Header tetap sama, pastikan tidak menghalangi scroll
  Widget _buildSheetHeader() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.shopping_basket_rounded,
                    color: AppColors.primaryDark,
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => Text(
                      "${cartController.totalItems} Produk",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Obx(
                () => Text(
                  cartController.formattedTotal,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDark,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCartItemList() {
    return Obx(
      () => ListView.builder(
        shrinkWrap: true,
        physics:
            const NeverScrollableScrollPhysics(), // Scroll dikontrol oleh Parent ListView
        itemCount: cartController.cartItems.length,
        itemBuilder: (context, index) {
          final item = cartController.cartItems[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              item.product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(AppUtils.formatRupiah(item.product.originalPrice)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () =>
                      cartController.decrementQuantity(item.product.id!),
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "${item.quantity}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () =>
                      cartController.incrementQuantity(item.product.id!),
                  icon: const Icon(
                    Icons.add_circle_outline,
                    color: AppColors.primaryDark,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: TextField(
        onChanged: (value) => controller.updateSearch(value),
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Cari produk...',
          hintStyle: const TextStyle(color: Colors.white54, fontSize: 14),
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

  Widget _buildCategoryChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Obx(() {
        // Ambil .value di sini agar GetX mendaftarkan listener secara eksplisit
        final selectedId = controller.selectedCategoryId.value;

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.categories.length + 1,
          itemBuilder: (context, index) {
            final isAll = index == 0;
            final int categoryId = isAll
                ? 0
                : (controller.categories[index - 1].id ?? 0);
            final String categoryName = isAll
                ? "Semua"
                : controller.categories[index - 1].name;

            final bool isSelected = selectedId == categoryId;

            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                checkmarkColor: Colors.white,
                key: ValueKey('cat_$categoryId'),
                label: Text(categoryName),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) controller.updateCategory(categoryId);
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

  Widget _buildProductGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 0.75,
      ),
      itemCount: controller.filteredProducts.length,
      itemBuilder: (context, index) {
        final product = controller.filteredProducts[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(dynamic product) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
                image:
                    product.imagePath != null && product.imagePath!.isNotEmpty
                    ? DecorationImage(
                        image: FileImage(File(product.imagePath!)),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: product.imagePath == null || product.imagePath!.isEmpty
                  ? Icon(
                      Icons.inventory_2_outlined,
                      color: Colors.grey[400],
                      size: 40,
                    )
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  AppUtils.formatRupiah(product.finalPrice),
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Stok: ${product.stock}",
                      style: TextStyle(
                        fontSize: 11,
                        color: product.stock < 5
                            ? Colors.red
                            : Colors.grey[600],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => cartController.addToCart(product),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primaryDark,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartSummary() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Total Bayar",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Obx(
          () => Text(
            cartController.formattedTotal,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckoutButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          padding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _showPaymentModal(),
        child: const Text(
          "PROSES TRANSAKSI",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off_rounded, size: 70, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Produk tidak ditemukan",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showPaymentModal() {
    // Reset payment controller saat modal buka
    cartController.paymentController.clear();
    cartController.cashReceived.value = 0.0;

    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "TOTAL TAGIHAN",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Obx(
              () => Text(
                cartController.formattedTotal,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryDark,
                ),
              ),
            ),
            const Divider(height: 30),

            // Display Input Nominal
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "BAYAR",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Obx(
                    () => Text(
                      AppUtils.formatRupiah(cartController.cashReceived.value),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Display Kembalian
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Kembalian:",
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    AppUtils.formatRupiah(cartController.changeAmount),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color:
                          cartController.cashReceived.value <
                              cartController.totalAmount
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // CUSTOM NUMERIC KEYPAD
            _buildNumericKeypad(),

            const SizedBox(height: 20),

            // Tombol Konfirmasi Akhir
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryDark,
                  padding: const EdgeInsets.all(18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  if (cartController.cashReceived.value >=
                      cartController.totalAmount) {
                    Get.back(); // Tutup modal input
                    cartController.checkout(); // Jalankan checkout
                  } else {
                    Get.snackbar(
                      "Uang Kurang",
                      "Nominal belum mencukupi",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text(
                  "KONFIRMASI BAYAR",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNumericKeypad() {
    return Column(
      children: [
        Row(children: [_buildKey("1"), _buildKey("2"), _buildKey("3")]),
        Row(children: [_buildKey("4"), _buildKey("5"), _buildKey("6")]),
        Row(children: [_buildKey("7"), _buildKey("8"), _buildKey("9")]),
        Row(
          children: [
            _buildKey("00"),
            _buildKey("0"),
            _buildKey("⌫", isDelete: true),
          ],
        ),
      ],
    );
  }

  Widget _buildKey(String label, {bool isDelete = false}) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(5),
        child: InkWell(
          onTap: () {
            if (isDelete) {
              cartController.deleteCash();
            } else {
              cartController.appendCash(label);
            }
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 60,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.withOpacity(0.1)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDelete ? Colors.red : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
