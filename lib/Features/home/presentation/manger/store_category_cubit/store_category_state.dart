part of 'store_category_cubit.dart';

@immutable
sealed class StoreCategoryState {}

final class StoreCategoryInitial extends StoreCategoryState {}

final class GetStoreCategoriesLoading extends StoreCategoryState {}
final class GetStoreCategoriesSuccess extends StoreCategoryState {
  final List<StoreCategory>categories;
  GetStoreCategoriesSuccess(this.categories);
}
final class GetStoreCategoriesError extends StoreCategoryState {
  final String errorMessage;
  GetStoreCategoriesError(this.errorMessage);
}