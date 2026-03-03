import 'package:floor/floor.dart';

@Entity(
  tableName: 'categories',
  indices: [
    Index(value: ['name']),
    Index(value: ['is_deleted']),
  ],
)
class CategoryModel {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final String name;

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
  DateTime get createdAt => DateTime.fromMillisecondsSinceEpoch(createdAtMillis);
  DateTime get updatedAt => DateTime.fromMillisecondsSinceEpoch(updatedAtMillis);

  CategoryModel({
    this.id,
    required this.name,
    this.isActive = 1,
    this.isDeleted = 0,
    this.deletedAtMillis,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAtMillis = createdAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch,
        updatedAtMillis = updatedAt?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;

  // CopyWith method
  CategoryModel copyWith({
    int? id,
    String? name,
    int? isActive,
    int? isDeleted,
    int? deletedAtMillis,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAtMillis: deletedAtMillis ?? this.deletedAtMillis,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  // Soft delete
  CategoryModel softDelete() {
    return copyWith(
      isDeleted: 1,
      deletedAtMillis: DateTime.now().millisecondsSinceEpoch,
      isActive: 0,
    );
  }
}
