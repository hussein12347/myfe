import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/data/models/flash_product_model/flash_product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../home/data/repos/home_repo.dart';


part 'flash_deals_state.dart';

class FlashDealsCubit extends Cubit<FlashDealsState> {
  final HomeRepo homeRepo;
  FlashDealsCubit(this.homeRepo) : super(FlashDealsInitial());

  Future<void> getFlashDeals()async{
    emit(GetFlashDealsLoading());
    final result = await homeRepo.getFlashDeals(id: Supabase.instance.client.auth.currentUser?.id);

    result.fold((l) => emit(GetFlashDealsError(l.errMessage)), (r) {
      emit(GetFlashDealsSuccess(r));
    },);
  }
}
