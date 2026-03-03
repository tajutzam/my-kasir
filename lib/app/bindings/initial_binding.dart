import 'package:get/get.dart';
import '../../core/services/database_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.putAsync<DatabaseService>(() async => DatabaseService().init());
  }
}
