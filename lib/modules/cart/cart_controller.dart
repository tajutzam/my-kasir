import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_kasir/core/theme/app_colors.dart';
import 'package:my_kasir/core/utils/app_utils.dart';
import 'package:my_kasir/data/models/cart_item_model.dart';
import 'package:my_kasir/data/models/product_model.dart';
import 'package:my_kasir/data/models/transaction_model.dart';
import 'package:my_kasir/data/models/transaction_item_model.dart';
import 'package:my_kasir/data/repositories/transaction_repositories.dart';
import 'package:my_kasir/modules/home/home_controller.dart';

class CartController extends GetxController {
  final TransactionRepository transactionRepo;
  CartController(this.transactionRepo);

  final cartItems = <CartItemModel>[].obs;
  final notesController = TextEditingController();

  final paymentController = TextEditingController();

  final orderNumber = 1.obs;
  final orderDate = DateTime.now().obs;

  final cashReceived = 0.0.obs;

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get subTotal => cartItems.fold(
    0.0,
    (sum, item) => sum + (item.product.originalPrice * item.quantity),
  );

  double get totalDiscount => cartItems.fold(
    0.0,
    (sum, item) => sum + (item.discountAmount * item.quantity),
  );

  double get totalAmount => subTotal - totalDiscount;

  double get changeAmount {
    if (cashReceived.value <= 0) return 0;
    final res = cashReceived.value - totalAmount;
    return res < 0 ? 0 : res;
  }

  @override
  void onClose() {
    notesController.dispose();
    paymentController.dispose();
    super.onClose();
  }

  void updateCashReceived(String value) {
    cashReceived.value = double.tryParse(value) ?? 0.0;
  }

  Future<void> checkout() async {
    if (cartItems.isEmpty) return;

    // Validasi Uang Kurang
    if (cashReceived.value < totalAmount) {
      Get.snackbar(
        "Pembayaran Kurang",
        "Nominal uang yang dimasukkan belum mencukupi.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.white)),
        barrierDismissible: false,
      );

      final now = DateTime.now();
      final dateStr = DateFormat('yyyyMMdd').format(now);
      final timestamp = now.millisecondsSinceEpoch.toString().substring(8);
      final invoice = "INV/$dateStr/$timestamp";

      // 2. Siapkan Model Transaksi Utama (Dengan Cash & Change)
      final transaction = TransactionModel(
        invoiceNumber: invoice,
        totalAmount: totalAmount,
        totalDiscount: totalDiscount,
        globalDiscount: 0,
        cashReceived: cashReceived.value,
        changeAmount: changeAmount,
        paymentMethod: "Cash",
        cashierName: "Admin",
        status: 'completed',
        date: now,
      );

      // 3. Mapping CartItems
      final List<TransactionItemModel> items = cartItems.map((cart) {
        return TransactionItemModel(
          transactionId: 0,
          productId: cart.product.id,
          productName: cart.product.name,
          quantity: cart.quantity,
          originalPrice: cart.product.originalPrice,
          discountPrice: cart.product.discountPrice,
          subtotal: cart.totalPrice,
        );
      }).toList();

      await transactionRepo.createTransaction(transaction, items);

      Get.back(); // Tutup loading

      // Simpan nilai untuk struk sebelum direset
      final finalChange = changeAmount;
      final finalPaid = cashReceived.value;

      _showSuccessDialog(invoice, finalPaid, finalChange);
      clearCart();

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().refreshData();
      }
    } catch (e) {
      print(e);
      Get.back();
      Get.snackbar(
        "Gagal",
        "Terjadi kesalahan saat menyimpan transaksi: $e",
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showSuccessDialog(String invoice, double paid, double change) {
    Get.defaultDialog(
      title: "",
      backgroundColor: Colors.white,
      radius: 20,
      barrierDismissible: false,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.green,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "TRANSAKSI BERHASIL",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
            ),
            Text(
              invoice,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
                fontFamily: 'monospace',
              ),
            ),
            const Divider(height: 30),

            // Rincian Nominal
            _buildAmountRow(
              "Total Belanja",
              AppUtils.formatRupiah(totalAmount),
            ),
            _buildAmountRow("Uang Diterima", AppUtils.formatRupiah(paid)),
            const Divider(),
            _buildAmountRow(
              "Kembalian",
              AppUtils.formatRupiah(change),
              isHighlight: true,
            ),

            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Get.snackbar("Info", "Fitur cetak sedang disiapkan");
                    },
                    icon: const Icon(
                      Icons.print_rounded,
                      color: Colors.black87,
                      size: 18,
                    ),
                    label: const Text(
                      "STRUK",
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Get.back(),
                    child: const Text(
                      "TUTUP",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountRow(
    String label,
    String value, {
    bool isHighlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isHighlight ? Colors.black : Colors.grey[600],
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isHighlight ? FontWeight.w900 : FontWeight.bold,
              fontSize: isHighlight ? 16 : 13,
              color: isHighlight ? AppColors.primaryDark : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  void addToCart(ProductModel product) {
    final existingIndex = cartItems.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex != -1) {
      cartItems[existingIndex] = cartItems[existingIndex].incrementQuantity();
    } else {
      cartItems.add(CartItemModel(product: product, quantity: 1));
      Get.snackbar(
        'Berhasil',
        '${product.name} ditambah ke keranjang',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        duration: const Duration(milliseconds: 800),
      );
    }
  }

  void removeFromCart(int productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
  }

  void incrementQuantity(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) cartItems[index] = cartItems[index].incrementQuantity();
  }

  void decrementQuantity(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index] = cartItems[index].decrementQuantity();
      } else {
        removeFromCart(productId);
      }
    }
  }

  void clearCart() {
    cartItems.clear();
    notesController.clear();
    paymentController.clear();
    cashReceived.value = 0.0;
  }

  String get formattedTotal => AppUtils.formatRupiah(totalAmount);

  void appendCash(String digit) {
    String current = paymentController.text;
    paymentController.text = current + digit;
    updateCashReceived(paymentController.text);
  }

  void deleteCash() {
    String current = paymentController.text;
    if (current.isNotEmpty) {
      paymentController.text = current.substring(0, current.length - 1);
      updateCashReceived(paymentController.text);
    }
  }
}
