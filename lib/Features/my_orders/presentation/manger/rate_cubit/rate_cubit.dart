import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:multi_vendor_e_commerce_app/Features/my_orders/data/repos/rate_repo/rete_repo.dart';

part 'rate_state.dart';

class RateCubit extends Cubit<RateState> {
  final RateRepo rateRepo;
  RateCubit(this.rateRepo) : super(RateInitial());

  Future<void> addRateProduct({required BuildContext context,required String productId, required int rate, required String comment}) async {
    emit(AddRateLoading());
    final response = await rateRepo.addRateProduct(context: context, productId: productId, rate: rate, comment: comment);
    response.fold((l) => emit(AddRateError()), (r) => emit(AddRateSuccess()));
  }

  Future<void> updateRateProduct({required BuildContext context,required String rateId, required int rate, required String comment}) async {
    emit(UpdateRateLoading());
    final response = await rateRepo.updateRateProduct(context: context, rateId: rateId, rate: rate, comment: comment);
    response.fold((l) => emit(UpdateRateError()), (r) => emit(UpdateRateSuccess()));
  }
}
