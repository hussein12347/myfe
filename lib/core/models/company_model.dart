
class CompanyModel {
  final String id;
  final DateTime createdAt;
  final String name;
  final String logoUrl;
  final String? deleteLogoUrl;
  final String themeColor; // نخليها int بدل String علشان نقدر نعملها Color

  CompanyModel({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.logoUrl,
    required this.themeColor,
    this.deleteLogoUrl,
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) {
    return CompanyModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['created_at']),
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String,
      themeColor: json['theme_color'], // "0xffDA0B14" → int
      deleteLogoUrl: json['delete_logo_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'name': name,
      'logo_url': logoUrl,
      'theme_color': themeColor,
      'delete_logo_url': deleteLogoUrl?? '',
    };
  }


}
