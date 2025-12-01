part of 'rate_cubit.dart';

@immutable
sealed class RateState {}

final class RateInitial extends RateState {}

final class AddRateLoading extends RateState {}
final class AddRateSuccess extends RateState {}
final class AddRateError extends RateState {}

final class UpdateRateLoading extends RateState {}
final class UpdateRateSuccess extends RateState {}
final class UpdateRateError extends RateState {}

