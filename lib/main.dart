import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_kasir/core/services/database_service.dart';
import 'package:my_kasir/core/utils/app_utils.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbService = DatabaseService();
  await Get.putAsync(() => dbService.init(), permanent: true);

  AppUtils.cleanImageDirectory();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Kasir',

      initialBinding: InitialBinding(),

      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,

      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
    );
  }
}
