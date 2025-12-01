


import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import 'package:multi_vendor_e_commerce_app/Features/notifications/data/models/notification_model.dart';

import 'package:multi_vendor_e_commerce_app/core/errors/failures.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/api_services.dart';

import 'notification_repo.dart';

class NotificationRepoImpl implements NotificationRepo{

  final ApiServices api=ApiServices();
  @override
  Future<Either<Failure, List<NotificationModel>>> getNotifications() async {
   try {
     Response  response=await api.getData(path: 'notification?order=created_at.desc');
     List<NotificationModel> notifications=(response.data as List).map((e) => NotificationModel.fromJson(e as Map<String, dynamic>)).toList();
     return right(notifications);
   } on Exception catch (e) {
     // TODO
     log(e.toString());
     return left(ServerFailure(e.toString()));
   }


  }

}