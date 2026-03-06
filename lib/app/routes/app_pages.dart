import 'package:get/get.dart';
import 'package:my_kasir/modules/home/home_page.dart';
import 'package:my_kasir/modules/main/main_binding.dart';
import 'package:my_kasir/modules/main/main_page.dart';
import 'package:my_kasir/modules/menu/menu_page.dart';
import 'package:my_kasir/modules/offers/offers_page.dart';
import 'package:my_kasir/modules/orders/orders_page.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.MAIN;
  static final routes = <GetPage>[
    GetPage(name: Routes.HOME, page: () => HomePage()),
    GetPage(name: Routes.MENU, page: () => MenuPage()),
    GetPage(name: Routes.OFFERS, page: () => OffersPage()),
    GetPage(name: Routes.ORDERS, page: () => OrdersPage()),
    GetPage(name: Routes.MAIN, page: () => MainPage(), binding: MainBinding()),
  ];
}
