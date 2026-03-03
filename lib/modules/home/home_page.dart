import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/theme/app_colors.dart';
import 'package:my_kasir/core/utils/app_utils.dart';
import 'package:my_kasir/modules/cart/cart_controller.dart';
import 'package:my_kasir/modules/debug/debug_page.dart';
import 'package:my_kasir/data/models/product_model.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final cartController = Get.find<CartController>();

  // Sample products - in real app, get from database
  final sampleProducts = [
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
    ProductModel(
      id: 3,
      categoryId: 1,
      name: 'Desk Organizer',
      sku: 'DO-001',
      stock: 30,
      originalPrice: 75000,
    ),
    ProductModel(
      id: 4,
      categoryId: 1,
      name: 'USB Cable Type-C',
      sku: 'USB-001',
      stock: 75,
      originalPrice: 94000,
    ),
    ProductModel(
      id: 5,
      categoryId: 1,
      name: 'Stapler Premium',
      sku: 'ST-001',
      stock: 40,
      originalPrice: 78000,
    ),
    ProductModel(
      id: 6,
      categoryId: 1,
      name: 'File Folder A4',
      sku: 'FF-001',
      stock: 200,
      originalPrice: 55000,
    ),
  ];

  final categories = [
    {'name': 'All', 'icon': Icons.apps},
    {'name': 'Stationery', 'icon': Icons.edit},
    {'name': 'Electronics', 'icon': Icons.devices},
    {'name': 'Food', 'icon': Icons.fastfood},
    {'name': 'Beverages', 'icon': Icons.coffee},
  ];

  final selectedCategory = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildSearchBar(),
            _buildCategoryChips(),
            Expanded(child: _buildProductGrid()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.primaryDark,
      child: Row(
        children: [
          const Icon(Icons.storefront, color: AppColors.white, size: 24),
          const SizedBox(width: 8),
          const Text(
            'My Kasir',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          // Avatar placeholder
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: AppColors.lightGrey,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: AppColors.textGrey, size: 20),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onLongPress: () => Get.to(() => const DebugPage()),
            child: Stack(
              children: [
                const Icon(Icons.notifications, color: AppColors.white, size: 24),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: AppColors.badgeRed,
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(color: AppColors.white, fontSize: 8, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.textGrey),
            const SizedBox(width: 8),
            Text(
              'Search products...',
              style: TextStyle(color: AppColors.textGrey.withValues(alpha: 0.7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Obx(() => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(category['icon'] as IconData, size: 16, color: selectedCategory.value == index ? AppColors.white : AppColors.textDark),
                  const SizedBox(width: 4),
                  Text(category['name'] as String),
                ],
              ),
              selected: selectedCategory.value == index,
              onSelected: (_) => selectedCategory.value = index,
              backgroundColor: AppColors.lightGrey,
              selectedColor: AppColors.primaryDark,
              labelStyle: TextStyle(
                color: selectedCategory.value == index ? AppColors.white : AppColors.textDark,
                fontWeight: FontWeight.w500,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              side: BorderSide.none,
            ),
          ));
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: sampleProducts.length,
        itemBuilder: (context, index) {
          final product = sampleProducts[index];
          return _buildProductCard(product);
        },
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.imagePlaceholder,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              ),
              child: const Icon(Icons.inventory_2, color: AppColors.textGrey, size: 48),
            ),
          ),
          // Product info
          Padding(
            padding: const EdgeInsets.all(12),
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
                  AppUtils.formatRupiah(product.originalPrice),
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          // Add button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => cartController.addToCart(product),
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryDark,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: AppColors.white, size: 18),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
