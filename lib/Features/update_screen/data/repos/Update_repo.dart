import 'package:dartz/dartz.dart';
import 'package:multi_vendor_e_commerce_app/core/errors/failures.dart';

import '../models/update_model.dart';

abstract class UpdateRepo {
  Future<Either<Failure,UpdateModel>>getUpdate();
}