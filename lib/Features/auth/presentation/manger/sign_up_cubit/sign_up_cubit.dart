import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/data/repos/auth_repo.dart';

import '../../../../../core/models/company_model.dart';
import '../../../../../core/models/user_model.dart';

part 'sign_up_state.dart';

class SignUpCubit extends Cubit<SignUpState> {
  final AuthRepo authRepo;

  SignUpCubit(this.authRepo) : super(SignUpInitial());

  List<CompanyModel> companies = [];
  Future<void> getCompanies() async {
    emit(SignUpLoading());
    final result = await authRepo.getCompanies();
    result.fold((failure) {
      emit(GetCompaniesError(failure.errMessage));

    }, (com) {
      companies = [];
      companies.addAll(com);
      emit(GetCompaniesSuccess(companies));
    });
  }

  Future<void> signUp({
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
    required bool is_male,
    required BuildContext context,
  }) async {
    emit(SignUpLoading());
    final result = await authRepo.signUp(
      email: email,
      password: password,
      name: name,
      job: job,
      coupon: coupon,
      dob: dob,
      nationalId: nationalId,
      address: address,
      phone: phone,
      whatsapp: whatsapp,
      phoneCountryCode: phoneCountryCode,
      whatsappCountryCode: whatsappCountryCode,
      lat: lat,
      lng: lng,
      companyId: companyId, context: context, is_male: is_male,
    );
    result.fold((failure) {
      emit(SignUpError(failure.errMessage));
    }, (userModel) {
      emit(SignUpSuccess(userModel));
    });
  }
}
