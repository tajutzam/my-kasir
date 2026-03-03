import 'package:get/get.dart';
import '../../data/database/app_database.dart';

class DatabaseService extends GetxService {
  late AppDatabase database;

  Future<DatabaseService> init() async {
    database = await $FloorAppDatabase
        .databaseBuilder('pos_database.db')
        .build();

    return this;
  }
}
