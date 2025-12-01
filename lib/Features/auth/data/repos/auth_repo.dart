import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/core/models/user_model.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/models/company_model.dart';

abstract class AuthRepo {
  Future<Either<Failure, UserModel>> login({
    required String email,
    required BuildContext context,
    required String password,
  });

  Future<Either<Failure, List<CompanyModel>>> getCompanies();

  // Future<Either<Failure, UserModel>> googleLoginIn();
  Future<Either<Failure, UserModel>> signUp({
    required String email,
    required String password,
    required String name,
    required String job,
    required String coupon,
    required DateTime dob,
    required String nationalId,
    required String address,
    required String phone,
    required String whatsapp,
    required String phoneCountryCode,
    required String whatsappCountryCode,
    required double lat,
    required double lng,
    required String companyId,
    required BuildContext context,
    required bool is_male

  });
}
