
class RateModel {
  final String id;
  final double rate;
  final String userId;
  final String? replay;
  final String? comment;
  final String productId;
  final DateTime createdAt;
  final String userName;

  RateModel( {
    required this.userName,
    required this.replay,required this.comment,
    required this.id,
    required this.rate,
    required this.userId,
    required this.productId,
    required this.createdAt,
  });
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rate': rate,
      'user_id': userId,
      'product_id': productId,
      'created_at': createdAt.toIso8601String(),
      'comment': comment,
      'replay': replay
    };
  }


  factory RateModel.fromJson(Map<String, dynamic> json) {
    return RateModel(
      id: json['id'],
      rate: (json['rate'] as num).toDouble(),
      userId: json['user_id'],
      productId: json['product_id'],
      createdAt: DateTime.parse(json['created_at']), replay: json['replay'], comment: json['comment'], userName: json['users']['name'],
    );
  }
}
