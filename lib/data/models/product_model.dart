import 'package:floor/floor.dart';

@Entity(
  tableName: 'products',
  indices: [
    Index(value: ['name']),
    Index(value: ['sku'], unique: true),
    Index(value: ['category_id']),
    Index(value: ['is_deleted']),
  ],
)
class ProductModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  @ColumnInfo(name: 'category_id')
  final int categoryId;

  final String name;

  final String? sku;
  final int stock;
  final double? costPrice;
  final double originalPrice;
  final double? discountPrice;
  final double? discountPercentage;
  final String? imagePath;

  @ColumnInfo(name: 'is_active')
  final int isActive;

  @ColumnInfo(name: 'is_deleted')
  final int isDeleted;

  @ColumnInfo(name: 'deleted_at')
  final int? deletedAtMillis;

  @ColumnInfo(name: 'created_at')
  final int createdAtMillis;

  @ColumnInfo(name: 'updated_at')
  final int updatedAtMillis;

  // Getters for convenience
  bool get isActiveBool => isActive == 1;
  bool get isDeletedBool => isDeleted == 1;
  DateTime? get deletedAt => deletedAtMillis != null
      ? DateTime.fromMillisecondsSinceEpoch(deletedAtMillis!)
      : null;
  DateTime get createdAt =>
      DateTime.fromMillisecondsSinceEpoch(createdAtMillis);
  DateTime get updatedAt =>
      DateTime.fromMillisecondsSinceEpoch(updatedAtMillis);

  // Computed properties
  double get finalPrice {
    if (discountPrice != null && discountPrice! > 0) {
      return discountPrice!;
    }
    return originalPrice;
  }

  bool get hasDiscount =>
      discountPrice != null &&
      discountPrice! > 0 &&
      discountPrice! < originalPrice;

  ProductModel({
    this.id,
    required this.categoryId,
    required this.name,
    this.sku,
    this.stock = 0,
    this.costPrice,
    required this.originalPrice,
    this.discountPrice,
    this.discountPercentage,
    this.imagePath,
    this.isActive = 1,
    this.isDeleted = 0,
    this.deletedAtMillis,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAtMillis =
           createdAt?.millisecondsSinceEpoch ??
           DateTime.now().millisecondsSinceEpoch,
       updatedAtMillis =
           updatedAt?.millisecondsSinceEpoch ??
           DateTime.now().millisecondsSinceEpoch;

  // CopyWith method
  ProductModel copyWith({
    int? id,
    int? categoryId,
    String? name,
    String? sku,
    int? stock,
    double? costPrice,
    double? originalPrice,
    double? discountPrice,
    double? discountPercentage,
    String? imagePath,
    int? isActive,
    int? isDeleted,
    int? deletedAtMillis,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      stock: stock ?? this.stock,
      costPrice: costPrice ?? this.costPrice,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      imagePath: imagePath ?? this.imagePath,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtMillis: deletedAtMillis ?? this.deletedAtMillis,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Soft delete
  ProductModel softDelete() {
    return copyWith(
      isDeleted: 1,
      deletedAtMillis: DateTime.now().millisecondsSinceEpoch,
      isActive: 0,
    );
  }

  // Calculate profit margin
  double get profitMargin {
    if (costPrice == null || costPrice! <= 0) return 0;
    return ((finalPrice - costPrice!) / finalPrice * 100);
  }
}
