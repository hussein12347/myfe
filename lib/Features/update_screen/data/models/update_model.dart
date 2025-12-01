// DownloadModel.dart
// Generated for the JSON you provided.

import 'package:meta/meta.dart';

@immutable
class UpdateModel {
  final String id;
  final DateTime createdAt;
  final String version;
  final String downloadUrl;

  const UpdateModel({
    required this.id,
    required this.createdAt,
    required this.version,
    required this.downloadUrl,
  });

  UpdateModel copyWith({
    String? id,
    DateTime? createdAt,
    String? version,
    String? downloadUrl,
  }) {
    return UpdateModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      version: version ?? this.version,
      downloadUrl: downloadUrl ?? this.downloadUrl,
    );
  }

  factory UpdateModel.fromJson(Map<String, dynamic> json) {
    return UpdateModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      version: json['version'] as String,
      downloadUrl: json['download_url'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toUtc().toIso8601String(),
      'version': version,
      'download_url': downloadUrl,
    };
  }

  @override
  String toString() {
    return 'DownloadModel(id: \$id, createdAt: \$createdAt, version: \$version, downloadUrl: \$downloadUrl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UpdateModel &&
        other.id == id &&
        other.createdAt == createdAt &&
        other.version == version &&
        other.downloadUrl == downloadUrl;
  }

  @override
  int get hashCode => Object.hash(id, createdAt, version, downloadUrl);
}

// Helpers:
// - Parse a list of maps: jsonList.map((m) => DownloadModel.fromJson(m)).toList();
// - Convert to json list: models.map((m) => m.toJson()).toList();

// Example (commented):
// final model = DownloadModel.fromJson(jsonMap);
// final json = model.toJson();
