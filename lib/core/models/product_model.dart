import 'package:multi_vendor_e_commerce_app/core/models/store_model.dart';
import 'package:multi_vendor_e_commerce_app/core/models/wish_list_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'rate_model.dart';

class ProductModel {
  final String id;
  final String arabicName;
  final int? boughtTimes;
  final String englishName;
  final String arabicDescription;
  final String englishDescription;
  final String? sub_category_id;
  final double price;
  final double weight;
  final double? oldPrice;
  final bool isShow;
  final int quantity;
  final String storeId;
  final List<WishlistModel> wishlists;
  final StoreModel store;
  final List<RateModel> rates;
  final String createdAt;
  // final List<CommentModel> comments;
  final List<ProductImage> productImages;
  final bool isFlash; // New field for flash deal status
  final DateTime? flashEndTime; // New field for flash deal end time

  ProductModel({
    required this.createdAt,
    required this.id,
    required this.arabicName,
    this.boughtTimes,
    required this.englishName,
    required this.arabicDescription,
    required this.englishDescription,
    required this.sub_category_id,
    required this.price,
    required this.weight,
    this.oldPrice,
    required this.isShow,
    required this.quantity,
    required this.storeId,
    required this.wishlists,
    required this.store,
    required this.rates,
    // required this.comments,
    required this.productImages,
    this.isFlash = false, // Default to false
    this.flashEndTime,
  });

  double get averageRate {
    if (rates.isEmpty) return 0.0;
    double sum = rates.fold(0.0, (total, rate) => total + rate.rate);
    return sum / rates.length;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'arabic_name': arabicName,
      'bought_times': boughtTimes,
      'english_name': englishName,
      'arabic_description': arabicDescription,
      'english_description': englishDescription,
      'sub_category_id': sub_category_id,
      'price': price,
      'weight': weight,
      'old_price': oldPrice,
      'is_show': isShow,
      'quantity': quantity,
      'store_id': storeId,
      'wishlists': wishlists.map((e) => e.toJson()).toList(),
      'stores': store.toJson(),
      'rates': rates.map((e) => e.toJson()).toList(),
      // 'comments': comments.map((e) => e.toJson()).toList(),
      'product_images': productImages.map((e) => e.toJson()).toList(),
      'is_flash': isFlash,
      // Serialize isFlash
      'flash_end_time': flashEndTime?.toIso8601String(),
      // Serialize flashEndTime
    };
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      createdAt: json['created_at'],
      arabicName: json['arabic_name'],
      boughtTimes: json['bought_times'],
      englishName: json['english_name'],
      arabicDescription: json['arabic_description'],
      englishDescription: json['english_description'],
      sub_category_id: json['sub_category_id']??null,
      price: (json['price'] as num).toDouble(),
      weight: (json['weight'] as num).toDouble(),
      oldPrice: json['old_price'] != null
          ? (json['old_price'] as num).toDouble()
          : null,
      isShow: json['is_show'],
      quantity: json['quantity'],
      storeId: json['store_id'],
      wishlists:
      (json['wishlists'] as List?)
          ?.map((e) => WishlistModel.fromJson(e))
          .toList() ??
          [],
      store: StoreModel.fromJson(
        json['stores'],
        currentUserId: Supabase.instance.client.auth.currentUser?.id??'00000000-0000-0000-0000-000000000000',
      ),
      rates:
      (json['rates'] as List?)
          ?.map((e) => RateModel.fromJson(e))
          .toList() ??
          [],
      // comments:
      //     (json['comments'] as List?)
      //         ?.map((e) => CommentModel.fromJson(e))
      //         .toList() ??
      //     [],
      productImages:
      (json['product_images'] as List?)
          ?.map((e) => ProductImage.fromJson(e))
          .toList() ??
          [],
      isFlash: json['is_flash'] ?? false,
      // Default to false if not provided
      flashEndTime: json['flash_end_time'] != null
          ? DateTime.parse(json['flash_end_time'])
          : null, // Parse flashEndTime
    );
  }

  ProductModel copyWith({
    String? id,
    String? arabicName,
    int? boughtTimes,
    String? englishName,
    String? arabicDescription,
    String? englishDescription,
    String? sub_category_id,
    double? price,
    double? weight,
    double? oldPrice,
    bool? isShow,
    int? quantity,
    String? storeId,
    List<WishlistModel>? wishlists,
    StoreModel? store,
    List<RateModel>? rates,
    String? createdAt,
    // List<CommentModel>? comments,
    List<ProductImage>? productImages,
    bool? isFlash, // Add isFlash to copyWith
    DateTime? flashEndTime, // Add flashEndTime to copyWith
  }) {
    return ProductModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      arabicName: arabicName ?? this.arabicName,
      boughtTimes: boughtTimes ?? this.boughtTimes,
      englishName: englishName ?? this.englishName,
      arabicDescription: arabicDescription ?? this.arabicDescription,
      englishDescription: englishDescription ?? this.englishDescription,
      sub_category_id: sub_category_id ?? this.sub_category_id,
      price: price ?? this.price,
      weight: weight ?? this.weight,
      oldPrice: oldPrice ?? this.oldPrice,
      isShow: isShow ?? this.isShow,
      quantity: quantity ?? this.quantity,
      storeId: storeId ?? this.storeId,
      wishlists: wishlists ?? this.wishlists,
      store: store ?? this.store,
      rates: rates ?? this.rates,
      // comments: comments ?? this.comments,
      productImages: productImages ?? this.productImages,
      isFlash: isFlash ?? this.isFlash,
      // Use provided or existing isFlash
      flashEndTime:
      flashEndTime ??
          this.flashEndTime, // Use provided or existing flashEndTime
    );
  }
  RateModel? get myRate {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    if (currentUserId == null) return null;
    try {
      return rates.firstWhere((r) => r.userId == currentUserId);
    } catch (e) {
      return null;
    }
  }


// CommentModel? get myComment {
//   final currentUserId = Supabase.instance.client.auth.currentUser?.id;
//   if (currentUserId == null) return null;
//   return comments.firstWhere(
//         (c) => c.userId == currentUserId,
//     orElse: () => CommentModel(
//       id: '',
//       comment: '',
//       replay: null,
//       userId: currentUserId,
//       userName: 'أنا',
//       productId: id,
//       createdAt: DateTime.now().toIso8601String(),
//     ),
//   );
// }
}

class ProductImage {
  final String id;
  final String imageUrl;
  final String createdAt;
  final String productId;
  final String? deleteImageUrl;

  ProductImage({
    required this.id,
    required this.imageUrl,
    required this.createdAt,
    required this.productId,
    this.deleteImageUrl,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image_url': imageUrl,
      'created_at': createdAt,
      'product_id': productId,
      'delete_image_url': deleteImageUrl,
    };
  }

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      imageUrl: json['image_url'],
      createdAt: json['created_at'],
      productId: json['product_id'],
      deleteImageUrl: json['delete_image_url'],
    );
  }


}
