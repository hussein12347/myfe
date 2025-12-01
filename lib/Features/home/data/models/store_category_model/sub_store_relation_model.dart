class StoreSubCategoryRelationModel {
  final String id;
  final String storeId;
  final String subCategoryId;

  StoreSubCategoryRelationModel({
    required this.id,
    required this.storeId,
    required this.subCategoryId,
  });

  factory StoreSubCategoryRelationModel.fromJson(Map<String, dynamic> json) {
    return StoreSubCategoryRelationModel(
      id: json['id'] ?? '',
      storeId: json['store_id'] ?? '',
      subCategoryId: json['sub_category_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'sub_category_id': subCategoryId,
    };
  }
}