import 'package:multi_vendor_e_commerce_app/core/models/store_branch_model.dart';

import '../../Features/home/data/models/store_category_model/sub_store_relation_model.dart';
import 'favorite_store_model.dart';

import 'package:multi_vendor_e_commerce_app/core/models/store_branch_model.dart';
import 'favorite_store_model.dart';
// تأكد من عمل import للموديل الجديد إذا كان في ملف منفصل
// import 'store_sub_category_relation_model.dart';

class StoreModel {
  final String id;
  final String arabic_name;
  final String english_name;
  final String imageUrl;
  final String arabic_description;
  final String english_description;
  final String? deleteImageUrl;
  final DateTime createdAt;
  final bool isShow;
  final String userId;
  final String? email;
  final String? password;
  final String? webSite;
  final String? facebook;
  final String? address;
  final String? img_url_menu_for_resturant;
  final String? insta;
  final String? ticTok;
  final String? hotline;
  final String? whatsapp;
  final String? storeCategoryId;


  // ✅ التعديل الجديد: قائمة الفئات الفرعية
  final List<StoreSubCategoryRelationModel> storeSubCategoryRelations;

  final double? userRating;
  final List<FavoriteStoreModel> favoriteStores;
  final double log;
  final double lat;
  final List<StoreBranchModel> storeBranches;
  final double? deliveryPricePerKmPerKg;
  final double? deliveryPriceStatic;

  StoreModel({
    required this.storeBranches,
    required this.log,
    required this.lat,
    required this.id,
    required this.arabic_name,
    required this.english_name,
    required this.imageUrl,
    required this.arabic_description,
    required this.english_description,
    required this.userId,
    required this.createdAt,
    required this.isShow,
    this.deleteImageUrl,
    this.email,
    this.password,
    this.webSite,
    this.facebook,
    this.address,
    this.img_url_menu_for_resturant,
    this.insta,
    this.ticTok,
    this.hotline,
    this.whatsapp,
    this.storeCategoryId,
    required this.storeSubCategoryRelations, // ✅ إضافة للقائمة
    required this.userRating,
    required this.favoriteStores,
    this.deliveryPricePerKmPerKg,
    this.deliveryPriceStatic,
  });

  factory StoreModel.fromJson(Map<String, dynamic> json, {required String? currentUserId}) {
    final reviews = (json['store_reviews'] ?? []) as List;
    double? userRating;
    for (var review in reviews) {
      final rating = (review['rating'] ?? 0).toDouble();
      if (currentUserId != null && review['user_id'] == currentUserId) {
        userRating = rating;
        break;
      }
    }

    return StoreModel(
      id: json['id'] ?? '',
      storeBranches: (json['store_branches'] as List? ?? [])
          .map((e) => StoreBranchModel.fromJson(e))
          .toList(),
      // ✅ قراءة قائمة العلاقات من الـ JSON
      storeSubCategoryRelations: (json['store_sub_category_relation'] as List? ?? [])
          .map((e) => StoreSubCategoryRelationModel.fromJson(e))
          .toList(),
      arabic_name: json['arabic_name'] ?? '',
      english_name: json['english_name'] ?? '',
      imageUrl: json['image_url'] ?? '',
      arabic_description: json['arabic_description'] ?? '',
      english_description: json['english_description'] ?? '',
      userId: json['user_id'] ?? '',
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      isShow: json['is_show'] ?? true,
      deleteImageUrl: json['delete_image_url'],
      email: json['email'],
      password: json['password'],
      webSite: json['web_site'],
      facebook: json['facebook'],
      address: json['address'],
      img_url_menu_for_resturant: json['img_url_menu_for_resturant'],
      insta: json['insta'],
      ticTok: json['tic_tok'],
      hotline: json['hotline'],
      whatsapp: json['whatsapp'],
      storeCategoryId: json['store_category_id'],
      userRating: userRating,
      favoriteStores: (json['favorites_stores'] as List?)
          ?.map((e) => FavoriteStoreModel.fromJson(e))
          .toList() ??
          [],
      lat: (json['lat'] ?? 0.0).toDouble(),
      log: (json['log'] ?? 0.0).toDouble(),
      deliveryPricePerKmPerKg: (json['delivery_price_per_km_per_kg'] as num?)?.toDouble(),
      deliveryPriceStatic: (json['delivery_price_static'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'arabic_name': arabic_name,
      'english_name': english_name,
      'image_url': imageUrl,
      'arabic_description': arabic_description,
      'english_description': english_description,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'is_show': isShow,
      'delete_image_url': deleteImageUrl,
      'email': email,
      'password': password,
      'web_site': webSite,
      'facebook': facebook,
      'address': address,
      'img_url_menu_for_resturant': img_url_menu_for_resturant,
      'insta': insta,
      'tic_tok': ticTok,
      'hotline': hotline,
      'whatsapp': whatsapp,
      'store_category_id': storeCategoryId,
      'lat': lat,
      'log': log,
      'store_branches': storeBranches.map((e) => e.toJson()).toList(),
      // ✅ تحويل القائمة لـ JSON
      'store_sub_category_relation': storeSubCategoryRelations.map((e) => e.toJson()).toList(),
      'delivery_price_per_km_per_kg': deliveryPricePerKmPerKg,
      'delivery_price_static': deliveryPriceStatic,
    };
  }

  StoreModel copyWith({
    String? id,
    String? arabic_name,
    String? english_name,
    String? imageUrl,
    String? arabic_description,
    String? english_description,
    String? userId,
    DateTime? createdAt,
    bool? isShow,
    String? deleteImageUrl,
    String? email,
    String? password,
    String? webSite,
    String? facebook,
    String? address,
    String? img_url_menu_for_resturant,
    String? insta,
    String? ticTok,
    String? hotline,
    String? whatsapp,
    String? storeCategoryId,
    List<StoreSubCategoryRelationModel>? storeSubCategoryRelations, // ✅
    double? userRating,
    List<FavoriteStoreModel>? favoriteStores,
    double? log,
    double? lat,
    List<StoreBranchModel>? storeBranches,
    double? deliveryPricePerKmPerKg,
    double? deliveryPriceStatic,
  }) {
    return StoreModel(
      id: id ?? this.id,
      arabic_name: arabic_name ?? this.arabic_name,
      english_name: english_name ?? this.english_name,
      imageUrl: imageUrl ?? this.imageUrl,
      arabic_description: arabic_description ?? this.arabic_description,
      english_description: english_description ?? this.english_description,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      isShow: isShow ?? this.isShow,
      deleteImageUrl: deleteImageUrl ?? this.deleteImageUrl,
      email: email ?? this.email,
      password: password ?? this.password,
      webSite: webSite ?? this.webSite,
      facebook: facebook ?? this.facebook,
      address: address ?? this.address,
      img_url_menu_for_resturant: img_url_menu_for_resturant ?? this.img_url_menu_for_resturant,
      insta: insta ?? this.insta,
      ticTok: ticTok ?? this.ticTok,
      hotline: hotline ?? this.hotline,
      whatsapp: whatsapp ?? this.whatsapp,
      storeCategoryId: storeCategoryId ?? this.storeCategoryId,
      storeSubCategoryRelations: storeSubCategoryRelations ?? this.storeSubCategoryRelations, // ✅
      userRating: userRating ?? this.userRating,
      favoriteStores: favoriteStores ?? this.favoriteStores,
      lat: lat ?? this.lat,
      log: log ?? this.log,
      storeBranches: storeBranches ?? this.storeBranches,
      deliveryPricePerKmPerKg: deliveryPricePerKmPerKg ?? this.deliveryPricePerKmPerKg,
      deliveryPriceStatic: deliveryPriceStatic ?? this.deliveryPriceStatic,
    );
  }
}