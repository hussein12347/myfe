part of 'update_cubit.dart';

@immutable
sealed class UpdateState {}

final class UpdateInitial extends UpdateState {}
final class GetUpdateLoading extends UpdateState {}
final class GetUpdateError extends UpdateState {
  final String errorMessage;
  GetUpdateError(this.errorMessage);
}
final class GetUpdateSuccess extends UpdateState {
  final UpdateModel updateModel;
  GetUpdateSuccess(this.updateModel);
}
