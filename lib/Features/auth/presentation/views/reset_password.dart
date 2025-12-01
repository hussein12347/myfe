import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/presentation/views/verify_otp.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import '../../../../core/utils/functions/show_message.dart';
import '../../../../core/utils/widgets/custom_button.dart';
import '../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../core/utils/widgets/loading_widget.dart';
import '../../../../generated/l10n.dart';
import '../manger/reset_password_cubit/reset_password_cubit.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).forget_password_title),
        centerTitle: true,
      ),
      body: BlocConsumer<ResetPasswordCubit, ResetPasswordState>(
        builder: (context, state) {
          if (state is ResetPasswordLoading) {
            return Center(child: loadingWidget(context));
          } else {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      S.of(context).forget_password_content,
                      style: AppStyles.semiBold16(context),
                    ),
                    const SizedBox(height: 30),
                    CustomTextFormField(
                      hintText: S.of(context).email,
                      controller: emailController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).requiredField;
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return S.of(context).sendOTP_error;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomButton(
                        onPressed: () async {
                          if (emailController.text.isNotEmpty) {
                            await context
                                .read<ResetPasswordCubit>()
                                .sendOTP(toEmail: emailController.text);
                          } else {
                            ShowMessage.showToast(
                              S.of(context).requiredField,
                              backgroundColor: Colors.red,
                            );
                          }
                        },
                        text: S.of(context).sendOTP,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
        listener: (BuildContext context, ResetPasswordState state) {
          if (state is ResetPasswordOTPSent) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyOTPScreen(email: emailController.text),
              ),
            );
          } else if (state is ResetPasswordError) {
            ShowMessage.showToast(
              S.of(context).sendOTP_error,
              backgroundColor: Colors.red,
            );
          }
        },
      ),
    );
  }
}

