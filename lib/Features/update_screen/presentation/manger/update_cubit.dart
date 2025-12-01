import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:multi_vendor_e_commerce_app/Features/update_screen/data/models/update_model.dart';
import 'package:multi_vendor_e_commerce_app/Features/update_screen/data/repos/Update_repo.dart';

part 'update_state.dart';

class UpdateCubit extends Cubit<UpdateState> {
  final UpdateRepo repo;
  UpdateCubit(this.repo) : super(UpdateInitial());
  Future<void> getUpdate()async{
    emit(GetUpdateLoading());

   final result= await repo.getUpdate();

   result.fold((l) => emit(GetUpdateError(l.errMessage)), (r) => emit(GetUpdateSuccess(r)),);
  }
}
