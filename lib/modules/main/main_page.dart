import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/theme/app_colors.dart';
import 'package:my_kasir/modules/main/main_controller.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.put(MainController());

    final List<Map<String, dynamic>> menuItems = [
      {'icon': Icons.home_outlined, 'label': 'Home'},
      {'icon': Icons.menu_book_outlined, 'label': 'Menu'},
      {'icon': Icons.receipt_long_outlined, 'label': 'Orders'},
      {'icon': Icons.local_offer_outlined, 'label': 'Offers'},
      {'icon': Icons.settings_outlined, 'label': 'Manage'},
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      // --- SECTION 1: NAVBAR (TOP) ---
      appBar: AppBar(
        title: const Text(
          "MY KASIR",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
        ),
        backgroundColor: AppColors.primaryDark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => _showEditShop(context, ctrl),
            icon: const Icon(Icons.edit_note),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: AppColors.primaryDark,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () => Text(
                    ctrl.shopName.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
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
                const SizedBox(height: 5),
              ],
            ),
          ),

          // --- SECTION 3: GRID MENU ---
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.2,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => Get.to(ctrl.pages[index]),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          menuItems[index]['icon'],
                          size: 32,
                          color: AppColors.primaryDark,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          menuItems[index]['label'],
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceInfo(String label, RxInt value, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Obx(
            () => Text(
              "Rp ${value.value.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditShop(BuildContext context, MainController ctrl) {
    Get.defaultDialog(
      title: "Edit Info Toko",
      content: Column(
        children: [
          TextField(
            controller: TextEditingController(text: ctrl.shopName.value),
            onChanged: (v) => ctrl.shopName.value = v,
            decoration: const InputDecoration(labelText: "Nama Toko"),
          ),
          TextField(
            controller: TextEditingController(text: ctrl.shopAddress.value),
            onChanged: (v) => ctrl.shopAddress.value = v,
            decoration: const InputDecoration(labelText: "Alamat"),
          ),
        ],
      ),
      textConfirm: "Simpan",
      confirmTextColor: Colors.white,
      buttonColor: AppColors.primaryDark,
      onConfirm: () => Get.back(),
    );
  }
}
