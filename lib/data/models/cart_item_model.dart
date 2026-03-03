import 'package:my_kasir/data/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  int quantity;

  CartItemModel({
    required this.product,
    this.quantity = 1,
  });

  double get unitPrice => product.finalPrice;
  double get totalPrice => unitPrice * quantity;
  double get discountAmount => (product.originalPrice - unitPrice) * quantity;

  CartItemModel copyWith({ProductModel? product, int? quantity}) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  CartItemModel incrementQuantity() {
    return CartItemModel(product: product, quantity: quantity + 1);
  }

  CartItemModel decrementQuantity() {
    return CartItemModel(product: product, quantity: quantity > 1 ? quantity - 1 : 0);
  }
}
