import 'package:uuid/uuid.dart';
import 'package:multi_vendor_e_commerce_app/core/models/product_model.dart';

class LocalOrderModel {
  final String id; // UUID للطلب
  final String userId; // صاحب الطلب
  final String storeId; // المتجر
  final int number; // رقم الطلب التسلسلي
  final int status; // حالة الطلب (0: pending, 1: confirmed, ...)
  final DateTime createdAt; // وقت إنشاء الطلب
  final List<LocalOrderItem> localOrderItems; // العناصر

  LocalOrderModel({
    String? id,
    required this.userId,
    required this.storeId,
    required this.number,
    this.status = 0,
    DateTime? createdAt,
    this.localOrderItems = const [],
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  // تحويل الحالة لنص
  String get statusString {
    switch (status) {
      case 0:
        return 'pending';
      case 1:
        return 'confirmed';
      case 2:
        return 'canceled';
      default:
        return 'unknown';
    }
  }
  double get totalPrice {
    return localOrderItems.fold(
      0.0,
          (sum, item) => sum + (item.price ),
    );
  }

  // fromJson
  factory LocalOrderModel.fromJson(Map<String, dynamic> json) {
    return LocalOrderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      storeId: json['store_id'] as String,
      number: json['number'] as int,
      status: json['status'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      localOrderItems: (json['local_order_items'] as List<dynamic>? ?? [])
          .map((item) => LocalOrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'store_id': storeId,
      'number': number,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'local_order_items':
      localOrderItems.map((item) => item.toJson()).toList(),
    };
  }
}

class LocalOrderItem {
  final String id; // UUID للعنصر
  final double price; // سعر العنصر
  final int quantity; // الكمية
  final String orderId; // الطلب التابع له
  final String productId; // معرف المنتج
  final ProductModel product; // تفاصيل المنتج
  final DateTime createdAt;

  LocalOrderItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.orderId,
    required this.productId,
    required this.product,
    required this.createdAt,
  });

  // fromJson
  factory LocalOrderItem.fromJson(Map<String, dynamic> json) {
    return LocalOrderItem(
      id: json['id'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      product: ProductModel.fromJson(json['products'] as Map<String, dynamic>),
    );
  }

  // toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'quantity': quantity,
      'order_id': orderId,
      'product_id': productId,
      'created_at': createdAt.toIso8601String(),
      'products': product.toJson(),
    };
  }
}
