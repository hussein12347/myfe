part of 'reset_password_cubit.dart';

@immutable
sealed class ResetPasswordState {}

class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordOTPSent extends ResetPasswordState {}

class ResetPasswordSuccess extends ResetPasswordState {}

class ResetPasswordError extends ResetPasswordState {}

class ResetPasswordOTPInvalid extends ResetPasswordState {}

class ResetPasswordOTPExpired extends ResetPasswordState {}