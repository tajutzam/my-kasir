import 'package:floor/floor.dart';

@Entity(
  tableName: 'products',
  indices: [
    Index(value: ['name']),
  ],
)
class ProductModel {
  @primaryKey
  final int? id;

  final String name;

  ProductModel({this.id, required this.name});
}
