import 'dart:developer';
import 'dart:io'; // 1. لا تنسى هذا

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:multi_vendor_e_commerce_app/core/errors/failures.dart';
import 'package:upgrader/upgrader.dart';
import '../models/update_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/api_services.dart';

import 'Update_repo.dart';

class UpdateRepoImpl implements UpdateRepo {
  final ApiServices _api = ApiServices();

  @override
  Future<Either<Failure, UpdateModel>> getUpdate() async {
    try {
      // 1️⃣ جلب بيانات الـ API
      Response response = await _api.getData(path: 'app_update?order=created_at.desc');
      final Map<String, dynamic> apiData = response.data[0];

      // 2️⃣ تهيئة Upgrader (بدون minAppVersion لتجنب الإجبار الخاطئ)
      final upgrader = Upgrader(
        debugLogging: true,
        countryCode: 'EG',
        // ❌ قمنا بإزالة minAppVersion من هنا حتى لا يخدعنا الـ API
      );
      await upgrader.initialize();

      // 3️⃣ منطق التحقق الذكي
      String? storeVersion = upgrader.currentAppStoreVersion;
      String? storeUrl = upgrader.currentAppStoreListingURL;

      bool isUpdateAvailable = upgrader.isUpdateAvailable();

      // 🚨 تصحيح خاص لـ iOS:
      // إذا كنا على iOS ولم تجد المكتبة إصداراً في المتجر (null)، فهذا يعني أن التطبيق لم يُرفع بعد.
      // حتى لو الـ API يقول أن هناك تحديث، يجب أن نتجاهله لأن المستخدم لن يستطيع التحميل.
      if ( storeVersion == null) {
        isUpdateAvailable = false;
        log("iOS App not found on store yet. Ignoring API update flag.");
      }

      // 4️⃣ تحديد البيانات النهائية
      // إذا وجدنا نسخة في المتجر نأخذ رقمها، غير ذلك نأخذ ما في الـ API كـ fallback (للعرض فقط)
      String finalVersion = storeVersion ?? apiData['ios_version'] as String;

      // الرابط
      String finalDownloadUrl = storeUrl ?? apiData['ios_download_url'] as String;

      // 5️⃣ بناء الموديل
      final updateModel = UpdateModel(
        id: apiData['id'] as String,
        createdAt: DateTime.parse(apiData['created_at'] as String),

        isHaveUpdate: isUpdateAvailable, // نستخدم المتغير المحسن

        version: finalVersion,
        downloadUrl: finalDownloadUrl,
        isUnderMaintenance: apiData['ios_is_under_maintenance'] as bool,
      );

      log("Final Version: $finalVersion | Has Update: $isUpdateAvailable");

      return right(updateModel);
    } catch (e) {
      log("Get Update Error: $e");
      return left(ServerFailure(e.toString()));
    }
  }
}