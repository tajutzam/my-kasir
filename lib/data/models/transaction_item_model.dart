import 'package:floor/floor.dart';

@Entity(
  tableName: 'transaction_items',
  indices: [
    Index(value: ['transactionId']),
    Index(value: ['productId']),
  ],
)
class TransactionItemModel {
  @primaryKey
  final int? id;

  final int transactionId;
  final int? productId;
  final String productName;
  final int quantity;
  final double originalPrice;
  final double? discountPrice;
  final double subtotal;

  // Computed properties
  double get finalPrice => discountPrice ?? originalPrice;
  double get lineTotal => finalPrice * quantity;
  double get discountAmount => (originalPrice - finalPrice) * quantity;

  TransactionItemModel({
    this.id,
    required this.transactionId,
    this.productId,
    required this.productName,
    required this.quantity,
    required this.originalPrice,
    this.discountPrice,
    required this.subtotal,
  });

  // CopyWith method
  TransactionItemModel copyWith({
    int? id,
    int? transactionId,
    int? productId,
    String? productName,
    int? quantity,
    double? originalPrice,
    double? discountPrice,
    double? subtotal,
  }) {
    return TransactionItemModel(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPrice: discountPrice ?? this.discountPrice,
      subtotal: subtotal ?? this.subtotal,
    );
  }

  // Create from product
  factory TransactionItemModel.fromProduct({
    required int transactionId,
    required int productId,
    required String productName,
    required int quantity,
    required double originalPrice,
    double? discountPrice,
  }) {
    final finalPrice = discountPrice ?? originalPrice;
    return TransactionItemModel(
      transactionId: transactionId,
      productId: productId,
      productName: productName,
      quantity: quantity,
      originalPrice: originalPrice,
      discountPrice: discountPrice,
      subtotal: finalPrice * quantity,
    );
  }
}
