import 'package:get/get.dart';
import 'package:my_kasir/modules/auth/auth_binding.dart';
import 'package:my_kasir/modules/auth/view/login.dart';
import 'package:my_kasir/modules/auth/view/register.dart';

import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = <GetPage>[
    GetPage(
      name: Routes.LOGIN,
      page: () => LoginPage(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => RegisterPage(),
      binding: AuthBinding(),
    ),
  ];
}
