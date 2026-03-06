import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
