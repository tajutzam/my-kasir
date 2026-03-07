import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../models/product_model.dart';
import '../models/user_model.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';
import '../models/transaction_item_model.dart';
import '../models/store_profile_model.dart';
import '../dao/product_dao.dart';
import '../dao/user_dao.dart';
import '../dao/category_dao.dart';
import '../dao/transaction_dao.dart';
import '../dao/transaction_item_dao.dart';
import '../dao/store_profile_dao.dart';

part 'app_database.g.dart';

@Database(
  version: 3,
  entities: [
    ProductModel,
    UserModel,
    CategoryModel,
    TransactionModel,
    TransactionItemModel,
    StoreProfileModel,
  ],
)
abstract class AppDatabase extends FloorDatabase {
  ProductDao get productDao;
  UserDao get userDao;
  CategoryDao get categoryDao;
  TransactionDao get transactionDao;
  TransactionItemDao get transactionItemDao;
  StoreProfileDao get storeProfileDao;
}
