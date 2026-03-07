import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_kasir/app/routes/app_routes.dart';
import 'package:my_kasir/modules/home/home_page.dart';
import 'package:my_kasir/modules/info/info_page.dart';
import 'package:my_kasir/modules/management/management_page.dart';
import 'package:my_kasir/modules/management/products/product_management_page.dart';
import 'package:my_kasir/modules/menu/menu_page.dart';
import 'package:my_kasir/modules/offers/offers_page.dart';
import 'package:my_kasir/modules/orders/orders_page.dart';
import 'package:my_kasir/modules/report/report_page.dart';
// Import pages Anda...

class MainController extends GetxController {
  final currentIndex = 0.obs;

  // Data Jam & Toko (Bisa ditarik dari API/Local Storage nantinya)
  final currentTime = "".obs;
  final shopName = "Warung Zam-Zam".obs;
  final shopAddress = "Jl. Sudirman No. 123, Jakarta".obs;

  // Data Keuangan (Contoh)
  final income = 1500000.obs;
  final expense = 450000.obs;

  final List<String> routeNames = [
    Routes.HOME, // Kasir
    Routes.MANAGEMENT_PRODUCT, // Produk
    Routes.REPORT, // Laporan
    Routes.MANAGEMENT_PAGE, // Kelola (Ganti ke route management kamu)
    Routes.INFO, // Bantuan
    Routes.SPLASH, // Logout (Redirect ke Splash/Login)
  ];

  @override
  void onInit() {
    super.onInit();
    // Update jam setiap detik
    updateTime();
    Timer.periodic(const Duration(seconds: 1), (timer) => updateTime());
  }

  void updateTime() {
    currentTime.value = DateFormat('HH:mm:ss').format(DateTime.now());
  }

  final pages = [
    HomePage(),
    ProductManagementPage(),
    ReportPage(),
    ManagementPage(),
    InfoPage(),
  ];
}
