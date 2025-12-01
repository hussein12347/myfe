part of 'category_cubit.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}
final class GetCategoriesLoading extends CategoryState {}
final class GetCategoriesSuccess extends CategoryState {
  final List<CategoryModel>categories;
  GetCategoriesSuccess(this.categories);
}
final class GetCategoriesError extends CategoryState {
  final String errorMessage;
  GetCategoriesError(this.errorMessage);
}


