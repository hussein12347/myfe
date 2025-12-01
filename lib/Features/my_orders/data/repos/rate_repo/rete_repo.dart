import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:multi_vendor_e_commerce_app/core/errors/failures.dart';

abstract class RateRepo {
  Future<Either<Failure, bool>> addRateProduct({
    required BuildContext context,
    required String productId,
    required int rate,
    required String comment,
  });

   Future<Either<Failure, bool>> updateRateProduct({
     required BuildContext context,
    required String rateId,
    required int rate,
    required String comment,
  });


}