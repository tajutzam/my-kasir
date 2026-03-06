import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/utils/app_utils.dart';
import 'package:my_kasir/data/models/cart_item_model.dart';
import 'package:my_kasir/data/models/product_model.dart';

class CartController extends GetxController {
  // Cart items
  final cartItems = <CartItemModel>[].obs;

  // Notes
  final notesController = TextEditingController();

  // Order info
  final orderNumber = 1.obs;
  final orderDate = DateTime.now().obs;

  // Computed properties
  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);
  double get subTotal => cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get totalDiscount => cartItems.fold(0.0, (sum, item) => sum + item.discountAmount);
  double get totalAmount => subTotal - totalDiscount;

  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }

  // Add product to cart
  void addToCart(ProductModel product) {
    final existingIndex = cartItems.indexWhere((item) => item.product.id == product.id);

    if (existingIndex != -1) {
      // Product already in cart, increment quantity
      final updatedItem = cartItems[existingIndex].incrementQuantity();
      cartItems[existingIndex] = updatedItem;
    } else {
      // Add new item to cart
      cartItems.add(CartItemModel(product: product));
    }

    Get.snackbar(
      'Added to Cart',
      '${product.name} added to your order',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 1),
    );
  }

  // Remove from cart
  void removeFromCart(int productId) {
    cartItems.removeWhere((item) => item.product.id == productId);
  }

  // Update quantity
  void updateQuantity(int productId, int quantity) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (quantity <= 0) {
        removeFromCart(productId);
      } else {
        cartItems[index] = CartItemModel(product: cartItems[index].product, quantity: quantity);
      }
    }
  }

  // Increment quantity
  void incrementQuantity(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      cartItems[index] = cartItems[index].incrementQuantity();
    }
  }

  // Decrement quantity
  void decrementQuantity(int productId) {
    final index = cartItems.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      final updated = cartItems[index].decrementQuantity();
      if (updated.quantity == 0) {
        removeFromCart(productId);
      } else {
        cartItems[index] = updated;
      }
    }
  }

  // Clear cart
  void clearCart() {
    cartItems.clear();
    notesController.clear();
  }

  // Checkout
  void checkout() {
    if (cartItems.isEmpty) {
      Get.snackbar(
        'Cart Empty',
        'Please add items to your cart',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // TODO: Implement checkout logic
    Get.snackbar(
      'Checkout',
      'Order #${orderNumber.value} - Total: ${AppUtils.formatRupiah(totalAmount)}',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 2),
    );

    // Increment order number for next order
    orderNumber.value++;
  }

  // Get formatted total
  String get formattedTotal => AppUtils.formatRupiah(totalAmount);
  String get formattedSubTotal => AppUtils.formatRupiah(subTotal);
  String get formattedDiscount => AppUtils.formatRupiah(totalDiscount);
}
