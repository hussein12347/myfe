import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/api_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/models/local_order_model.dart';
import '../../../../../core/models/order_model.dart';
import 'my_order_repo.dart';

class MyOrderRepoImpl implements MyOrderRepo {
  ApiServices _api = ApiServices();

  @override
  Future<Either<Failure, bool>> cancelOrder(String id) async {
    try {

    Response response = await _api.getData(
      path: 'orders?id=eq.${id}',

    );

    if (response.data[0]['status'] == 0) {
      await _api.patchData(
        path: 'orders?id=eq.${id}',
        data: {"status": 3},
      );
      return right(true);

    }else{
      return right(false);

    }
    } on Exception catch (e) {
      log(e.toString());
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<OrderModel>>> getMyOrders() async {
    Response response = await _api.getData(
      path:
          'orders?select=*,order_items(*,products(*,product_images(*),rates(*,users(*)),stores(*,store_branches(*))))&user_id=eq.${Supabase.instance.client.auth.currentUser!.id}',
    );
    try {
      List<OrderModel> orders = [];
      for (var item in response.data) {
        orders.add(OrderModel.fromJson(item));
      }
      return right(orders
        ..sort((a, b) => b.number.compareTo(a.number)) );// بيرتب من الصغير للكبير);
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override

  Future<Either<Failure, bool>> cancelLocalOrder(String id) async {
    try {

    Response response = await _api.getData(
      path: 'local_orders?id=eq.${id}',

    );

    if (response.data[0]['status'] == 0) {
      await _api.patchData(
        path: 'local_orders?id=eq.${id}',
        data: {"status": 2},
      );
      return right(true);

    }else{
      return right(false);

    }
    } on Exception catch (e) {
      log(e.toString());
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<LocalOrderModel>>> getMyLocalOrders() async {
    Response response = await _api.getData(
      path:
          'local_orders?select=*,local_order_items(*,products(*,product_images(*),rates(*,users(*)),stores(*,store_branches(*))))&user_id=eq.${Supabase.instance.client.auth.currentUser!.id}',
    );
    try {
      List<LocalOrderModel> orders = [];
      for (var item in response.data) {
        orders.add(LocalOrderModel.fromJson(item));
      }
      return right(orders
        ..sort((a, b) => b.number.compareTo(a.number)) );// بيرتب من الصغير للكبير);
    } on Exception catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
