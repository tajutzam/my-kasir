// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ProductDao? _productDaoInstance;

  UserDao? _userDaoInstance;

  CategoryDao? _categoryDaoInstance;

  TransactionDao? _transactionDaoInstance;

  TransactionItemDao? _transactionItemDaoInstance;

  StoreProfileDao? _storeProfileDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 3,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `products` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `category_id` INTEGER NOT NULL, `name` TEXT NOT NULL, `sku` TEXT, `stock` INTEGER NOT NULL, `costPrice` REAL, `originalPrice` REAL NOT NULL, `discountPrice` REAL, `discountPercentage` REAL, `imagePath` TEXT, `is_active` INTEGER NOT NULL, `is_deleted` INTEGER NOT NULL, `deleted_at` INTEGER, `created_at` INTEGER NOT NULL, `updated_at` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` INTEGER, `fullName` TEXT NOT NULL, `email` TEXT NOT NULL, `password` TEXT NOT NULL, `phone` TEXT, `createdAtMillis` INTEGER NOT NULL, `updatedAtMillis` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `categories` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL, `is_active` INTEGER NOT NULL, `is_deleted` INTEGER NOT NULL, `deleted_at` INTEGER, `created_at` INTEGER NOT NULL, `updated_at` INTEGER NOT NULL)');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `transaction` (`id` INTEGER, `invoiceNumber` TEXT NOT NULL, `dateMillis` INTEGER NOT NULL, `totalAmount` REAL NOT NULL, `totalDiscount` REAL NOT NULL, `globalDiscount` REAL NOT NULL, `paymentMethod` TEXT NOT NULL, `cashierName` TEXT NOT NULL, `status` TEXT NOT NULL, `voidReason` TEXT, `createdAtMillis` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `transaction_items` (`id` INTEGER, `transactionId` INTEGER NOT NULL, `productId` INTEGER, `productName` TEXT NOT NULL, `quantity` INTEGER NOT NULL, `originalPrice` REAL NOT NULL, `discountPrice` REAL, `subtotal` REAL NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `store_profile` (`id` INTEGER NOT NULL, `storeName` TEXT, `address` TEXT, `phone` TEXT, `email` TEXT, `logoPath` TEXT, `footerNote` TEXT, `taxNumber` TEXT, `themeColor` TEXT, `isDarkMode` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE INDEX `index_products_name` ON `products` (`name`)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_products_sku` ON `products` (`sku`)');
        await database.execute(
            'CREATE INDEX `index_products_category_id` ON `products` (`category_id`)');
        await database.execute(
            'CREATE INDEX `index_products_is_deleted` ON `products` (`is_deleted`)');
        await database.execute(
            'CREATE INDEX `index_categories_name` ON `categories` (`name`)');
        await database.execute(
            'CREATE INDEX `index_categories_is_deleted` ON `categories` (`is_deleted`)');
        await database.execute(
            'CREATE UNIQUE INDEX `index_transaction_invoiceNumber` ON `transaction` (`invoiceNumber`)');
        await database.execute(
            'CREATE INDEX `index_transaction_dateMillis` ON `transaction` (`dateMillis`)');
        await database.execute(
            'CREATE INDEX `index_transaction_status` ON `transaction` (`status`)');
        await database.execute(
            'CREATE INDEX `index_transaction_items_transactionId` ON `transaction_items` (`transactionId`)');
        await database.execute(
            'CREATE INDEX `index_transaction_items_productId` ON `transaction_items` (`productId`)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ProductDao get productDao {
    return _productDaoInstance ??= _$ProductDao(database, changeListener);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  CategoryDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDao(database, changeListener);
  }

  @override
  TransactionDao get transactionDao {
    return _transactionDaoInstance ??=
        _$TransactionDao(database, changeListener);
  }

  @override
  TransactionItemDao get transactionItemDao {
    return _transactionItemDaoInstance ??=
        _$TransactionItemDao(database, changeListener);
  }

  @override
  StoreProfileDao get storeProfileDao {
    return _storeProfileDaoInstance ??=
        _$StoreProfileDao(database, changeListener);
  }
}

class _$ProductDao extends ProductDao {
  _$ProductDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productModelInsertionAdapter = InsertionAdapter(
            database,
            'products',
            (ProductModel item) => <String, Object?>{
                  'id': item.id,
                  'category_id': item.categoryId,
                  'name': item.name,
                  'sku': item.sku,
                  'stock': item.stock,
                  'costPrice': item.costPrice,
                  'originalPrice': item.originalPrice,
                  'discountPrice': item.discountPrice,
                  'discountPercentage': item.discountPercentage,
                  'imagePath': item.imagePath,
                  'is_active': item.isActive,
                  'is_deleted': item.isDeleted,
                  'deleted_at': item.deletedAtMillis,
                  'created_at': item.createdAtMillis,
                  'updated_at': item.updatedAtMillis
                }),
        _productModelUpdateAdapter = UpdateAdapter(
            database,
            'products',
            ['id'],
            (ProductModel item) => <String, Object?>{
                  'id': item.id,
                  'category_id': item.categoryId,
                  'name': item.name,
                  'sku': item.sku,
                  'stock': item.stock,
                  'costPrice': item.costPrice,
                  'originalPrice': item.originalPrice,
                  'discountPrice': item.discountPrice,
                  'discountPercentage': item.discountPercentage,
                  'imagePath': item.imagePath,
                  'is_active': item.isActive,
                  'is_deleted': item.isDeleted,
                  'deleted_at': item.deletedAtMillis,
                  'created_at': item.createdAtMillis,
                  'updated_at': item.updatedAtMillis
                }),
        _productModelDeletionAdapter = DeletionAdapter(
            database,
            'products',
            ['id'],
            (ProductModel item) => <String, Object?>{
                  'id': item.id,
                  'category_id': item.categoryId,
                  'name': item.name,
                  'sku': item.sku,
                  'stock': item.stock,
                  'costPrice': item.costPrice,
                  'originalPrice': item.originalPrice,
                  'discountPrice': item.discountPrice,
                  'discountPercentage': item.discountPercentage,
                  'imagePath': item.imagePath,
                  'is_active': item.isActive,
                  'is_deleted': item.isDeleted,
                  'deleted_at': item.deletedAtMillis,
                  'created_at': item.createdAtMillis,
                  'updated_at': item.updatedAtMillis
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProductModel> _productModelInsertionAdapter;

  final UpdateAdapter<ProductModel> _productModelUpdateAdapter;

  final DeletionAdapter<ProductModel> _productModelDeletionAdapter;

  @override
  Future<List<ProductModel>> getAllProducts() async {
    return _queryAdapter.queryList(
        'SELECT * FROM products WHERE is_deleted = 0 ORDER BY id DESC',
        mapper: (Map<String, Object?> row) => ProductModel(
            id: row['id'] as int?,
            categoryId: row['category_id'] as int,
            name: row['name'] as String,
            sku: row['sku'] as String?,
            stock: row['stock'] as int,
            costPrice: row['costPrice'] as double?,
            originalPrice: row['originalPrice'] as double,
            discountPrice: row['discountPrice'] as double?,
            discountPercentage: row['discountPercentage'] as double?,
            imagePath: row['imagePath'] as String?,
            isActive: row['is_active'] as int,
            isDeleted: row['is_deleted'] as int,
            deletedAtMillis: row['deleted_at'] as int?));
  }

  @override
  Future<ProductModel?> getProductById(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM products WHERE id = ?1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => ProductModel(
            id: row['id'] as int?,
            categoryId: row['category_id'] as int,
            name: row['name'] as String,
            sku: row['sku'] as String?,
            stock: row['stock'] as int,
            costPrice: row['costPrice'] as double?,
            originalPrice: row['originalPrice'] as double,
            discountPrice: row['discountPrice'] as double?,
            discountPercentage: row['discountPercentage'] as double?,
            imagePath: row['imagePath'] as String?,
            isActive: row['is_active'] as int,
            isDeleted: row['is_deleted'] as int,
            deletedAtMillis: row['deleted_at'] as int?),
        arguments: [id]);
  }

  @override
  Future<ProductModel?> getProductBySku(String sku) async {
    return _queryAdapter.query(
        'SELECT * FROM products WHERE sku = ?1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => ProductModel(
            id: row['id'] as int?,
            categoryId: row['category_id'] as int,
            name: row['name'] as String,
            sku: row['sku'] as String?,
            stock: row['stock'] as int,
            costPrice: row['costPrice'] as double?,
            originalPrice: row['originalPrice'] as double,
            discountPrice: row['discountPrice'] as double?,
            discountPercentage: row['discountPercentage'] as double?,
            imagePath: row['imagePath'] as String?,
            isActive: row['is_active'] as int,
            isDeleted: row['is_deleted'] as int,
            deletedAtMillis: row['deleted_at'] as int?),
        arguments: [sku]);
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(int categoryId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM products WHERE category_id = ?1 AND is_deleted = 0 ORDER BY id DESC',
        mapper: (Map<String, Object?> row) => ProductModel(id: row['id'] as int?, categoryId: row['category_id'] as int, name: row['name'] as String, sku: row['sku'] as String?, stock: row['stock'] as int, costPrice: row['costPrice'] as double?, originalPrice: row['originalPrice'] as double, discountPrice: row['discountPrice'] as double?, discountPercentage: row['discountPercentage'] as double?, imagePath: row['imagePath'] as String?, isActive: row['is_active'] as int, isDeleted: row['is_deleted'] as int, deletedAtMillis: row['deleted_at'] as int?),
        arguments: [categoryId]);
  }

  @override
  Future<List<ProductModel>> searchProducts(String searchQuery) async {
    return _queryAdapter.queryList(
        'SELECT * FROM products WHERE name LIKE ?1 OR sku LIKE ?1 AND is_deleted = 0 ORDER BY id DESC',
        mapper: (Map<String, Object?> row) => ProductModel(id: row['id'] as int?, categoryId: row['category_id'] as int, name: row['name'] as String, sku: row['sku'] as String?, stock: row['stock'] as int, costPrice: row['costPrice'] as double?, originalPrice: row['originalPrice'] as double, discountPrice: row['discountPrice'] as double?, discountPercentage: row['discountPercentage'] as double?, imagePath: row['imagePath'] as String?, isActive: row['is_active'] as int, isDeleted: row['is_deleted'] as int, deletedAtMillis: row['deleted_at'] as int?),
        arguments: [searchQuery]);
  }

  @override
  Future<List<ProductModel>> getLowStockProducts(int minStock) async {
    return _queryAdapter.queryList(
        'SELECT * FROM products WHERE stock < ?1 AND is_deleted = 0 AND is_active = 1 ORDER BY stock ASC',
        mapper: (Map<String, Object?> row) => ProductModel(id: row['id'] as int?, categoryId: row['category_id'] as int, name: row['name'] as String, sku: row['sku'] as String?, stock: row['stock'] as int, costPrice: row['costPrice'] as double?, originalPrice: row['originalPrice'] as double, discountPrice: row['discountPrice'] as double?, discountPercentage: row['discountPercentage'] as double?, imagePath: row['imagePath'] as String?, isActive: row['is_active'] as int, isDeleted: row['is_deleted'] as int, deletedAtMillis: row['deleted_at'] as int?),
        arguments: [minStock]);
  }

  @override
  Future<List<ProductModel>> getActiveProducts() async {
    return _queryAdapter.queryList(
        'SELECT * FROM products WHERE is_active = 1 AND is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => ProductModel(
            id: row['id'] as int?,
            categoryId: row['category_id'] as int,
            name: row['name'] as String,
            sku: row['sku'] as String?,
            stock: row['stock'] as int,
            costPrice: row['costPrice'] as double?,
            originalPrice: row['originalPrice'] as double,
            discountPrice: row['discountPrice'] as double?,
            discountPercentage: row['discountPercentage'] as double?,
            imagePath: row['imagePath'] as String?,
            isActive: row['is_active'] as int,
            isDeleted: row['is_deleted'] as int,
            deletedAtMillis: row['deleted_at'] as int?));
  }

  @override
  Future<List<ProductModel>> getInStockProducts() async {
    return _queryAdapter.queryList(
        'SELECT * FROM products WHERE stock > 0 AND is_active = 1 AND is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => ProductModel(
            id: row['id'] as int?,
            categoryId: row['category_id'] as int,
            name: row['name'] as String,
            sku: row['sku'] as String?,
            stock: row['stock'] as int,
            costPrice: row['costPrice'] as double?,
            originalPrice: row['originalPrice'] as double,
            discountPrice: row['discountPrice'] as double?,
            discountPercentage: row['discountPercentage'] as double?,
            imagePath: row['imagePath'] as String?,
            isActive: row['is_active'] as int,
            isDeleted: row['is_deleted'] as int,
            deletedAtMillis: row['deleted_at'] as int?));
  }

  @override
  Future<List<ProductModel>> getDiscountedProducts() async {
    return _queryAdapter.queryList(
        'SELECT * FROM products WHERE discount_price IS NOT NULL AND discount_price > 0 AND is_deleted = 0 ORDER BY discount_percentage DESC',
        mapper: (Map<String, Object?> row) => ProductModel(
            id: row['id'] as int?,
            categoryId: row['category_id'] as int,
            name: row['name'] as String,
            sku: row['sku'] as String?,
            stock: row['stock'] as int,
            costPrice: row['costPrice'] as double?,
            originalPrice: row['originalPrice'] as double,
            discountPrice: row['discountPrice'] as double?,
            discountPercentage: row['discountPercentage'] as double?,
            imagePath: row['imagePath'] as String?,
            isActive: row['is_active'] as int,
            isDeleted: row['is_deleted'] as int,
            deletedAtMillis: row['deleted_at'] as int?));
  }

  @override
  Future<void> softDeleteProduct(
    int id,
    int deletedAtMillis,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE products SET is_deleted = 1, deleted_at = ?2, is_active = 0 WHERE id = ?1',
        arguments: [id, deletedAtMillis]);
  }

  @override
  Future<void> restoreProduct(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE products SET is_deleted = 0, deleted_at = NULL, is_active = 1 WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> toggleActive(
    int id,
    int isActive,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE products SET is_active = ?2 WHERE id = ?1',
        arguments: [id, isActive]);
  }

  @override
  Future<int?> countProducts() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM products WHERE is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int?> countLowStockProducts(int minStock) async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM products WHERE stock < ?1 AND is_deleted = 0 AND is_active = 1',
        mapper: (Map<String, Object?> row) => row.values.first as int,
        arguments: [minStock]);
  }

  @override
  Future<int?> getTotalStock() async {
    return _queryAdapter.query(
        'SELECT SUM(stock) FROM products WHERE is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int> insertProduct(ProductModel product) {
    return _productModelInsertionAdapter.insertAndReturnId(
        product, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    await _productModelUpdateAdapter.update(product, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteProduct(ProductModel product) async {
    await _productModelDeletionAdapter.delete(product);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _userModelInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (UserModel item) => <String, Object?>{
                  'id': item.id,
                  'fullName': item.fullName,
                  'email': item.email,
                  'password': item.password,
                  'phone': item.phone,
                  'createdAtMillis': item.createdAtMillis,
                  'updatedAtMillis': item.updatedAtMillis
                }),
        _userModelUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['id'],
            (UserModel item) => <String, Object?>{
                  'id': item.id,
                  'fullName': item.fullName,
                  'email': item.email,
                  'password': item.password,
                  'phone': item.phone,
                  'createdAtMillis': item.createdAtMillis,
                  'updatedAtMillis': item.updatedAtMillis
                }),
        _userModelDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['id'],
            (UserModel item) => <String, Object?>{
                  'id': item.id,
                  'fullName': item.fullName,
                  'email': item.email,
                  'password': item.password,
                  'phone': item.phone,
                  'createdAtMillis': item.createdAtMillis,
                  'updatedAtMillis': item.updatedAtMillis
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<UserModel> _userModelInsertionAdapter;

  final UpdateAdapter<UserModel> _userModelUpdateAdapter;

  final DeletionAdapter<UserModel> _userModelDeletionAdapter;

  @override
  Future<List<UserModel>> getAllUsers() async {
    return _queryAdapter.queryList('SELECT * FROM users ORDER BY id DESC',
        mapper: (Map<String, Object?> row) => UserModel(
            id: row['id'] as int?,
            fullName: row['fullName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            phone: row['phone'] as String?));
  }

  @override
  Future<UserModel?> getUserById(int id) async {
    return _queryAdapter.query('SELECT * FROM users WHERE id = ?1',
        mapper: (Map<String, Object?> row) => UserModel(
            id: row['id'] as int?,
            fullName: row['fullName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            phone: row['phone'] as String?),
        arguments: [id]);
  }

  @override
  Future<UserModel?> getUserByEmail(String email) async {
    return _queryAdapter.query('SELECT * FROM users WHERE email = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => UserModel(
            id: row['id'] as int?,
            fullName: row['fullName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            phone: row['phone'] as String?),
        arguments: [email]);
  }

  @override
  Future<UserModel?> login(
    String email,
    String password,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM users WHERE email = ?1 AND password = ?2 LIMIT 1',
        mapper: (Map<String, Object?> row) => UserModel(
            id: row['id'] as int?,
            fullName: row['fullName'] as String,
            email: row['email'] as String,
            password: row['password'] as String,
            phone: row['phone'] as String?),
        arguments: [email, password]);
  }

  @override
  Future<int> insertUser(UserModel user) {
    return _userModelInsertionAdapter.insertAndReturnId(
        user, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateUser(UserModel user) async {
    await _userModelUpdateAdapter.update(user, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteUser(UserModel user) async {
    await _userModelDeletionAdapter.delete(user);
  }
}

class _$CategoryDao extends CategoryDao {
  _$CategoryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _categoryModelInsertionAdapter = InsertionAdapter(
            database,
            'categories',
            (CategoryModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'is_active': item.isActive,
                  'is_deleted': item.isDeleted,
                  'deleted_at': item.deletedAtMillis,
                  'created_at': item.createdAtMillis,
                  'updated_at': item.updatedAtMillis
                }),
        _categoryModelUpdateAdapter = UpdateAdapter(
            database,
            'categories',
            ['id'],
            (CategoryModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'is_active': item.isActive,
                  'is_deleted': item.isDeleted,
                  'deleted_at': item.deletedAtMillis,
                  'created_at': item.createdAtMillis,
                  'updated_at': item.updatedAtMillis
                }),
        _categoryModelDeletionAdapter = DeletionAdapter(
            database,
            'categories',
            ['id'],
            (CategoryModel item) => <String, Object?>{
                  'id': item.id,
                  'name': item.name,
                  'is_active': item.isActive,
                  'is_deleted': item.isDeleted,
                  'deleted_at': item.deletedAtMillis,
                  'created_at': item.createdAtMillis,
                  'updated_at': item.updatedAtMillis
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CategoryModel> _categoryModelInsertionAdapter;

  final UpdateAdapter<CategoryModel> _categoryModelUpdateAdapter;

  final DeletionAdapter<CategoryModel> _categoryModelDeletionAdapter;

  @override
  Future<List<CategoryModel>> getAllCategories() async {
    return _queryAdapter.queryList(
        'SELECT * FROM categories WHERE is_deleted = 0 ORDER BY id DESC',
        mapper: (Map<String, Object?> row) => CategoryModel(
            id: row['id'] as int?,
            name: row['name'] as String,
            isActive: row['is_active'] as int,
            isDeleted: row['is_deleted'] as int,
            deletedAtMillis: row['deleted_at'] as int?));
  }

  @override
  Future<CategoryModel?> getCategoryById(int id) async {
    return _queryAdapter.query(
        'SELECT * FROM categories WHERE id = ?1 AND is_deleted = 0',
        mapper: (Map<String, Object?> row) => CategoryModel(
            id: row['id'] as int?,
            name: row['name'] as String,
            isActive: row['is_active'] as int,
            isDeleted: row['is_deleted'] as int,
            deletedAtMillis: row['deleted_at'] as int?),
        arguments: [id]);
  }

  @override
  Future<CategoryModel?> getCategoryByName(String name) async {
    return _queryAdapter.query(
        'SELECT * FROM categories WHERE name = ?1 AND is_deleted = 0 LIMIT 1',
        mapper: (Map<String, Object?> row) => CategoryModel(
            id: row['id'] as int?,
            name: row['name'] as String,
            isActive: row['is_active'] as int,
            isDeleted: row['is_deleted'] as int,
            deletedAtMillis: row['deleted_at'] as int?),
        arguments: [name]);
  }

  @override
  Future<List<CategoryModel>> getActiveCategories() async {
    return _queryAdapter.queryList(
        'SELECT * FROM categories WHERE is_active = 1 AND is_deleted = 0 ORDER BY name ASC',
        mapper: (Map<String, Object?> row) => CategoryModel(
            id: row['id'] as int?,
            name: row['name'] as String,
            isActive: row['is_active'] as int,
            isDeleted: row['is_deleted'] as int,
            deletedAtMillis: row['deleted_at'] as int?));
  }

  @override
  Future<void> softDeleteCategory(
    int id,
    int deletedAtMillis,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE categories SET is_deleted = 1, deleted_at = ?2, is_active = 0 WHERE id = ?1',
        arguments: [id, deletedAtMillis]);
  }

  @override
  Future<void> restoreCategory(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE categories SET is_deleted = 0, deleted_at = NULL, is_active = 1 WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<int?> countCategories() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM categories WHERE is_deleted = 0',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<void> updateCategoryStatus(
    int id,
    int status,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE categories SET is_active = ?2 WHERE id = ?1',
        arguments: [id, status]);
  }

  @override
  Future<int> insertCategory(CategoryModel category) {
    return _categoryModelInsertionAdapter.insertAndReturnId(
        category, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    await _categoryModelUpdateAdapter.update(
        category, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCategory(CategoryModel category) async {
    await _categoryModelDeletionAdapter.delete(category);
  }
}

class _$TransactionDao extends TransactionDao {
  _$TransactionDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _transactionModelInsertionAdapter = InsertionAdapter(
            database,
            'transaction',
            (TransactionModel item) => <String, Object?>{
                  'id': item.id,
                  'invoiceNumber': item.invoiceNumber,
                  'dateMillis': item.dateMillis,
                  'totalAmount': item.totalAmount,
                  'totalDiscount': item.totalDiscount,
                  'globalDiscount': item.globalDiscount,
                  'paymentMethod': item.paymentMethod,
                  'cashierName': item.cashierName,
                  'status': item.status,
                  'voidReason': item.voidReason,
                  'createdAtMillis': item.createdAtMillis
                }),
        _transactionModelUpdateAdapter = UpdateAdapter(
            database,
            'transaction',
            ['id'],
            (TransactionModel item) => <String, Object?>{
                  'id': item.id,
                  'invoiceNumber': item.invoiceNumber,
                  'dateMillis': item.dateMillis,
                  'totalAmount': item.totalAmount,
                  'totalDiscount': item.totalDiscount,
                  'globalDiscount': item.globalDiscount,
                  'paymentMethod': item.paymentMethod,
                  'cashierName': item.cashierName,
                  'status': item.status,
                  'voidReason': item.voidReason,
                  'createdAtMillis': item.createdAtMillis
                }),
        _transactionModelDeletionAdapter = DeletionAdapter(
            database,
            'transaction',
            ['id'],
            (TransactionModel item) => <String, Object?>{
                  'id': item.id,
                  'invoiceNumber': item.invoiceNumber,
                  'dateMillis': item.dateMillis,
                  'totalAmount': item.totalAmount,
                  'totalDiscount': item.totalDiscount,
                  'globalDiscount': item.globalDiscount,
                  'paymentMethod': item.paymentMethod,
                  'cashierName': item.cashierName,
                  'status': item.status,
                  'voidReason': item.voidReason,
                  'createdAtMillis': item.createdAtMillis
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TransactionModel> _transactionModelInsertionAdapter;

  final UpdateAdapter<TransactionModel> _transactionModelUpdateAdapter;

  final DeletionAdapter<TransactionModel> _transactionModelDeletionAdapter;

  @override
  Future<List<TransactionModel>> getAllTransactions() async {
    return _queryAdapter.queryList(
        'SELECT * FROM transaction ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => TransactionModel(
            id: row['id'] as int?,
            invoiceNumber: row['invoiceNumber'] as String,
            totalAmount: row['totalAmount'] as double,
            totalDiscount: row['totalDiscount'] as double,
            globalDiscount: row['globalDiscount'] as double,
            paymentMethod: row['paymentMethod'] as String,
            cashierName: row['cashierName'] as String,
            status: row['status'] as String,
            voidReason: row['voidReason'] as String?));
  }

  @override
  Future<TransactionModel?> getTransactionById(int id) async {
    return _queryAdapter.query('SELECT * FROM transaction WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TransactionModel(
            id: row['id'] as int?,
            invoiceNumber: row['invoiceNumber'] as String,
            totalAmount: row['totalAmount'] as double,
            totalDiscount: row['totalDiscount'] as double,
            globalDiscount: row['globalDiscount'] as double,
            paymentMethod: row['paymentMethod'] as String,
            cashierName: row['cashierName'] as String,
            status: row['status'] as String,
            voidReason: row['voidReason'] as String?),
        arguments: [id]);
  }

  @override
  Future<TransactionModel?> getTransactionByInvoiceNumber(
      String invoiceNumber) async {
    return _queryAdapter.query(
        'SELECT * FROM transaction WHERE invoice_number = ?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => TransactionModel(
            id: row['id'] as int?,
            invoiceNumber: row['invoiceNumber'] as String,
            totalAmount: row['totalAmount'] as double,
            totalDiscount: row['totalDiscount'] as double,
            globalDiscount: row['globalDiscount'] as double,
            paymentMethod: row['paymentMethod'] as String,
            cashierName: row['cashierName'] as String,
            status: row['status'] as String,
            voidReason: row['voidReason'] as String?),
        arguments: [invoiceNumber]);
  }

  @override
  Future<List<TransactionModel>> getTransactionsByDateRange(
    int startMillis,
    int endMillis,
  ) async {
    return _queryAdapter.queryList(
        'SELECT * FROM transaction WHERE date >= ?1 AND date <= ?2 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => TransactionModel(id: row['id'] as int?, invoiceNumber: row['invoiceNumber'] as String, totalAmount: row['totalAmount'] as double, totalDiscount: row['totalDiscount'] as double, globalDiscount: row['globalDiscount'] as double, paymentMethod: row['paymentMethod'] as String, cashierName: row['cashierName'] as String, status: row['status'] as String, voidReason: row['voidReason'] as String?),
        arguments: [startMillis, endMillis]);
  }

  @override
  Future<List<TransactionModel>> getTransactionsByStatus(String status) async {
    return _queryAdapter.queryList(
        'SELECT * FROM transaction WHERE status = ?1 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => TransactionModel(
            id: row['id'] as int?,
            invoiceNumber: row['invoiceNumber'] as String,
            totalAmount: row['totalAmount'] as double,
            totalDiscount: row['totalDiscount'] as double,
            globalDiscount: row['globalDiscount'] as double,
            paymentMethod: row['paymentMethod'] as String,
            cashierName: row['cashierName'] as String,
            status: row['status'] as String,
            voidReason: row['voidReason'] as String?),
        arguments: [status]);
  }

  @override
  Future<List<TransactionModel>> getTransactionsByCashier(
      String cashierName) async {
    return _queryAdapter.queryList(
        'SELECT * FROM transaction WHERE cashier_name = ?1 ORDER BY date DESC',
        mapper: (Map<String, Object?> row) => TransactionModel(
            id: row['id'] as int?,
            invoiceNumber: row['invoiceNumber'] as String,
            totalAmount: row['totalAmount'] as double,
            totalDiscount: row['totalDiscount'] as double,
            globalDiscount: row['globalDiscount'] as double,
            paymentMethod: row['paymentMethod'] as String,
            cashierName: row['cashierName'] as String,
            status: row['status'] as String,
            voidReason: row['voidReason'] as String?),
        arguments: [cashierName]);
  }

  @override
  Future<List<TransactionModel>> getRecentTransactions(int limit) async {
    return _queryAdapter.queryList(
        'SELECT * FROM transaction ORDER BY date DESC LIMIT ?1',
        mapper: (Map<String, Object?> row) => TransactionModel(
            id: row['id'] as int?,
            invoiceNumber: row['invoiceNumber'] as String,
            totalAmount: row['totalAmount'] as double,
            totalDiscount: row['totalDiscount'] as double,
            globalDiscount: row['globalDiscount'] as double,
            paymentMethod: row['paymentMethod'] as String,
            cashierName: row['cashierName'] as String,
            status: row['status'] as String,
            voidReason: row['voidReason'] as String?),
        arguments: [limit]);
  }

  @override
  Future<double?> getTotalRevenue() async {
    return _queryAdapter.query(
        'SELECT SUM(total_amount) FROM transaction WHERE status = \"completed\"',
        mapper: (Map<String, Object?> row) => row.values.first as double);
  }

  @override
  Future<double?> getRevenueByDateRange(
    int startMillis,
    int endMillis,
  ) async {
    return _queryAdapter.query(
        'SELECT SUM(total_amount) FROM transaction WHERE status = \"completed\" AND date >= ?1 AND date <= ?2',
        mapper: (Map<String, Object?> row) => row.values.first as double,
        arguments: [startMillis, endMillis]);
  }

  @override
  Future<int?> getTotalTransactions() async {
    return _queryAdapter.query(
        'SELECT COUNT(*) FROM transaction WHERE status = \"completed\"',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<int> insertTransaction(TransactionModel transaction) {
    return _transactionModelInsertionAdapter.insertAndReturnId(
        transaction, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTransaction(TransactionModel transaction) async {
    await _transactionModelUpdateAdapter.update(
        transaction, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTransaction(TransactionModel transaction) async {
    await _transactionModelDeletionAdapter.delete(transaction);
  }
}

class _$TransactionItemDao extends TransactionItemDao {
  _$TransactionItemDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _transactionItemModelInsertionAdapter = InsertionAdapter(
            database,
            'transaction_items',
            (TransactionItemModel item) => <String, Object?>{
                  'id': item.id,
                  'transactionId': item.transactionId,
                  'productId': item.productId,
                  'productName': item.productName,
                  'quantity': item.quantity,
                  'originalPrice': item.originalPrice,
                  'discountPrice': item.discountPrice,
                  'subtotal': item.subtotal
                }),
        _transactionItemModelUpdateAdapter = UpdateAdapter(
            database,
            'transaction_items',
            ['id'],
            (TransactionItemModel item) => <String, Object?>{
                  'id': item.id,
                  'transactionId': item.transactionId,
                  'productId': item.productId,
                  'productName': item.productName,
                  'quantity': item.quantity,
                  'originalPrice': item.originalPrice,
                  'discountPrice': item.discountPrice,
                  'subtotal': item.subtotal
                }),
        _transactionItemModelDeletionAdapter = DeletionAdapter(
            database,
            'transaction_items',
            ['id'],
            (TransactionItemModel item) => <String, Object?>{
                  'id': item.id,
                  'transactionId': item.transactionId,
                  'productId': item.productId,
                  'productName': item.productName,
                  'quantity': item.quantity,
                  'originalPrice': item.originalPrice,
                  'discountPrice': item.discountPrice,
                  'subtotal': item.subtotal
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TransactionItemModel>
      _transactionItemModelInsertionAdapter;

  final UpdateAdapter<TransactionItemModel> _transactionItemModelUpdateAdapter;

  final DeletionAdapter<TransactionItemModel>
      _transactionItemModelDeletionAdapter;

  @override
  Future<List<TransactionItemModel>> getAllTransactionItems() async {
    return _queryAdapter.queryList(
        'SELECT * FROM transaction_items ORDER BY id DESC',
        mapper: (Map<String, Object?> row) => TransactionItemModel(
            id: row['id'] as int?,
            transactionId: row['transactionId'] as int,
            productId: row['productId'] as int?,
            productName: row['productName'] as String,
            quantity: row['quantity'] as int,
            originalPrice: row['originalPrice'] as double,
            discountPrice: row['discountPrice'] as double?,
            subtotal: row['subtotal'] as double));
  }

  @override
  Future<TransactionItemModel?> getTransactionItemById(int id) async {
    return _queryAdapter.query('SELECT * FROM transaction_items WHERE id = ?1',
        mapper: (Map<String, Object?> row) => TransactionItemModel(
            id: row['id'] as int?,
            transactionId: row['transactionId'] as int,
            productId: row['productId'] as int?,
            productName: row['productName'] as String,
            quantity: row['quantity'] as int,
            originalPrice: row['originalPrice'] as double,
            discountPrice: row['discountPrice'] as double?,
            subtotal: row['subtotal'] as double),
        arguments: [id]);
  }

  @override
  Future<List<TransactionItemModel>> getItemsByTransactionId(
      int transactionId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM transaction_items WHERE transaction_id = ?1',
        mapper: (Map<String, Object?> row) => TransactionItemModel(
            id: row['id'] as int?,
            transactionId: row['transactionId'] as int,
            productId: row['productId'] as int?,
            productName: row['productName'] as String,
            quantity: row['quantity'] as int,
            originalPrice: row['originalPrice'] as double,
            discountPrice: row['discountPrice'] as double?,
            subtotal: row['subtotal'] as double),
        arguments: [transactionId]);
  }

  @override
  Future<List<TransactionItemModel>> getItemsByProductId(int productId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM transaction_items WHERE product_id = ?1',
        mapper: (Map<String, Object?> row) => TransactionItemModel(
            id: row['id'] as int?,
            transactionId: row['transactionId'] as int,
            productId: row['productId'] as int?,
            productName: row['productName'] as String,
            quantity: row['quantity'] as int,
            originalPrice: row['originalPrice'] as double,
            discountPrice: row['discountPrice'] as double?,
            subtotal: row['subtotal'] as double),
        arguments: [productId]);
  }

  @override
  Future<void> deleteItemsByTransactionId(int transactionId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM transaction_items WHERE transaction_id = ?1',
        arguments: [transactionId]);
  }

  @override
  Future<int?> getTotalItemsSold() async {
    return _queryAdapter.query('SELECT SUM(quantity) FROM transaction_items',
        mapper: (Map<String, Object?> row) => row.values.first as int);
  }

  @override
  Future<double?> getTotalSubtotal() async {
    return _queryAdapter.query('SELECT SUM(subtotal) FROM transaction_items',
        mapper: (Map<String, Object?> row) => row.values.first as double);
  }

  @override
  Future<int> insertTransactionItem(TransactionItemModel item) {
    return _transactionItemModelInsertionAdapter.insertAndReturnId(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<void> insertTransactionItems(List<TransactionItemModel> items) async {
    await _transactionItemModelInsertionAdapter.insertList(
        items, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateTransactionItem(TransactionItemModel item) async {
    await _transactionItemModelUpdateAdapter.update(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteTransactionItem(TransactionItemModel item) async {
    await _transactionItemModelDeletionAdapter.delete(item);
  }
}

class _$StoreProfileDao extends StoreProfileDao {
  _$StoreProfileDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _storeProfileModelInsertionAdapter = InsertionAdapter(
            database,
            'store_profile',
            (StoreProfileModel item) => <String, Object?>{
                  'id': item.id,
                  'storeName': item.storeName,
                  'address': item.address,
                  'phone': item.phone,
                  'email': item.email,
                  'logoPath': item.logoPath,
                  'footerNote': item.footerNote,
                  'taxNumber': item.taxNumber,
                  'themeColor': item.themeColor,
                  'isDarkMode': item.isDarkMode
                }),
        _storeProfileModelUpdateAdapter = UpdateAdapter(
            database,
            'store_profile',
            ['id'],
            (StoreProfileModel item) => <String, Object?>{
                  'id': item.id,
                  'storeName': item.storeName,
                  'address': item.address,
                  'phone': item.phone,
                  'email': item.email,
                  'logoPath': item.logoPath,
                  'footerNote': item.footerNote,
                  'taxNumber': item.taxNumber,
                  'themeColor': item.themeColor,
                  'isDarkMode': item.isDarkMode
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<StoreProfileModel> _storeProfileModelInsertionAdapter;

  final UpdateAdapter<StoreProfileModel> _storeProfileModelUpdateAdapter;

  @override
  Future<StoreProfileModel?> getStoreProfile() async {
    return _queryAdapter.query('SELECT * FROM store_profile WHERE id = 1',
        mapper: (Map<String, Object?> row) => StoreProfileModel(
            id: row['id'] as int,
            storeName: row['storeName'] as String?,
            address: row['address'] as String?,
            phone: row['phone'] as String?,
            email: row['email'] as String?,
            logoPath: row['logoPath'] as String?,
            footerNote: row['footerNote'] as String?,
            taxNumber: row['taxNumber'] as String?,
            themeColor: row['themeColor'] as String?,
            isDarkMode: row['isDarkMode'] as int));
  }

  @override
  Future<void> insertStoreProfile(StoreProfileModel profile) async {
    await _storeProfileModelInsertionAdapter.insert(
        profile, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateStoreProfile(StoreProfileModel profile) async {
    await _storeProfileModelUpdateAdapter.update(
        profile, OnConflictStrategy.abort);
  }
}
