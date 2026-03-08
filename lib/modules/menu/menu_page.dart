import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/theme/app_colors.dart';
import 'package:my_kasir/core/utils/app_utils.dart';
import 'package:my_kasir/modules/cart/cart_controller.dart';
import 'package:my_kasir/modules/menu/menu_data_controller.dart';

class MenuPage extends StatelessWidget {
  MenuPage({super.key});

  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    Get.put(MenuDataController());
    final controller = Get.find<MenuDataController>();

    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.productsByCategory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.menu_book_outlined, size: 64, color: AppColors.textGrey.withValues(alpha: 0.5)),
                  const SizedBox(height: 16),
                  Text(
                    'No categories or products found',
                    style: TextStyle(color: AppColors.textGrey, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => controller.refresh(),
                    child: Text('Refresh', style: TextStyle(color: AppColors.primaryDark)),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.productsByCategory.length,
            itemBuilder: (context, index) {
              final category = controller.productsByCategory.keys.elementAt(index);
              final products = controller.productsByCategory[category]!;
              return _buildCategorySection(category, products);
            },
          );
        }),
      ),
    );
  }

  Widget _buildCategorySection(String category, List<dynamic> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            category,
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Products in this category
        ...products.map((product) => _buildProductListItem(product)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildProductListItem(dynamic product) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          // Image placeholder
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.imagePlaceholder,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.inventory_2, color: AppColors.textGrey, size: 30),
          ),
          const SizedBox(width: 12),
          // Product info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Stock: ${product.stock}',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppUtils.formatRupiah(product.finalPrice),
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          // Add button
          GestureDetector(
            onTap: () => cartController.addToCart(product),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryDark,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: AppColors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
