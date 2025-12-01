import 'package:multi_vendor_e_commerce_app/Features/home/data/models/store_category_model/sub_store_category.dart';
import 'package:multi_vendor_e_commerce_app/core/models/store_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoreCategory {
  final String id;
  final DateTime createdAt;
  final String arabicName;
  final String englishName;
  final String logoUrl;
  final String? deleteLogoUrl;
  final bool isShow;
  final List<StoreModel> stores;
  final List<SubStoreCategory> storeSubCategory;

  StoreCategory({
    required this.id,
    required this.createdAt,
    required this.arabicName,
    required this.englishName,
    required this.logoUrl,
    this.deleteLogoUrl,
    required this.isShow,
    required this.stores,
    required this.storeSubCategory,
  });

  factory StoreCategory.fromJson(Map<String, dynamic> json) {
    return StoreCategory(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      arabicName: json['arabic_name'],
      englishName: json['english_name'],
      logoUrl: json['logo_url'],
      deleteLogoUrl: json['delete_logo_url'],
      isShow: json['is_show'],
      stores: (json['stores'] as List)
          .map((store) => StoreModel.fromJson(store, currentUserId: Supabase.instance.client.auth.currentUser?.id))
          .toList(),
      storeSubCategory: (json['store_sub_category'] as List)
          .map((subCategory) => SubStoreCategory.fromJson(subCategory))
          .toList(),
    );
  }

  StoreCategory copyWith({
    String? id,
    DateTime? createdAt,
    String? arabicName,
    String? englishName,
    String? logoUrl,
    String? deleteLogoUrl,
    bool? isShow,
    List<StoreModel>? stores,
    List<SubStoreCategory>? storeSubCategory,
  }) {
    return StoreCategory(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      arabicName: arabicName ?? this.arabicName,
      englishName: englishName ?? this.englishName,
      logoUrl: logoUrl ?? this.logoUrl,
      deleteLogoUrl: deleteLogoUrl ?? this.deleteLogoUrl,
      isShow: isShow ?? this.isShow,
      stores: stores ?? this.stores,
      storeSubCategory: storeSubCategory ?? this.storeSubCategory,
    );
  }
}


