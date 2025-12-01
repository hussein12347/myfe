import 'package:dartz/dartz.dart';
import 'package:multi_vendor_e_commerce_app/core/errors/failures.dart';
import 'package:multi_vendor_e_commerce_app/core/models/order_model.dart';

import '../../../../../core/models/local_order_model.dart';

abstract class MyOrderRepo{
  Future<Either<Failure,List<OrderModel>>>getMyOrders();
  Future<Either<Failure,bool>>cancelOrder(String id);
  Future<Either<Failure,List<LocalOrderModel>>>getMyLocalOrders();
  Future<Either<Failure,bool>>cancelLocalOrder(String id);
}