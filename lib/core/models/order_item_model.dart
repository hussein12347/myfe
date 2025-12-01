import 'order_model.dart';

class OrderItemModel {
  final String id;
  final double price;
  final int quantity;
  final String orderId;
  final String productId;
  final OrderModel? order; // تقدر تعملها Model برضه لو عايز

  OrderItemModel({
    required this.id,
    required this.price,
    required this.quantity,
    required this.orderId,
    required this.productId,
    this.order,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'],
      orderId: json['order_id'],
      productId: json['product_id'],
      order: json['orders'], // ممكن تبسطها هنا أو تحولها لـ OrderModel
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'quantity': quantity,
      'order_id': orderId,
      'product_id': productId,
      'orders': order,
    };
  }
}
