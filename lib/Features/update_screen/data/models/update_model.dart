import 'package:meta/meta.dart';

@immutable
class UpdateModel {
  final String id;
  final DateTime createdAt;
  final bool isHaveUpdate;
  final String downloadUrl;
  final String version;
  final bool isUnderMaintenance; // الجديد

  const UpdateModel({
    required this.id,
    required this.createdAt,
    required this.isHaveUpdate,
    required this.downloadUrl,
    required this.version,
    required this.isUnderMaintenance,
  });

  UpdateModel copyWith({
    String? id,
    DateTime? createdAt,
    bool? isHaveUpdate,
    String? downloadUrl,
    bool? isUnderMaintenance,
  }) {
    return UpdateModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      isHaveUpdate: isHaveUpdate ?? this.isHaveUpdate,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      version: version ?? this.version,
      isUnderMaintenance: isUnderMaintenance ?? this.isUnderMaintenance,
    );
  }

  factory UpdateModel.fromJson(Map<String, dynamic> json,{required bool isHaveUpdate,required String downloadUrl,}) {
    return UpdateModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      isHaveUpdate: isHaveUpdate,
      downloadUrl: downloadUrl,
      version: json['ios_version'] as String,
      isUnderMaintenance: json['ios_is_under_maintenance'] as bool, // الجديد
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toUtc().toIso8601String(),
      'ios_isHaveUpdate': isHaveUpdate,
      'ios_download_url': downloadUrl,
      'version': version,
      'ios_is_under_maintenance': isUnderMaintenance, // الجديد
    };
  }

  @override
  String toString() {
    return 'UpdateModel(id: $id, createdAt: $createdAt, isHaveUpdate: $isHaveUpdate, downloadUrl: $downloadUrl, isUnderMaintenance: $isUnderMaintenance)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateModel &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.isHaveUpdate == isHaveUpdate &&
        other.downloadUrl == downloadUrl &&
        other.version == version &&
        other.isUnderMaintenance == isUnderMaintenance;
  }

  @override
  int get hashCode => Object.hash(id, createdAt, isHaveUpdate, downloadUrl, version, isUnderMaintenance);
}
