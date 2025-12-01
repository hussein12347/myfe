part of 'local_order_cubit.dart';

@immutable
sealed class LocalOrderState {}

final class LocalOrderInitial extends LocalOrderState {}

final class LocalOrderLoading extends LocalOrderState {}
final class LocalOrderError extends LocalOrderState {
  final String message;

  LocalOrderError(this.message);
}
final class LocalOrderLoaded extends LocalOrderState {
  final List<LocalOrderModel> orders;

  LocalOrderLoaded(this.orders);
}
