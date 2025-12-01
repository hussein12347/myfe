import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/data/repos/auth_repo_impl.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/presentation/manger/login_cubit/login_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/presentation/views/widgets/login_body.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/nav_bar.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/show_message.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../../../../core/utils/styles/app_styles.dart';
import '../../../../core/utils/widgets/loading_widget.dart';
import '../../../../generated/l10n.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (context) => LoginCubit(AuthRepoImpl()),
      child: BlocConsumer<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NavBar()),
            );
          } else if (state is LoginError) {
            ShowMessage.showToast(state.errorMessage);
          }
        },
        builder: (context, state) {
          final isLoading = state is LoginLoading;

          return ModalProgressHUD(
            inAsyncCall: isLoading,
            dismissible: !isLoading,
            opacity: 0.4,
            // يعطي ظل خفيف وشيك
            progressIndicator: loadingWidget(context),

            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  S.of(context).login,
                  style: AppStyles.semiBold24(context),
                ),
              ),
              body: SingleChildScrollView(
                child: Form(
                  key: key,
                  child: LoginBody(
                    emailController: emailController,
                    passwordController: passwordController,
                    loginOnPressed: () async {
                      if (key.currentState!.validate()) {
                        await context.read<LoginCubit>().loginUser(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(), context: context,
                        );
                      }
                    },
                    // googleLoginOnPressed: () async {
                    //   await context.read<LoginCubit>().googleLogIn();
                    // },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }


}
