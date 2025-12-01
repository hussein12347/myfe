import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/data/repos/home_repo.dart';
import 'package:multi_vendor_e_commerce_app/core/models/category_model.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final HomeRepo repo;
  CategoryCubit(this.repo) : super(CategoryInitial());
List<CategoryModel>categories=[];
  Future<void>getCategories()async{
    emit(GetCategoriesLoading());
   final result = await repo.getCategory();

   result.fold((l) => emit(GetCategoriesError(l.errMessage)), (r) {
     categories=[];
     categories.addAll(r);
     emit(GetCategoriesSuccess(r));
   },);
  }

}
