import 'package:get/get.dart';
import 'package:my_kasir/modules/home/home_binding.dart';
import 'package:my_kasir/modules/home/home_page.dart';
import 'package:my_kasir/modules/info/info_page.dart';
import 'package:my_kasir/modules/main/main_binding.dart';
import 'package:my_kasir/modules/main/main_page.dart';
import 'package:my_kasir/modules/management/categories/category_management_page.dart';
import 'package:my_kasir/modules/management/management_page.dart';
import 'package:my_kasir/modules/management/products/product_management_page.dart';
import 'package:my_kasir/modules/menu/menu_page.dart';
import 'package:my_kasir/modules/offers/offers_page.dart';
import 'package:my_kasir/modules/orders/orders_page.dart';
import 'package:my_kasir/modules/report/report_page.dart';
import 'package:my_kasir/modules/splash/splash_page.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;
  static final routes = <GetPage>[
    GetPage(name: Routes.HOME, page: () => HomePage(), binding: HomeBinding()),
    GetPage(name: Routes.MENU, page: () => MenuPage()),
    GetPage(name: Routes.OFFERS, page: () => OffersPage()),
    GetPage(name: Routes.REPORT, page: () => ReportPage()),
    GetPage(name: Routes.INFO, page: () => InfoPage()),

    GetPage(name: Routes.MAIN, page: () => MainPage(), binding: MainBinding()),
    GetPage(name: Routes.MANAGEMENT_PAGE, page: () => ManagementPage()),
    GetPage(
      name: Routes.MANAGEMENT_CATEGORY,
      page: () => CategoryManagementPage(),
    ),
    GetPage(
      name: Routes.MANAGEMENT_PRODUCT,
      page: () => ProductManagementPage(),
    ),
    GetPage(name: Routes.SPLASH, page: () => SplashPage()),
  ];
}
