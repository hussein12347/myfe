import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/models/store_category_model/store_category_model.dart';
import '../../../data/repos/home_repo.dart';

part 'store_category_state.dart';

class StoreCategoryCubit extends Cubit<StoreCategoryState> {
  final HomeRepo repo;

  StoreCategoryCubit(this.repo) : super(StoreCategoryInitial());
  Future<void>getStoreCategory()async{
    emit(GetStoreCategoriesLoading());
    final result = await repo.getStoreCategory();

    result.fold((l) => emit(GetStoreCategoriesError(l.errMessage)), (r) => emit(GetStoreCategoriesSuccess(r)),);
  }
}
