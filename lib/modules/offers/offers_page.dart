import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/theme/app_colors.dart';
import 'package:my_kasir/core/utils/app_utils.dart';
import 'package:my_kasir/modules/cart/cart_controller.dart';
import 'package:my_kasir/data/models/product_model.dart';

class OffersPage extends StatelessWidget {
  OffersPage({super.key});

  final cartController = Get.find<CartController>();

  // Special offer products with discount
  final offerProducts = [
    {
      'product': ProductModel(
        id: 1,
        categoryId: 1,
        name: 'Premium Notebook',
        sku: 'NB-001',
        stock: 50,
        originalPrice: 80000,
        discountPrice: 68000,
        discountPercentage: 15.0,
      ),
      'discount': 15,
    },
    {
      'product': ProductModel(
        id: 2,
        categoryId: 1,
        name: 'Ballpoint Pen Black',
        sku: 'PN-001',
        stock: 100,
        originalPrice: 85000,
        discountPrice: 76500,
        discountPercentage: 10.0,
      ),
      'discount': 10,
    },
    {
      'product': ProductModel(
        id: 3,
        categoryId: 1,
        name: 'Desk Organizer',
        sku: 'DO-001',
        stock: 30,
        originalPrice: 75000,
        discountPrice: 67500,
        discountPercentage: 10.0,
      ),
      'discount': 10,
    },
    {
      'product': ProductModel(
        id: 4,
        categoryId: 1,
        name: 'USB Cable Type-C',
        sku: 'USB-001',
        stock: 75,
        originalPrice: 94000,
        discountPrice: 79900,
        discountPercentage: 15.0,
      ),
      'discount': 15,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              _buildVoucherBanner(),
              _buildOfferGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        'Special Offers',
        style: TextStyle(
          color: AppColors.textDark,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildVoucherBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 140,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Left side - image placeholder
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.local_offer, color: AppColors.white, size: 48),
            ),
          ),
          // Right side - voucher info
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.storefront, color: AppColors.white, size: 16),
                      const SizedBox(width: 4),
                      const Text(
                        'My Kasir',
                        style: TextStyle(color: AppColors.white, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Get special discount',
                    style: TextStyle(color: AppColors.white.withValues(alpha: 0.7), fontSize: 11),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '15% OFF',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Code: MYKASIR15',
                      style: TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'DISCOUNT VOUCHER',
                    style: TextStyle(
                      color: AppColors.discountBadge,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOfferGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: offerProducts.length,
        itemBuilder: (context, index) {
          final offer = offerProducts[index];
          return _buildOfferCard(offer['product'] as ProductModel, offer['discount'] as int);
        },
      ),
    );
  }

  Widget _buildOfferCard(ProductModel product, int discount) {
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
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image placeholder
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.imagePlaceholder,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      ),
                      child: const Icon(Icons.inventory_2, color: AppColors.textGrey, size: 40),
                    ),
                    // Discount badge
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.discountBadge,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$discount%',
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          AppUtils.formatRupiah(product.originalPrice),
                          style: TextStyle(
                            color: AppColors.textGrey.withValues(alpha: 0.8),
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppUtils.formatRupiah(product.discountPrice!),
                          style: const TextStyle(
                            color: AppColors.primaryDark,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Apply button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () => cartController.addToCart(product),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      minimumSize: const Size(0, 36),
                    ),
                    child: const Text('Apply', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
