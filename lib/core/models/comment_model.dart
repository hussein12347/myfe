// class CommentModel {
//   final String id;
//   final String comment;
//   final String? replay;
//   final String userId;
//   final String userName;
//   final String productId;
//   final String createdAt;
//
//   CommentModel({
//     required this.id,
//     required this.comment,
//     this.replay,
//     required this.userId,
//     required this.userName,
//     required this.productId,
//     required this.createdAt,
//   });
//
//   factory CommentModel.fromJson(Map<String, dynamic> json) {
//     return CommentModel(
//       id: json['id'],
//       comment: json['comment'],
//       replay: json['replay'],
//       userId: json['user_id'],
//       userName: json['user_name'],
//       productId: json['product_id'],
//       createdAt: json['created_at'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'comment': comment,
//       'replay': replay,
//       'user_id': userId,
//       'user_name': userName,
//       'product_id': productId,
//       'created_at': createdAt,
//     };
//   }
// }
