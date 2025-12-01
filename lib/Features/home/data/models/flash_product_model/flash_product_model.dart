import 'package:multi_vendor_e_commerce_app/core/models/product_model.dart';

class FlashProductDealModel {
  final String id;
  final DateTime createdAt;
  final double durationByHour;
  final ProductModel product;

  FlashProductDealModel({
    required this.id,
    required this.createdAt,
    required this.durationByHour,
    required this.product,
  });

  factory FlashProductDealModel.fromJson(Map<String, dynamic> json) {
    return FlashProductDealModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      durationByHour: (json['duration_by_hour'] as num).toDouble(),
      product: ProductModel.fromJson(json['products'] as Map<String, dynamic>)
          .copyWith(
            isFlash: true,
            flashEndTime: DateTime.parse(
              json['created_at'] as String,
            ).add(Duration(hours: (json['duration_by_hour'] as num).toInt())),
          ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'duration_by_hour': durationByHour,
      'products': product.toJson(),
    };
  }

  FlashProductDealModel copyWith({
    String? id,
    DateTime? createdAt,
    double? durationByHour,
    ProductModel? product,
  }) {
    return FlashProductDealModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      durationByHour: durationByHour ?? this.durationByHour,
      product: product ?? this.product,
    );
  }
}
