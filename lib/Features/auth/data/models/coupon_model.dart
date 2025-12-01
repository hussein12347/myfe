import '../../../../core/models/company_model.dart';

class CodeModel {
  final String id;
  final DateTime createdAt;
  final String code;
  final String companyId;
  final bool isForEmployee;
  final CompanyModel company;

  CodeModel({
    required this.id,
    required this.createdAt,
    required this.code,
    required this.companyId,
    required this.isForEmployee,
    required this.company,
  });

  factory CodeModel.fromJson(Map<String, dynamic> json) {
    return CodeModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      code: json['code'],
      companyId: json['company_id'],
      isForEmployee: json['is_for_employee'],
      company: CompanyModel.fromJson(json['companies']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'created_at': createdAt.toIso8601String(),
    'code': code,
    'company_id': companyId,
    'is_for_employee': isForEmployee,
    'companies': company.toJson(),
  };

  static List<CodeModel> listFromJson(List<dynamic> json) {
    return json.map((e) => CodeModel.fromJson(e)).toList();
  }
}
