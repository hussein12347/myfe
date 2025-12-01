import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/models/store_model.dart';

class SubStoreCategory {
  final String id;
  final DateTime createdAt;
  final String arabicName;
  final String englishName;
  final String logoUrl;
  final String? deleteLogoUrl;
  final bool isShow;
  final String storeCategoryId;
  final List<StoreModel> stores;

  SubStoreCategory({
    required this.id,
    required this.createdAt,
    required this.arabicName,
    required this.englishName,
    required this.logoUrl,
    this.deleteLogoUrl,
    required this.isShow,
    required this.storeCategoryId,
    required this.stores,
  });

  factory SubStoreCategory.fromJson(Map<String, dynamic> json) {
    return SubStoreCategory(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      arabicName: json['arabic_name'],
      englishName: json['english_name'],
      logoUrl: json['logo_url'],
      deleteLogoUrl: json['delete_logo_url'],
      isShow: json['is_show'],
      storeCategoryId: json['store_category_id'],
      stores: (json['stores'] as List)
          .map((store) => StoreModel.fromJson(store, currentUserId: Supabase.instance.client.auth.currentUser?.id))
          .toList(),
    );
  }

  SubStoreCategory copyWith({
    String? id,
    DateTime? createdAt,
    String? arabicName,
    String? englishName,
    String? logoUrl,
    String? deleteLogoUrl,
    bool? isShow,
    String? storeCategoryId,
    List<StoreModel>? stores,
  }) {
    return SubStoreCategory(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      arabicName: arabicName ?? this.arabicName,
      englishName: englishName ?? this.englishName,
      logoUrl: logoUrl ?? this.logoUrl,
      deleteLogoUrl: deleteLogoUrl ?? this.deleteLogoUrl,
      isShow: isShow ?? this.isShow,
      storeCategoryId: storeCategoryId ?? this.storeCategoryId,
      stores: stores ?? this.stores,
    );
  }
}
