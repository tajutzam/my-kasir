import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/theme/app_colors.dart';
import 'package:my_kasir/core/utils/app_utils.dart';
import 'package:my_kasir/modules/cart/cart_controller.dart';
import 'package:my_kasir/data/models/product_model.dart';

class MenuPage extends StatelessWidget {
  MenuPage({super.key});

  final cartController = Get.find<CartController>();

  // Products grouped by category
  final productsByCategory = {
    'Stationery': [
      ProductModel(
        id: 1,
        categoryId: 1,
        name: 'Premium Notebook',
        sku: 'NB-001',
        stock: 50,
        originalPrice: 80000,
      ),
      ProductModel(
        id: 2,
        categoryId: 1,
        name: 'Ballpoint Pen Black',
        sku: 'PN-001',
        stock: 100,
        originalPrice: 85000,
      ),
    ],
    'Electronics': [
      ProductModel(
        id: 4,
        categoryId: 2,
        name: 'USB Cable Type-C',
        sku: 'USB-001',
        stock: 75,
        originalPrice: 94000,
      ),
    ],
    'Food': [
      ProductModel(
        id: 3,
        categoryId: 3,
        name: 'Desk Organizer',
        sku: 'DO-001',
        stock: 30,
        originalPrice: 75000,
      ),
    ],
    'Beverages': [
      ProductModel(
        id: 6,
        categoryId: 4,
        name: 'File Folder A4',
        sku: 'FF-001',
        stock: 200,
        originalPrice: 55000,
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: productsByCategory.keys.length,
          itemBuilder: (context, index) {
            final category = productsByCategory.keys.elementAt(index);
            final products = productsByCategory[category]!;
            return _buildCategorySection(category, products);
          },
        ),
      ),
    );
  }

  Widget _buildCategorySection(String category, List<ProductModel> products) {
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

  Widget _buildProductListItem(ProductModel product) {
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
            child: const Icon(Icons.inventory_2, color: AppColors.textGrey, size: 28),
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
                    fontWeight: FontWeight.bold,
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
                  AppUtils.formatRupiah(product.originalPrice),
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Add button
          GestureDetector(
            onTap: () => cartController.addToCart(product),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
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
