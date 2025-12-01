import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:multi_vendor_e_commerce_app/Features/update_screen/data/repos/Update_repo.dart';
import 'package:multi_vendor_e_commerce_app/core/errors/failures.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/api_services.dart';

import '../models/update_model.dart';

class UpdateRepoImpl implements UpdateRepo{
 final ApiServices _api=ApiServices();
  @override
  Future<Either<Failure, UpdateModel>> getUpdate() async {
  try {
    Response response=  await _api.getData(path: 'app_update?order=created_at.desc');
    UpdateModel updateModel=UpdateModel.fromJson(response.data[0]);
    return right(updateModel);
  } on Exception catch (e) {
    log("Get Update Error: $e");
    return left(ServerFailure(e.toString()));
    // TODO
  }

  }
  
}