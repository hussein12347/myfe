import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/data/models/coupon_model.dart';

// import 'package:google_sign_in/google_sign_in.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/data/repos/auth_repo.dart';
import 'package:multi_vendor_e_commerce_app/core/errors/failures.dart';
import 'package:multi_vendor_e_commerce_app/core/models/company_model.dart';
import 'package:multi_vendor_e_commerce_app/core/models/user_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/theme_and_local/theme_and_local_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/api_services.dart';
import '../../../../core/utils/functions/encryption.dart';
import '../../../../core/utils/local_storage_helper.dart';

class AuthRepoImpl implements AuthRepo {
  final SupabaseClient client = Supabase.instance.client;
  final ApiServices _api = ApiServices();

  Future<String?> getFcmToken() async {
    final fcm = FirebaseMessaging.instance;
    final token = await fcm.getToken();
    return token;
  }

  @override
  Future<Either<Failure, UserModel>> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      // تسجيل الدخول
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (response.user == null || response.session == null) {
        await client.auth.signOut();
        return left(
          ServerFailure(
            'فشل إنشاء الحساب، قد يكون البريد الإلكتروني مستخدم بالفعل.',
          ),
        );
      }

      // جلب بيانات المستخدم من جدول users عن طريق API
      final userId = user?.id;
      final userResponse = await _api.getData(
        path:
            'users?select=*,companies!inner(*)&id=eq.$userId&companies.isShow=eq.true',
      );

      if (userResponse.data == null || userResponse.data.isEmpty) {
        return left(
          ServerFailure('لم يتم العثور على بيانات المستخدم في قاعدة البيانات.'),
        );
      }

      final fcmToken = await getFcmToken();
      await _api.patchData(
        path: 'users?id=eq.$userId',
        data: {"fcm_token": fcmToken},
      );

      final userModel = UserModel.fromJson(userResponse.data[0]);
      await LocalStorageHelper.saveUser(userModel);
      await context.read<ThemeAndLocalCubit>().changeTheme(
        userModel.company.themeColor,
      );

      return right(userModel);
    } on AuthException catch (e) {
      return left(ServerFailure(e.message));
    } on PostgrestException catch (e) {
      return left(ServerFailure(e.message ?? 'خطأ في قاعدة البيانات'));
    } on DioException catch (e) {
      return left(ServerFailure.fromDioException(e));
    } catch (e) {
      return left(ServerFailure('حدث خطأ غير متوقع: $e'));
    }
  }

  // @override
  // Future<Either<Failure, UserModel>> googleLoginIn() async {
  //   try {
  //     final signIn = GoogleSignIn.instance;
  //     signIn.initialize(
  //       serverClientId: "957125236670-ugrp2ojt738pnlhrbvicqufdefblq4ek.apps.googleusercontent.com",);
  //
  //     // تسجيل الدخول
  //     final GoogleSignInAccount googleUser = await signIn.authenticate();
  //
  //     final GoogleSignInAuthentication googleAuth = googleUser.authentication;
  //
  //     final AuthResponse response = await client.auth.signInWithIdToken(
  //       provider: OAuthProvider.google,
  //       idToken: googleAuth.idToken!,
  //     );
  //
  //     final user = response.user;
  //     if (user == null) {
  //       return left(ServerFailure('فشل تسجيل الدخول بجوجل.'));
  //     }
  //
  //     final userId = user.id;
  //
  //     // نتحقق هل المستخدم موجود في جدول users
  //     final userResponse = await _api.getData(path: 'users?id=eq.$userId');
  //
  //     if (userResponse.data == null || userResponse.data.isEmpty) {
  //       // المستخدم جديد؟ نضيفه في الجدول
  //       final userData = {
  //         'id': userId,
  //         'name': googleUser.displayName ?? '',
  //         'email': googleUser.email,
  //         'password': '', // أو null لو موديلك يدعم
  //         'role': 'buyer',
  //       };
  //
  //       await _api.postData(path: "users", data: userData);
  //       await LocalStorageHelper.saveUserName(userData["name"]!);
  //
  //       return right(UserModel(password:userData["password"]!,email: userData["email"]!,name: userData["name"]!,createdAt: DateTime.now() ,id: userData["id"]!,role: userData["role"]!));
  //     }
  //
  //     final userModel = UserModel.fromJson(userResponse.data[0]);
  //     await LocalStorageHelper.saveUserName(userModel.name);
  //
  //     return right(userModel);
  //   } on AuthException catch (e) {
  //     return left(ServerFailure(e.message));
  //   } on DioException catch (e) {
  //     return left(ServerFailure.fromDioException(e));
  //   } catch (e) {
  //     log(e.toString());
  //     return left(ServerFailure('حصل خطأ غير متوقع: $e'));
  //   }
  // }

  @override
  Future<Either<Failure, UserModel>> signUp({
    required String email,
    required String password,
    required String name,
    required String job,
    required String coupon,
    required DateTime dob,
    required String nationalId,
    required String address,
    required String phone,
    required String whatsapp,
    required String phoneCountryCode,
    required String whatsappCountryCode,
    required double lat,
    required double lng,
    required String companyId,
    required BuildContext context,
    required bool is_male,
  }) async {
    try {
      log('Step 1: Start fetching coupon');
      final couponResponse = await _api.getData(
        path:
            'coupons_company_signup?select=*,companies!inner(*)&code=eq.${Uri.encodeComponent(coupon)}&companies.isShow=eq.true',
      );
      log('Step 2: Coupon fetched: ${couponResponse.data}');

      if (couponResponse.data == null || couponResponse.data.isEmpty) {
        return left(ServerFailure('لم يتم العثور على كوبون.'));
      }

      final couponData = couponResponse.data[0];
      CodeModel couponModel = CodeModel.fromJson(couponData);
      log('Step 3: CouponModel created');

      if (couponModel.company.id != companyId) {
        return left(ServerFailure('كوبون غير صحيح.'));
      }

      log('Step 6: Signing up user in Supabase');
      final response = await client.auth.signUp(
        email: email,
        password: password,
      );
      log('Step 7: SignUp response received: ${response.user?.id}');

      await client.auth.signOut();
      await LocalStorageHelper.clearUser();
      await LocalStorageHelper.clearCart();

      log('Step 8: Signed out after signup');

      final user = response.user;
      final crypto = MySecureEncryption();

      String hashedPassword = await crypto.encrypt(password);
      print("🔐 Hashed Password: $hashedPassword");
      final fcmToken = await getFcmToken();

      log('Step 9: Preparing userData for insertion');
      final userData = {
        'id': user?.id,
        'name': name,
        'job': job,
        'email': email,
        'password': hashedPassword,
        'role': couponModel.isForEmployee ? 'employee' : 'buyer',
        'company_id': companyId,
        'phone': phoneCountryCode + phone,
        'whatsapp_phone': whatsappCountryCode + whatsapp,
        'longitude': lng,
        'latitude': lat,
        'address': address,
        'national_id': nationalId,
        "is_male": is_male,
        "fcm_token":fcmToken,
        'date_of_birth': dob.toIso8601String(),
      };
      log('Step 10: userData prepared');

      await _api.postData(path: "users", data: userData);
      log('Step 11: User data inserted');
      log('Step 4: Deleting coupon');
      await _api.deleteData(
        path: 'coupons_company_signup?id=eq.${couponModel.id}',
      );
      log('Step 5: Coupon deleted');
      Response userResponse = await _api.getData(
        path:
            'users?select=*,companies!inner(*)&id=eq.${user?.id}&companies.isShow=eq.true',
      );
      log('Step 12: User data fetched: ${userResponse.data}');

      UserModel userModel = UserModel.fromJson(userResponse.data[0]);
      log('Step 13: UserModel created: ${userModel.id}');

      await Supabase.instance.client.auth.signInWithPassword(
        password: password,
        email: email,
      );
      log('Step 14: Signed in with password');

      await LocalStorageHelper.saveUser(userModel);
      log('Step 15: User saved in local storage');

      await context.read<ThemeAndLocalCubit>().changeTheme(
        userModel.company.themeColor,
      );
      return right(userModel);
    } catch (e, st) {
      log('Error occurred at step: $e\nStacktrace: $st');
      return left(ServerFailure('حصل خطأ غير متوقع أثناء إنشاء الحساب: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CompanyModel>>> getCompanies() async {
    try {
      Response response = await _api.getData(path: "companies?isShow=eq.true");
      List<CompanyModel> companies = (response.data as List)
          .map((e) => CompanyModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return right(companies);
    } catch (e) {
      log(e.toString());
      return left(ServerFailure('$e'));
    }
  }
}
