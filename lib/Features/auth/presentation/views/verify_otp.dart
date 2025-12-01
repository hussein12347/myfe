import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/presentation/views/widgets/change_password_for_otp.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import '../../../../core/utils/functions/show_message.dart';
import '../../../../core/utils/widgets/custom_button.dart';
import '../../../../core/utils/widgets/loading_widget.dart';
import '../../../../generated/l10n.dart';
import '../manger/reset_password_cubit/reset_password_cubit.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String email;
  const VerifyOTPScreen({super.key, required this.email});

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  String otp = '';
  Timer? _timer;
  int _remainingSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _remainingSeconds = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).verify_otp),
        centerTitle: true,
      ),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        builder: (context, state) {
          if (state is ResetPasswordLoading) {
            return Center(child: loadingWidget(context));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    S.of(context).enter_otp_sent_to(widget.email),
                    style: AppStyles.semiBold16(context),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    S.of(context).time_remaining(_formatTime(_remainingSeconds)),
                    style: AppStyles.regular14(context).copyWith(
                      color: _remainingSeconds > 0 ? theme.colorScheme.secondary : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: OtpTextField(
                      numberOfFields: 6,
                      borderColor: theme.colorScheme.primary,
                      focusedBorderColor: theme.colorScheme.primary,
                      showFieldAsBox: true,
                      borderWidth: 2.0,
                      fieldWidth: 50,
                      fieldHeight: 50,
                      textStyle: AppStyles.semiBold16(context),
                      borderRadius: BorderRadius.circular(8),
                      cursorColor: theme.colorScheme.primary,
                      filled: true,
                      fillColor: theme.inputDecorationTheme.fillColor!,
                      onCodeChanged: (value) {
                        otp = value;
                      },
                      onSubmit: (value) {
                        otp = value;
                        if (otp.length == 6) {
                          context.read<ResetPasswordCubit>().verifyOTP(otp: otp, context: context);
                        } else {
                          ShowMessage.showToast(
                            S.of(context).otp_invalid_length,
                            backgroundColor: Colors.red,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomButton(
                      onPressed:() async {
                        (otp.length == 6)
                            ?await context.read<ResetPasswordCubit>().verifyOTP(otp: otp, context: context)
                            : null;
                      },
                      text: S.of(context).verify,
                      backgroundColor: otp.length == 6
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomButton(
                      onPressed:() async {
                        _canResend
                            ?
                          await context
                              .read<ResetPasswordCubit>()
                              .sendOTP(toEmail: widget.email)

                            : null;
                      },
                      text: S.of(context).resend_otp,
                      backgroundColor: _canResend
                          ? theme.colorScheme.primary
                          : theme.colorScheme.primary.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (BuildContext context, ResetPasswordState state) {
          if (state is ResetPasswordSuccess) {
            _timer?.cancel();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const ChangePasswordForOtpScreen(),
              ),
            );
          } else if (state is ResetPasswordOTPInvalid) {
            ShowMessage.showToast(
              S.of(context).otp_invalid,
              backgroundColor: Colors.red,
            );
          } else if (state is ResetPasswordOTPExpired) {
            ShowMessage.showToast(
              S.of(context).otp_expired,
              backgroundColor: Colors.red,
            );
            setState(() {
              _canResend = true;
            });
          } else if (state is ResetPasswordError) {
            ShowMessage.showToast(
              S.of(context).errorOccurred(''),
              backgroundColor: Colors.red,
            );
          } else if (state is ResetPasswordOTPSent) {
            ShowMessage.showToast(
              S.of(context).otp_sent,
              backgroundColor: Colors.green,
            );
            otp = ''; // إعادة تعيين OTP
            _startTimer();
          }
        },
      ),
    );
  }
}