class StoreBranchModel {
  final String id;
  final double lat;
  final double log;
  final String storeId;
  final DateTime createdAt;

  StoreBranchModel({
    required this.id,
    required this.lat,
    required this.log,
    required this.storeId,
    required this.createdAt,
  });

  factory StoreBranchModel.fromJson(Map<String, dynamic> json) {
    return StoreBranchModel(
      id: json['id'] ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      log: (json['log'] as num?)?.toDouble() ?? 0.0,
      storeId: json['store_id'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'lat': lat,
      'log': log,
      'store_id': storeId,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
