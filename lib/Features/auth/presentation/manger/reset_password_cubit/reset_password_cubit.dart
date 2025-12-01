import 'dart:developer';
import 'dart:math' hide log;

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../core/utils/api_services.dart';
import '../../../../../core/utils/functions/encryption.dart';
import '../../../../../core/utils/local_storage_helper.dart';
import '../login_cubit/login_cubit.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(ResetPasswordInitial());

  final ApiServices _api = ApiServices();
  String? _otp;
  DateTime? _otpExpiry;
  String? _userEmail;
  String? _userPassword;

  // إنشاء رمز OTP عشوائي مكون من 6 أرقام
  String _generateOTP() {
    return (100000 + Random().nextInt(900000)).toString();
  }

  // إرسال رمز OTP عبر البريد الإلكتروني
  Future<void> sendOTP({required String toEmail}) async {
    emit(ResetPasswordLoading());

    try {
      final response = await _api.getData(path: "users?select=password&email=eq.$toEmail");
      if (response.data == null || response.data.isEmpty) {
        emit(ResetPasswordError());
        print('No user found with this email.');
        return;
      }
      final crypto = MySecureEncryption();

      _userEmail = toEmail;
      _userPassword =await crypto.decrypt( response.data[0]["password"]);
      log(_userPassword!);
      _otp = _generateOTP();
      _otpExpiry = DateTime.now().add(const Duration(seconds: 60));

      String username = 'multivendorflutter@gmail.com';
      String password = 'apli bvxw ikpu xutr'; // تأكد من أن هذا App Password

      final smtpServer = gmail(username, password);

      final message = Message()
        ..from = Address(username, 'المتجر الإلكتروني')
        ..recipients.add(toEmail)
        ..subject = 'رمز استعادة كلمة المرور'
        ..html = '''
        <h3>مرحبًا!</h3>
        <p>رمز استعادة كلمة المرور الخاص بك هو: <strong>$_otp</strong></p>
        <p>هذا الرمز صالح لمدة 60 ثانية فقط.</p>
        <p>إذا لم تطلب استعادة كلمة المرور، يرجى التواصل معنا على <a href="mailto:support@shop.com">support@shop.com</a>.</p>
        <p>إذا وصلت هذه الرسالة إلى البريد العشوائي، يرجى نقلها إلى البريد الوارد وإضافة بريدنا إلى جهات الاتصال.</p>
        <p>شكرًا، فريق المتجر الإلكتروني</p>
      ''';

      final sendReport = await send(message, smtpServer);
      print('Email sent: $sendReport');
      emit(ResetPasswordOTPSent());
    } on MailerException catch (e) {
      emit(ResetPasswordError());
      print('Email not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  // التحقق من رمز OTP
  Future<void> verifyOTP({required String otp, required BuildContext context}) async {
    emit(ResetPasswordLoading());

    if (_otp == null || _otpExpiry == null || _userEmail == null || _userPassword == null) {
      emit(ResetPasswordError());
      return;
    }

    if (DateTime.now().isAfter(_otpExpiry!)) {
      emit(ResetPasswordOTPExpired());
      return;
    }

    if (otp == _otp) {
      try {
        // تسجيل الدخول باستخدام Supabase
        try {
          await Supabase.instance.client.auth.signOut();
          await LocalStorageHelper.clearUser();
          await LocalStorageHelper.clearCart();

          await context.read<LoginCubit>().loginUser(
            email: _userEmail!,
            password: _userPassword!, context: context,
          );
          emit(ResetPasswordSuccess());

        } on Exception catch (e) {
          log(e.toString());
          emit(ResetPasswordError());

        }




      } catch (e) {
        emit(ResetPasswordError());
        print('Login failed: $e');
      }
    } else {
      emit(ResetPasswordOTPInvalid());
    }
  }
}