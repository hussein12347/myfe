
import 'package:dartz/dartz.dart';
import 'package:multi_vendor_e_commerce_app/Features/notifications/data/models/notification_model.dart';

import '../../../../core/errors/failures.dart';

abstract class  NotificationRepo {
  Future<Either<Failure, List<NotificationModel>>> getNotifications();


}