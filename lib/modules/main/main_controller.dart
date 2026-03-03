import 'package:get/get.dart';
import 'package:my_kasir/modules/home/home_page.dart';
import 'package:my_kasir/modules/menu/menu_page.dart';
import 'package:my_kasir/modules/offers/offers_page.dart';
import 'package:my_kasir/modules/orders/orders_page.dart';
import 'package:my_kasir/modules/management/management_page.dart';

class MainController extends GetxController {
  final currentIndex = 0.obs;

  final pages = [
    HomePage(),
    MenuPage(),
    OrdersPage(),
    OffersPage(),
    ManagementPage(),
  ];
}
