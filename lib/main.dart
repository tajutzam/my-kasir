import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/services/database_service.dart';
import 'core/theme/app_theme.dart';
import 'modules/main/main_page.dart';
import 'modules/cart/cart_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize database and bindings before app starts
  final databaseService = await DatabaseService().init();
  Get.put(databaseService);

  // Initialize CartController before app starts
  Get.put(CartController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Kasir',
      theme: AppTheme.lightTheme,
      home: const MainPage(),
    );
  }
}
