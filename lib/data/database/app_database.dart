import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/product_model.dart';
import '../dao/product_dao.dart';

part 'app_database.g.dart';

@Database(version: 1, entities: [ProductModel])
abstract class AppDatabase extends FloorDatabase {
  ProductDao get productDao;

  static Future<AppDatabase> init() async {
    return await $FloorAppDatabase.databaseBuilder('pos_database.db').build();
  }
}
