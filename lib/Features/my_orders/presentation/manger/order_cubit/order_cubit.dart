import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:multi_vendor_e_commerce_app/Features/my_orders/data/repos/my_order_repo/my_order_repo.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/show_message.dart';

import '../../../../../core/models/order_model.dart';
import '../../../../../generated/l10n.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final MyOrderRepo repo;

  OrderCubit(this.repo) : super(OrderInitial());

  Future<void> getMyOrders() async {
    emit(OrderLoading());
    var result = await repo.getMyOrders();
    result.fold((l) => emit(OrderError(l.errMessage)), (r) {
      emit(OrderLoaded(r));
    });
  }

  Future<void> cancelOrder(String id,String message) async {
    emit(OrderLoading());
    var result = await repo.cancelOrder(id);
    result.fold((l) => emit(OrderError(l.errMessage)), (r) async {
      if (r == true) {

        await getMyOrders();
      }else{
        ShowMessage.showToast(message);
        await getMyOrders();

      }
    });
  }
}
