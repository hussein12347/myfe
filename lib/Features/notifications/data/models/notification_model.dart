class NotificationModel {
final String id;
final DateTime createdAt;
final String title;
final String body;
final bool isRead; // New field for read status

NotificationModel({
required this.id,
required this.createdAt,
required this.title,
required this.body,
this.isRead = false, // Default to unread
});

factory NotificationModel.fromJson(Map<String, dynamic> json) {
return NotificationModel(
id: json['id'] as String,
createdAt: DateTime.parse(json['created_at'] as String),
title: json['title'] as String,
body: json['body'] as String,
isRead: json['is_read'] ?? false, // Handle backend is_read field
);
}

Map<String, dynamic> toJson() {
return {
'id': id,
'created_at': createdAt.toIso8601String(),
'title': title,
'body': body,
'is_read': isRead,
};
}

NotificationModel copyWith({
String? id,
DateTime? createdAt,
String? title,
String? body,
bool? isRead,
}) {
return NotificationModel(
id: id ?? this.id,
createdAt: createdAt ?? this.createdAt,
title: title ?? this.title,
body: body ?? this.body,
isRead: isRead ?? this.isRead,
);
}
}
