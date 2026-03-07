import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/theme/app_colors.dart';
import 'package:my_kasir/modules/main/main_controller.dart';
import 'package:my_kasir/widgets/custom_app_bar.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(MainController());

    final List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.grid_view_rounded,
        'label': 'Dashboard',
        'color': Colors.blue,
      },
      {
        'icon': Icons.inventory_2_rounded,
        'label': 'Produk',
        'color': Colors.orange,
      },
      {
        'icon': Icons.shopping_cart_rounded,
        'label': 'Transaksi',
        'color': Colors.green,
      },
      {
        'icon': Icons.analytics_rounded,
        'label': 'Laporan',
        'color': Colors.purple,
      },
      {
        'icon': Icons.settings_suggest_rounded,
        'label': 'Kelola',
        'color': Colors.teal,
      },
      {
        'icon': Icons.info_rounded,
        'label': 'Bantuan',
        'color': Colors.blueGrey,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      appBar: CustomAppBar(
        centerTitle: true,
        title: "MY KASIR",
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: () => _showEditShop(context, ctrl),
            icon: const Icon(Icons.storefront_rounded, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(ctrl),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Main Menu",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    3, // Ubah ke 3 kolom agar lebih compact dan modern
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.9,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return _buildMenuCard(
                  context: context,
                  icon: item['icon'],
                  label: item['label'],
                  color: item['color'],
                  onTap: () => Get.to(ctrl.pages[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(MainController ctrl) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    ctrl.shopName.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: Colors.white70,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Obx(
                        () => Text(
                          ctrl.shopAddress.value,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniStat(
                        "Penjualan Hari Ini",
                        "Rp 1.250.000",
                        Icons.trending_up_rounded,
                      ),
                      Container(width: 1, height: 30, color: Colors.white24),
                      _buildMiniStat(
                        "Transaksi",
                        "42",
                        Icons.receipt_long_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.white70),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      builder: (context, value, child) {
        return Transform.scale(scale: value, child: child);
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(height: 10),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditShop(BuildContext context, MainController ctrl) {
    Get.defaultDialog(
      title: "Edit Info Toko",
      titleStyle: const TextStyle(fontWeight: FontWeight.bold),
      backgroundColor: Colors.white,
      radius: 20,
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            TextField(
              controller: TextEditingController(text: ctrl.shopName.value),
              onChanged: (v) => ctrl.shopName.value = v,
              decoration: InputDecoration(
                labelText: "Nama Toko",
                prefixIcon: const Icon(Icons.store_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: TextEditingController(text: ctrl.shopAddress.value),
              onChanged: (v) => ctrl.shopAddress.value = v,
              decoration: InputDecoration(
                labelText: "Alamat",
                prefixIcon: const Icon(Icons.map_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ],
        ),
      ),
      textConfirm: "Simpan",
      textCancel: "Batal",
      confirmTextColor: Colors.white,
      buttonColor: Colors.grey,
      onConfirm: () => Get.back(),
    );
  }
}
