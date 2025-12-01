
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/data/repos/auth_repo_impl.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/presentation/manger/sign_up_cubit/sign_up_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/presentation/views/widgets/sign_up_body.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:intl/intl.dart';
import '../../../../core/utils/functions/show_message.dart';
import '../../../../core/utils/styles/app_styles.dart';
import '../../../../core/utils/widgets/loading_widget.dart';
import '../../../../generated/l10n.dart';
import '../../../home/presentation/views/widgets/nav_bar.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final PhoneController phoneController = PhoneController(initialValue: PhoneNumber.parse('+20'));
  final PhoneController whatsappController = PhoneController(initialValue: PhoneNumber.parse('+20'));
  final TextEditingController dobController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController couponController = TextEditingController();
  final TextEditingController companyIdController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    jobController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    dobController.dispose();
    nationalIdController.dispose();
    addressController.dispose();
    locationController.dispose();
    couponController.dispose();
    companyIdController.dispose();
    latController.dispose();
    lngController.dispose();
    genderController.dispose();
    super.dispose();
  }

  // Helper method to validate and parse date
  DateTime? _parseDate(String dateStr) {
    final formats = [
      DateFormat('d/M/yyyy', "en"),
      DateFormat('dd/MM/yyyy', "en"),
      DateFormat('d-M-yyyy', "en"),
      DateFormat('dd-MM-yyyy', "en"),
    ];

    for (var format in formats) {
      try {
        return format.parseStrict(dateStr.trim());
      } catch (e) {
        continue;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SignUpCubit>(
      create: (context) => SignUpCubit(AuthRepoImpl())..getCompanies(),
      child: BlocConsumer<SignUpCubit, SignUpState>(
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: (state is SignUpLoading || state is GetCompaniesError),
            dismissible: (state is! SignUpLoading && state is! GetCompaniesError),
            opacity: 0.4,
            progressIndicator: loadingWidget(context),
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  S.of(context).signup,
                  style: AppStyles.semiBold24(context),
                ),
              ),
              body: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Form(
                      key: key,
                      child: SignUpBody(
                        emailController: emailController,
                        passwordController: passwordController,
                        nameController: nameController,
                        jobController: jobController,
                        addressController: addressController,
                        locationController: locationController,
                        nationalIdController: nationalIdController,
                        dobController: dobController,
                        whatsappController: whatsappController,
                        phoneController: phoneController,
                        couponController: couponController,
                        companyIdController: companyIdController,
                        latController: latController,
                        lngController: lngController,
                        genderController: genderController,
                        onPressed: () async {
                          if (key.currentState!.validate()) {
                            final date = _parseDate(dobController.text);
                            log(dobController.text);
                            if (date == null) {
                              ShowMessage.showToast(
                                  S.of(context).invalid_date_format);
                              return;
                            }
                            await context.read<SignUpCubit>().signUp(
                              email: emailController.text,
                              password: passwordController.text,
                              name: nameController.text,
                              job: jobController.text,
                              coupon: couponController.text.trim(),
                              phone: phoneController.value.nsn,
                              whatsapp: whatsappController.value.nsn,
                              address: addressController.text,
                              nationalId: nationalIdController.text,
                              dob: date,
                              companyId: companyIdController.text,
                              lat: double.tryParse(latController.text) ?? 0.0,
                              lng: double.tryParse(lngController.text) ?? 0.0,
                              phoneCountryCode: phoneController.value.countryCode,
                              whatsappCountryCode: whatsappController.value.countryCode,
                              context: context,
                              is_male: genderController.text.toLowerCase() == 'male',
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is SignUpSuccess) {
            Navigator.pop(context);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const NavBar()),
            );
          } else if (state is SignUpError) {
            ShowMessage.showToast(state.errorMessage);
          }
        },
      ),
    );
  }
}