import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/presentation/manger/sign_up_cubit/sign_up_cubit.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_button.dart';
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';
import 'package:phone_form_field/phone_form_field.dart';
import '../../../../../core/models/company_model.dart';
import '../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../cart/presentation/views/widgets/map_picker.dart';
import 'email_text_form_field.dart';
import 'job_text_form_field.dart';
import 'name_text_form_field.dart';
import 'password_text_form_field.dart';

class SignUpBody extends StatefulWidget {
  const SignUpBody({
    super.key,
    required this.emailController,
    required this.nameController,
    required this.jobController,

    required this.passwordController,
    required this.phoneController,
    required this.whatsappController,
    required this.dobController,
    required this.nationalIdController,
    required this.addressController,
    required this.locationController,
    required this.onPressed,
    required this.couponController,
    required this.companyIdController,
    required this.latController,
    required this.genderController,
    required this.lngController,
  });

  final TextEditingController emailController;
  final TextEditingController nameController;
  final TextEditingController jobController;
  final TextEditingController passwordController;
  final PhoneController? phoneController;
  final PhoneController? whatsappController;
  final TextEditingController dobController;
  final TextEditingController nationalIdController;
  final TextEditingController addressController;
  final TextEditingController locationController;
  final TextEditingController couponController;

  final TextEditingController companyIdController;

  final TextEditingController latController;

  final TextEditingController lngController;
  final TextEditingController genderController;

  final void Function() onPressed;

  @override
  State<SignUpBody> createState() => _SignUpBodyState();
}

class _SignUpBodyState extends State<SignUpBody> {
  int _currentStep = 0;
  final List<GlobalKey<FormState>> _formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];
  String? whatsappCountryCode;

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Theme.of(context).colorScheme.primary,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
              surface: Theme.of(context).colorScheme.surface,
              onSurface: Theme.of(context).colorScheme.onSurface,
            ), dialogTheme: DialogThemeData(backgroundColor: Theme.of(context).colorScheme.surface),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        widget.dobController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectLocation(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MapPickerScreen()),
    );
    if (result != null) {
      setState(() {
        widget.locationController.text = result['address'];
        widget.lngController.text = result['lng'].toString();
        widget.latController.text = result['lat'].toString();
      });
    }
  }

  void _nextStep() {
    if (_formKeys[_currentStep].currentState!.validate()) {
      if (_currentStep < 4) {
        setState(() {
          _currentStep++;
        });
      } else {
        widget.onPressed();
      }
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
      child: SingleChildScrollView(
        child: Stepper(
          physics: const NeverScrollableScrollPhysics(),
          currentStep: _currentStep,
          onStepContinue: _nextStep,
          onStepCancel: _previousStep,
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: OutlinedButton(
                        onPressed: details.onStepCancel,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: theme.colorScheme.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          S.of(context).back,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      onPressed: details.onStepContinue!,
                      text: _currentStep == 4
                          ? S.of(context).signup
                          : S.of(context).next,
                    ),
                  ),
                ],
              ),
            );
          },
          steps: [
            Step(
              title: Text(S.of(context).personal_information),
              content: Form(
                key: _formKeys[0],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    NameTextFormField(nameController: widget.nameController),
                    const SizedBox(height: 16),

                    JobTextFormField(jobController: widget.jobController),
                    const SizedBox(height: 16),
                    CustomDropdown<String>(
                      hintText: S.of(context).gender,
                      items: const [
                        "male",
                        "female",
                      ],
                      headerBuilder: (context, selectedItem, enabled) {
                        return Text(
                          selectedItem == "male"
                              ? S.of(context).male
                              : S.of(context).female,
                          style: TextStyle(
                            color: theme.hintColor,
                            fontSize: 16,
                          ),
                        );
                      },
                      listItemBuilder: (context, item, isSelected, onItemSelect) {
                        return ListTile(
                          leading: Icon(
                            item == "male"
                                ? FontAwesomeIcons.mars
                                : FontAwesomeIcons.venus,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.hintColor,
                          ),
                          title: Text(
                            item == "male"
                                ? S.of(context).male
                                : S.of(context).female,
                            style: TextStyle(
                              color: isSelected
                                  ? theme.colorScheme.primary
                                  : theme.textTheme.bodyLarge?.color,
                            ),
                          ),
                          onTap: onItemSelect,
                        );
                      },
                      decoration: CustomDropdownDecoration(
                        expandedBorderRadius: BorderRadius.circular(12),
                        expandedFillColor: theme.cardColor,
                        closedBorderRadius: BorderRadius.circular(8),
                        closedFillColor: theme.inputDecorationTheme.fillColor,
                        hintStyle: TextStyle(
                          color: theme.hintColor,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.venusMars,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            widget.genderController.text = value;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return S.of(context).please_select_gender;
                        }
                        return null;
                      },
                    ),


                    const SizedBox(height: 16),
                    CustomTextFormField(
                      hintText: S.of(context).date_of_birth,
                      controller: widget.dobController,
                      readOnly: true,
                      prefixIcon: Icons.calendar_month,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).please_enter_date_of_birth;
                        }
                        return null;
                      },
                      onTap: () => _selectDate(context),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      hintText: S.of(context).national_id,
                      controller: widget.nationalIdController,
                      textInputType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).please_enter_national_id;
                        }
                        return null;
                      },
                      prefixIcon: FontAwesomeIcons.idCard,
                    ),
                  ],
                ),
              ),
              isActive: _currentStep >= 0,
              state: _currentStep > 0
                  ? StepState.complete
                  : _currentStep == 0
                  ? StepState.editing
                  : StepState.indexed,
            ),
            Step(
              title: Text(S.of(context).company_information),
              content: Form(
                key: _formKeys[1],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    CustomTextFormField(
                      hintText: S.of(context).coupon,
                      controller: widget.couponController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).please_enter_coupon;
                        }
                        return null;
                      },
                      prefixIcon: FontAwesomeIcons.barcode,
                    ),
                    const SizedBox(height: 16),
                    CustomDropdown<CompanyModel>(
                      hintText: S.of(context).select_company,
                      items: context.read<SignUpCubit>().companies,
                      headerBuilder: (context, selectedItem, enabled) {
                        return Text(
                          selectedItem.name,
                          style: TextStyle(
                            color: theme.hintColor,
                            fontSize: 16,
                          ),
                        );
                      },
                      listItemBuilder:
                          (context, item, isSelected, onItemSelect) {
                            return ListTile(
                              trailing: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: CachedNetworkImage(imageUrl:item.logoUrl),
                              ),
                              title: Text(
                                item.name,
                                style: TextStyle(
                                  color: isSelected
                                      ? theme.colorScheme.primary
                                      : theme.textTheme.bodyLarge?.color,
                                ),
                              ),
                              onTap: onItemSelect,
                            );
                          },
                      decoration: CustomDropdownDecoration(
                        expandedBorderRadius: BorderRadius.circular(12),
                        expandedFillColor: theme.cardColor,
                        closedBorderRadius: BorderRadius.circular(8),
                        closedFillColor: theme.inputDecorationTheme.fillColor,
                        hintStyle: TextStyle(
                          color: theme.hintColor,
                          fontSize: 16,
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.building,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      onChanged: (company) {
                        if (company != null) {
                          setState(() {
                            widget.companyIdController.text = company.id;
                          });
                        }
                      },
                      validator: (value) {
                        if (value == null) {
                          return S.of(context).please_select_company;
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              isActive: _currentStep >= 1,
              state: _currentStep > 1
                  ? StepState.complete
                  : _currentStep == 1
                  ? StepState.editing
                  : StepState.indexed,
            ),

            Step(
              title: Text(S.of(context).contact_information),
              content: Form(
                key: _formKeys[2],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    const SizedBox(height: 4),

                    PhoneFormField(
                      countrySelectorNavigator:
                          CountrySelectorNavigator.draggableBottomSheet(
                            searchBoxIconColor: theme.colorScheme.secondary,
                            searchBoxDecoration: InputDecoration(
                              icon: Icon(
                                Icons.search,
                                color: theme.colorScheme.secondary,
                              ),
                              hintStyle: TextStyle(
                                color: theme.hintColor,
                                fontSize: 16,
                              ),
                              filled: true,

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),

                              hintText: S.of(context).search,
                              fillColor: theme.inputDecorationTheme.fillColor,
                            ),
                            backgroundColor: Theme.of(context).cardColor,
                            titleStyle: TextStyle(
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                            subtitleStyle: TextStyle(
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),

                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),

                      key: const Key("phone-field"),
                      controller: widget.phoneController,
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                          color: theme.hintColor,
                          fontSize: 16,
                        ),
                        filled: true,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),

                        hintText: S.of(context).phone_number,
                        fillColor: theme.inputDecorationTheme.fillColor,
                        prefixIcon: Icon(
                          Icons.phone,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      validator: PhoneValidator.compose([
                        PhoneValidator.required(
                          context,
                          errorText: S
                              .of(context)
                              .please_enter_your_phone_number,
                        ),
                        PhoneValidator.validMobile(context),
                      ]),
                      // onChanged: (phoneNumber) {
                      //   setState(() {
                      //     phoneCountryCode = phoneNumber.isoCode.name;
                      //   });
                      // },
                    ),
                    const SizedBox(height: 16),
                    PhoneFormField(
                      countrySelectorNavigator:
                          CountrySelectorNavigator.draggableBottomSheet(
                            searchBoxIconColor: theme.colorScheme.secondary,
                            searchBoxDecoration: InputDecoration(
                              icon: Icon(
                                Icons.search,
                                color: theme.colorScheme.secondary,
                              ),
                              hintStyle: TextStyle(
                                color: theme.hintColor,
                                fontSize: 16,
                              ),
                              filled: true,

                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide.none,
                              ),

                              hintText: S.of(context).search,
                              fillColor: theme.inputDecorationTheme.fillColor,
                            ),
                            backgroundColor: Theme.of(context).cardColor,
                            titleStyle: TextStyle(
                              color: theme.textTheme.bodyLarge?.color,
                            ),
                            subtitleStyle: TextStyle(
                              color: theme.textTheme.bodyMedium?.color,
                            ),
                          ),

                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),

                      key: const Key("whatsapp-field"),
                      controller: widget.whatsappController,
                      decoration: InputDecoration(
                        hintText: S.of(context).whatsapp_number,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: theme.inputDecorationTheme.fillColor,
                        hintStyle: TextStyle(color: theme.hintColor),
                        prefixIcon: Icon(
                          FontAwesomeIcons.whatsapp,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                      validator: PhoneValidator.compose([
                        PhoneValidator.required(
                          context,
                          errorText: S.of(context).please_enter_whatsapp_number,
                        ),
                        PhoneValidator.validMobile(context),
                      ]),
                      onChanged: (phoneNumber) {
                        setState(() {
                          whatsappCountryCode = phoneNumber.isoCode.name;
                        });
                      },
                    ),
                  ],
                ),
              ),
              isActive: _currentStep >= 2,
              state: _currentStep > 2
                  ? StepState.complete
                  : _currentStep == 2
                  ? StepState.editing
                  : StepState.indexed,
            ),
            Step(
              title: Text(S.of(context).address_information),
              content: Form(
                key: _formKeys[3],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    CustomTextFormField(
                      hintText: S.of(context).address,
                      controller: widget.addressController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).please_enter_address;
                        }
                        return null;
                      },
                      prefixIcon: Icons.home,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      hintText: S.of(context).location,
                      controller: widget.locationController,
                      readOnly: true,
                      prefixIcon: FontAwesomeIcons.mapMarkerAlt,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return S.of(context).please_enter_location;
                        }
                        return null;
                      },
                      onTap: () => _selectLocation(context),
                    ),
                  ],
                ),
              ),
              isActive: _currentStep >= 3,
              state: _currentStep > 3
                  ? StepState.complete
                  : _currentStep == 3
                  ? StepState.editing
                  : StepState.indexed,
            ),

            Step(
              title: Text(S.of(context).account_information),
              content: Form(
                key: _formKeys[4],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    EmailTextFormField(emailController: widget.emailController),
                    const SizedBox(height: 16),
                    PasswordTextFormField(
                      passwordController: widget.passwordController,
                    ),
                  ],
                ),
              ),
              isActive: _currentStep >= 4,
              state: _currentStep == 4 ? StepState.editing : StepState.indexed,
            ),
          ],
        ),
      ),
    );
  }
}
