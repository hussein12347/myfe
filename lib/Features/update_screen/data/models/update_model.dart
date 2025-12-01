import 'package:meta/meta.dart';

@immutable
class UpdateModel {
  final String id;
  final DateTime createdAt;
  final String version;
  final String downloadUrl;
  final bool isUnderMaintenance; // الجديد

  const UpdateModel({
    required this.id,
    required this.createdAt,
    required this.version,
    required this.downloadUrl,
    required this.isUnderMaintenance,
  });

  UpdateModel copyWith({
    String? id,
    DateTime? createdAt,
    String? version,
    String? downloadUrl,
    bool? isUnderMaintenance,
  }) {
    return UpdateModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      version: version ?? this.version,
      downloadUrl: downloadUrl ?? this.downloadUrl,
      isUnderMaintenance: isUnderMaintenance ?? this.isUnderMaintenance,
    );
  }

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    return UpdateModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      version: json['ios_version'] as String,
      downloadUrl: json['ios_download_url'] as String,
      isUnderMaintenance: json['ios_is_under_maintenance'] as bool, // الجديد
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toUtc().toIso8601String(),
      'ios_version': version,
      'ios_download_url': downloadUrl,
      'ios_is_under_maintenance': isUnderMaintenance, // الجديد
    };
  }

  @override
  String toString() {
    return 'UpdateModel(id: $id, createdAt: $createdAt, version: $version, downloadUrl: $downloadUrl, isUnderMaintenance: $isUnderMaintenance)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateModel &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.version == version &&
        other.downloadUrl == downloadUrl &&
        other.isUnderMaintenance == isUnderMaintenance;
  }

  @override
  int get hashCode => Object.hash(id, createdAt, version, downloadUrl, isUnderMaintenance);
}
