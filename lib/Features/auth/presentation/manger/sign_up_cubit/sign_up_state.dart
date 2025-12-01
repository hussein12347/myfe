part of 'sign_up_cubit.dart';

@immutable
sealed class SignUpState {}

final class SignUpInitial extends SignUpState {}

final class SignUpLoading extends SignUpState {}
final class SignUpError extends SignUpState {
  final String errorMessage;
  SignUpError(this.errorMessage);
}
final class SignUpSuccess extends SignUpState {
  final UserModel user;
  SignUpSuccess(this.user);
}
final class GetCompaniesSuccess extends SignUpState {
  final List<CompanyModel> companies;
  GetCompaniesSuccess(this.companies);
}

final class GetCompaniesError extends SignUpState {
  final String errorMessage;
  GetCompaniesError(this.errorMessage);
}