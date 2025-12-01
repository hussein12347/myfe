import 'package:uuid/uuid.dart';
import 'package:multi_vendor_e_commerce_app/core/models/product_model.dart';

class OrderModel {
  final String id; // رقم الطلب (UUID)
  final String userId; // صاحب الطلب
  final String storeId; // المتجر اللي هيتنفذ منه الطلب
  final List<OrderItem> orderItems; // عناصر الطلب
  final double totalPrice; // السعر الإجمالي
  final int status; // حالة الطلب (0: pending, 1: confirmed, 2: shipped, 3: delivered, 4: canceled)
  final DateTime createdAt; // وقت إنشاء الطلب
  final DateTime? updatedAt; // وقت آخر تحديث
  final String? name; // اسم العميل
  final String? phone; // رقم الهاتف
  final String? address; // عنوان التوصيل
  final String? addressUrl; // رابط العنوان على الخريطة
  final bool isPaid; // حالة الدفع
  final int number; // رقم الطلب (تسلسلي)
  final String? paymentMethod; // طريقة الدفع (كاش، فيزا ..)

  OrderModel({
    String? id,
    required this.userId,
    required this.storeId,
    required this.orderItems,
    required this.totalPrice,
    this.status = 0, // Default to pending
    DateTime? createdAt,
    this.updatedAt,
    this.name,
    this.phone,
    this.address,
    this.addressUrl,
    this.isPaid = false,
    required this.number,
    this.paymentMethod,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  // تحويل حالة الطلب من رقم إلى نص
  String get statusString {
    switch (status) {
      case 0:
        return 'pending';
      case 1:
        return 'confirmed';
      case 2:
        return 'shipped';
      case 3:
        return 'delivered';
      case 4:
        return 'canceled';
      default:
        return 'unknown';
    }
  }

  // من JSON
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      storeId: json['order_items'] != null && json['order_items'].isNotEmpty
          ? json['order_items'][0]['products']['store_id'] as String
          : '', // Extract store_id from first order item
      orderItems: (json['order_items'] as List<dynamic>?)
          ?.map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      addressUrl: json['address_url'] as String?,
      isPaid: json['is_paid'] as bool,
      number: json['number'] as int,
      paymentMethod: json['payment_method'] as String?,
    );
  }

  // لـ JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'store_id': storeId,
      'order_items': orderItems.map((item) => item.toJson()).toList(),
      'total_price': totalPrice,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'name': name,
      'phone': phone,
      'address': address,
      'address_url': addressUrl,
      'is_paid': isPaid,
      'number': number,
      'payment_method': paymentMethod,
    };
  }
}

class OrderItem {
  final String id; // معرف عنصر الطلب
  final double price; // سعر المنتج في الطلب
  final int quantity; // الكمية
  final String orderId; // معرف الطلب
  final String productId; // معرف المنتج
  final ProductModel product; // تفاصيل المنتج

  OrderItem({
    required this.id,
    required this.price,
    required this.quantity,
    required this.orderId,
    required this.productId,
    required this.product,
  });

  // من JSON
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      orderId: json['order_id'] as String,
      productId: json['product_id'] as String,
      product: ProductModel.fromJson(json['products'] as Map<String, dynamic>),
    );
  }

  // لـ JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price,
      'quantity': quantity,
      'order_id': orderId,
      'product_id': productId,
      'products': product.toJson(),
    };
  }
}