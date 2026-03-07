import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/app/routes/app_routes.dart';
import 'package:my_kasir/core/theme/app_colors.dart';
import 'package:my_kasir/widgets/custom_app_bar.dart';

class ManagementPage extends StatelessWidget {
  const ManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        centerTitle: true,
        showBackButton: true,
        title: "Management",
      ),
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header Section
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 50,
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryDark,
                            AppColors.primaryDark.withOpacity(0.4),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Pusat Kontrol Toko',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Kelola data inventaris dan pengaturan operasional toko Anda di satu tempat.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textGrey,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Grid Content
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 18,
                  crossAxisSpacing: 18,
                  childAspectRatio: 0.88,
                ),
                delegate: SliverChildListDelegate([
                  _buildManagementCard(
                    context,
                    icon: Icons
                        .grid_view_rounded, // Lebih modern dibanding category_outlined
                    title: 'Kategori',
                    description: 'Grup & Kelompok Produk',
                    color: const Color(0xFF6366F1), // Indigo
                    onTap: () => Get.toNamed(Routes.MANAGEMENT_CATEGORY),
                  ),
                  _buildManagementCard(
                    context,
                    icon: Icons
                        .inventory_2_rounded, // Ikon box tertutup yang solid
                    title: 'Produk',
                    description: 'Stok, Harga & SKU',
                    color: const Color(0xFFF59E0B), // Amber
                    onTap: () => Get.toNamed(Routes.MANAGEMENT_PRODUCT),
                  ),
                  _buildManagementCard(
                    context,
                    icon: Icons.storefront_rounded, // Relevan untuk info toko
                    title: 'Info Toko',
                    description: 'Profil & Alamat Toko',
                    color: const Color(0xFF10B981), // Emerald
                    onTap: () => _showComingSoon(),
                  ),
                  _buildManagementCard(
                    context,
                    icon:
                        Icons.receipt_long_rounded, // Relevan untuk pajak/biaya
                    title: 'Pajak & Biaya',
                    description: 'PPN & Charge Layanan',
                    color: const Color(0xFFEF4444), // Rose
                    onTap: () => _showComingSoon(),
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon() {
    Get.snackbar(
      'Coming Soon',
      'Fitur ini sedang dalam tahap pengembangan.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.textDark.withOpacity(0.9),
      colorText: Colors.white,
      margin: const EdgeInsets.all(20),
      borderRadius: 15,
      icon: const Icon(Icons.info_outline, color: Colors.white),
    );
  }

  Widget _buildManagementCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    // TweenAnimationBuilder memberikan efek "fade-in & slide-up" saat page dibuka
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Container dengan Soft Gradient
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(icon, color: color, size: 26),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textGrey.withOpacity(0.8),
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
