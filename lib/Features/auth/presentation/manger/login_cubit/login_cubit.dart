import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:multi_vendor_e_commerce_app/core/models/user_model.dart';

import '../../../data/repos/auth_repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepo authRepo;

  LoginCubit(this.authRepo) : super(LoginInitial());

  Future<void> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(LoginLoading());

    final result = await authRepo.login(email: email, password: password, context: context);

    result.fold(
          (failure) {
            emit(LoginError(failure.errMessage));
            log(failure.errMessage);
          },
          (user) => emit(LoginSuccess(user)),
    );
  }

  // Future<void> googleLogIn(
  // ) async {
  //   emit(LoginLoading());
  //
  //   final result = await authRepo.googleLoginIn();
  //
  //   result.fold(
  //         (failure) => emit(LoginError(failure.errMessage)),
  //         (user) => emit(LoginSuccess(user)),
  //   );
  // }
}
