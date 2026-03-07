import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/services/database_service.dart';
import 'package:my_kasir/core/theme/app_colors.dart';
import 'package:my_kasir/core/utils/app_utils.dart';
import 'package:my_kasir/data/models/category_model.dart';
import 'package:my_kasir/data/models/product_model.dart';
import 'package:my_kasir/data/models/cart_item_model.dart';
import 'package:my_kasir/modules/cart/cart_controller.dart';

class DebugController extends GetxController {
  final DatabaseService dbService = Get.find<DatabaseService>();
  final CartController cartController = Get.find<CartController>();

  final categories = <CategoryModel>[].obs;
  final products = <ProductModel>[].obs;
  final cartItems = <CartItemModel>[].obs;

  final RxInt selectedTab = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    await loadCategories();
    await loadProducts();
    loadCartItems();
  }

  Future<void> loadCategories() async {
    categories.value = await dbService.database.categoryDao.getAllCategories();
  }

  Future<void> loadProducts() async {
    products.value = await dbService.database.productDao.getAllProducts();
  }

  void loadCartItems() {
    cartItems.value = cartController.cartItems;
  }

  String get cartSummary {
    return 'Items: ${cartController.totalItems} | '
        'Subtotal: ${AppUtils.formatRupiah(cartController.subTotal)} | '
        'Discount: ${AppUtils.formatRupiah(cartController.totalDiscount)} | '
        'Total: ${AppUtils.formatRupiah(cartController.totalAmount)}';
  }
}

class DebugPage extends StatelessWidget {
  const DebugPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DebugController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Database Inspector'),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Get.find<DebugController>().loadData();
            },
          ),
        ],
      ),
      body: GetX<DebugController>(
        builder: (controller) {
          return Column(
            children: [
              // Tab selector
              Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    _buildTab(context, controller, 0, 'Categories'),
                    const SizedBox(width: 8),
                    _buildTab(context, controller, 1, 'Products'),
                    const SizedBox(width: 8),
                    _buildTab(context, controller, 2, 'Cart'),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Content
              Expanded(child: _buildContent(controller)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTab(
    BuildContext context,
    DebugController controller,
    int index,
    String label,
  ) {
    return Expanded(
      child: Obx(
        () => ElevatedButton(
          onPressed: () => controller.selectedTab.value = index,
          style: ElevatedButton.styleFrom(
            backgroundColor: controller.selectedTab.value == index
                ? AppColors.primaryDark
                : AppColors.textGrey.withValues(alpha: 0.2),
            foregroundColor: controller.selectedTab.value == index
                ? AppColors.white
                : AppColors.textDark,
          ),
          child: Text(label),
        ),
      ),
    );
  }

  Widget _buildContent(DebugController controller) {
    switch (controller.selectedTab.value) {
      case 0:
        return _buildCategoriesList(controller);
      case 1:
        return _buildProductsList(controller);
      case 2:
        return _buildCartList(controller);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCategoriesList(DebugController controller) {
    if (controller.categories.isEmpty) {
      return const Center(child: Text('No categories found'));
    }

    return ListView.builder(
      itemCount: controller.categories.length,
      itemBuilder: (context, index) {
        final category = controller.categories[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryDark,
              child: Text(
                '${category.id}',
                style: const TextStyle(color: AppColors.white),
              ),
            ),
            title: Text(category.name),
            subtitle: Text(
              'Active: ${category.isActiveBool} | Deleted: ${category.isDeletedBool}\n'
              'Created: ${AppUtils.formatDate(category.createdAt)}',
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductsList(DebugController controller) {
    if (controller.products.isEmpty) {
      return const Center(child: Text('No products found'));
    }

    return ListView.builder(
      itemCount: controller.products.length,
      itemBuilder: (context, index) {
        final product = controller.products[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primaryMedium,
              child: Text(
                '${product.id}',
                style: const TextStyle(color: AppColors.white),
              ),
            ),
            title: Text(product.name),
            subtitle: Text(
              'Category ID: ${product.categoryId}\n'
              'Stock: ${product.stock} | Price: ${AppUtils.formatRupiah(product.finalPrice)}\n'
              'Active: ${product.isActiveBool} | Deleted: ${product.isDeletedBool}\n'
              'Created: ${AppUtils.formatDate(product.createdAt)}',
            ),
            trailing: product.hasDiscount
                ? Chip(
                    label: Text(
                      '${product.discountPercentage?.toStringAsFixed(0)}% OFF',
                      style: const TextStyle(fontSize: 10),
                    ),
                    backgroundColor: AppColors.badgeRed,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                  )
                : null,
          ),
        );
      },
    );
  }

  Widget _buildCartList(DebugController controller) {
    final cart = controller.cartController;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: AppColors.primaryDark.withValues(alpha: 0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order #${cart.orderNumber.value}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(controller.cartSummary),
            ],
          ),
        ),
        Expanded(
          child: controller.cartItems.isEmpty
              ? const Center(child: Text('Cart is empty'))
              : ListView.builder(
                  itemCount: controller.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = controller.cartItems[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.badgeRed,
                          child: Text(
                            '${item.quantity}',
                            style: const TextStyle(color: AppColors.white),
                          ),
                        ),
                        title: Text(item.product.name),
                        subtitle: Text(
                          'Price: ${AppUtils.formatRupiah(item.unitPrice)}\n'
                          'Total: ${AppUtils.formatRupiah(item.totalPrice)}',
                        ),
                        trailing: item.product.hasDiscount
                            ? Chip(
                                label: Text(
                                  '-${AppUtils.formatRupiah(item.discountAmount)}',
                                  style: const TextStyle(fontSize: 10),
                                ),
                                backgroundColor: AppColors.badgeRed.withValues(
                                  alpha: 0.2,
                                ),
                                labelPadding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
