import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:multi_vendor_e_commerce_app/Features/my_orders/data/repos/rate_repo/rete_repo.dart';
import 'package:multi_vendor_e_commerce_app/core/errors/failures.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/api_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RateRepoImpl implements RateRepo {
  final ApiServices _api = ApiServices();
  @override
  Future<Either<Failure, bool>> addRateProduct({required BuildContext context,required String productId, required int rate, required String comment}) async {
    try {
     await _api.postData(path: 'rates', data: {"product_id": productId,"rate": rate,"user_id": Supabase.instance.client.auth.currentUser!.id,"comment": comment,});


      return right(true);

    } on Exception catch (e) {
      // TODO
      log(e.toString());
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateRateProduct({required BuildContext context,required String rateId, required int rate, required String comment}) async {
    try {
      await _api.patchData(path: 'rates?id=eq.$rateId', data: {"rate": rate,"comment": comment,});



      return right(true);
    } on Exception catch (e) {
      // TODO
      return left(ServerFailure(e.toString()));
    }
  }

}