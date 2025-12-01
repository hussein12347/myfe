import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:multi_vendor_e_commerce_app/Features/my_orders/data/repos/my_order_repo/my_order_repo.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/show_message.dart';

import '../../../../../core/models/local_order_model.dart';
import '../../../../../core/models/order_model.dart';
import '../../../../../generated/l10n.dart';

part 'local_order_state.dart';

class LocalOrderCubit extends Cubit<LocalOrderState> {
  final MyOrderRepo repo;

  LocalOrderCubit(this.repo) : super(LocalOrderInitial());

  Future<void> getMyLocalOrders() async {
    emit(LocalOrderLoading());
    var result = await repo.getMyLocalOrders();
    result.fold((l) => emit(LocalOrderError(l.errMessage)), (r) {
      emit(LocalOrderLoaded(r));
    });
  }

  Future<void> cancelLocalOrder(String id,String message) async {
    emit(LocalOrderLoading());
    var result = await repo.cancelLocalOrder(id);
    result.fold((l) => emit(LocalOrderError(l.errMessage)), (r) async {
      if (r == true) {

        await getMyLocalOrders();
      }else{
        ShowMessage.showToast(message);
        await getMyLocalOrders();

      }
    });
  }
}
