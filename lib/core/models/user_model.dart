import 'company_model.dart';

class UserModel {
  final String id;
  final String name;
  final String job;
  final String email;
  final String password;
  final String role;
  final DateTime createdAt;
  final String companyId;
  final String phone;
  final String whatsappPhone;
  final double longitude;
  final double latitude;
  final String address;
  final String nationalId;
  final DateTime dateOfBirth;
  final CompanyModel company;
  final bool is_male;

  UserModel({
    required this.id,
    required this.name,
    required this.job,
    required this.email,
    required this.password,
    required this.role,
    required this.createdAt,
    required this.companyId,
    required this.phone,
    required this.whatsappPhone,
    required this.longitude,
    required this.latitude,
    required this.address,
    required this.nationalId,
    required this.dateOfBirth,
    required this.company,
    required this.is_male,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      is_male: json['is_male'],
      name: json['name'],
      job: json['job'],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
      companyId: json['company_id'],
      phone: json['phone'],
      whatsappPhone: json['whatsapp_phone'],
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      address: json['address'],
      nationalId: json['national_id'],
      dateOfBirth: DateTime.parse(json['date_of_birth']),
      company: CompanyModel.fromJson(json['companies']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'is_male': is_male,
    'name': name,
    'job': job,
    'email': email,
    'password': password,
    'role': role,
    'created_at': createdAt.toIso8601String(),
    'company_id': companyId,
    'phone': phone,
    'whatsapp_phone': whatsappPhone,
    'longitude': longitude,
    'latitude': latitude,
    'address': address,
    'national_id': nationalId,
    'date_of_birth': dateOfBirth.toIso8601String(),
    'companies': company.toJson(),
  };
}
