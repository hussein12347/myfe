part of 'flash_deals_cubit.dart';

@immutable
sealed class FlashDealsState {}

final class FlashDealsInitial extends FlashDealsState {}

final class GetFlashDealsLoading extends FlashDealsState {}
final class GetFlashDealsSuccess extends FlashDealsState {
  final List<FlashProductDealModel> flashDeals;
  GetFlashDealsSuccess(this.flashDeals);
}
final class GetFlashDealsError extends FlashDealsState {
  final String error;
  GetFlashDealsError(this.error);
}
