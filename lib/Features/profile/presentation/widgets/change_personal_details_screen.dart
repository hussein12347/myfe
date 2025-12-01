import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor_e_commerce_app/core/models/user_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/show_message.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_button.dart';
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';
import 'package:phone_form_field/phone_form_field.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_text_field.dart';
import 'package:multi_vendor_e_commerce_app/Features/cart/presentation/views/widgets/map_picker.dart';

import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/utils/local_storage_helper.dart';

class ChangePersonalDetailsScreen extends StatefulWidget {
  const ChangePersonalDetailsScreen({super.key});

  @override
  State<ChangePersonalDetailsScreen> createState() => _ChangePersonalDetailsScreenState();
}

class _ChangePersonalDetailsScreenState extends State<ChangePersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final PhoneController phoneController = PhoneController();
  final PhoneController whatsappController = PhoneController();
  bool _isLoading = false;
  String? whatsappCountryCode;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
   UserModel? userModel = await LocalStorageHelper.getUser() ;
   final dateFormat = DateFormat('dd/MM/yyyy', "en");

    setState(() {
      nameController.text = userModel?.name??"اسم المستخدم"; // استبدل بجلب الاسم من قاعدة البيانات
      jobController.text = userModel?.job??"الوظيفة"; // استبدل بجلب الاسم من قاعدة البيانات

      dobController.text = userModel?.dateOfBirth != null
          ? dateFormat.format(userModel!.dateOfBirth)
          : "01/01/1990";
      addressController.text = userModel?.address??"عنوان المستخدم"; // استبدل بجلب العنوان
      locationController.text ="${userModel!.latitude}, ${userModel.longitude}"?? "موقع المستخدم"; // استبدل بجلب الموقع
      latController.text =  userModel.latitude.toString()??"0.0"; // استبدل بجلب خط العرض
      lngController.text =userModel.longitude.toString()?? "0.0"; // استبدل بجلب خط الطول
      genderController.text =(userModel.is_male?"male":"female") ; // استبدل بجلب الجنس
      phoneController.value = PhoneNumber.parse("+${userModel.phone}"); // استبدل بجلب رقم الهاتف
      whatsappController.value = PhoneNumber.parse("+${userModel.whatsappPhone}"); // استبدل بجلب رقم الواتساب
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    jobController.dispose();
    dobController.dispose();
    addressController.dispose();
    locationController.dispose();
    latController.dispose();
    lngController.dispose();
    genderController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    super.dispose();
  }

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
        dobController.text = "${picked.day}/${picked.month}/${picked.year}";
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
        locationController.text = result['address'];
        lngController.text = result['lng'].toString();
        latController.text = result['lat'].toString();
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        // هنا يتم تحديث البيانات في مصدر البيانات (مثل Supabase)
        // مثال:
        final dateFormat = DateFormat('dd/MM/yyyy', "en");
        DateTime dateOfBirth = dateFormat.parse(dobController.text);

        await Supabase.instance.client.from('users').update({
          'name': nameController.text,
          'job': jobController.text,


          'date_of_birth':dateOfBirth.toIso8601String(),


          'address': addressController.text,
          'latitude': double.parse(latController.text),
          'longitude': double.parse(lngController.text),
          'is_male': (genderController.text=='male'?true:false),
          'phone': "${phoneController.value.countryCode}${phoneController.value.nsn}",
          'whatsapp_phone': "${whatsappController.value.countryCode}${whatsappController.value.nsn}",

        }).eq('id', Supabase.instance.client.auth.currentUser!.id);

        await LocalStorageHelper.updateUserFromInternet(Supabase.instance.client.auth.currentUser!.id);

        ShowMessage.showToast(S.of(context).profile_updated_successfully,backgroundColor: Colors.green
        );
        Navigator.pop(context);
      } catch (e) {
        log(e.toString());
        ShowMessage.showToast(S.of(context).error_updating_profile
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).edit_profile),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // حقل الاسم
                CustomTextFormField(
                  hintText: S.of(context).name,
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).please_enter_your_name;
                    }
                    return null;
                  },
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 16),
                CustomTextFormField(
                  hintText: S.of(context).job,
                  controller: jobController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).pleaseEnterYourJob;
                    }
                    return null;
                  },
                  prefixIcon:FontAwesomeIcons.briefcase,
                ),
                const SizedBox(height: 16),

                // حقل الجنس
                CustomDropdown<String>(
                  initialItem: genderController.text,
                  hintText: S.of(context).gender,
                  items: const ["male", "female"],
                  headerBuilder: (context, selectedItem, enabled) {
                    return Text(
                      selectedItem == "male" ? S.of(context).male : S.of(context).female,
                      style: TextStyle(
                        color: theme.hintColor,
                        fontSize: 16,
                      ),
                    );
                  },
                  listItemBuilder: (context, item, isSelected, onItemSelect) {
                    return ListTile(
                      leading: Icon(
                        item == "male" ? FontAwesomeIcons.mars : FontAwesomeIcons.venus,
                        color: isSelected ? theme.colorScheme.primary : theme.hintColor,
                      ),
                      title: Text(
                        item == "male" ? S.of(context).male : S.of(context).female,
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
                        genderController.text = value;
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

                // حقل تاريخ الميلاد
                CustomTextFormField(
                  hintText: S.of(context).date_of_birth,
                  controller: dobController,
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

                // حقل رقم الهاتف
                PhoneFormField(
                  countrySelectorNavigator: CountrySelectorNavigator.draggableBottomSheet(
                    searchBoxIconColor: theme.colorScheme.secondary,
                    searchBoxDecoration: InputDecoration(
                      icon: Icon(Icons.search, color: theme.colorScheme.secondary),
                      hintStyle: TextStyle(color: theme.hintColor, fontSize: 16),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: S.of(context).search,
                      fillColor: theme.inputDecorationTheme.fillColor,
                    ),
                    backgroundColor: theme.cardColor,
                    titleStyle: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    subtitleStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  ),
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  key: const Key("phone-field"),
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(color: theme.hintColor, fontSize: 16),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: S.of(context).phone_number,
                    fillColor: theme.inputDecorationTheme.fillColor,
                    prefixIcon: Icon(Icons.phone, color: theme.colorScheme.secondary),
                  ),
                  validator: PhoneValidator.compose([
                    PhoneValidator.required(context,
                        errorText: S.of(context).please_enter_your_phone_number),
                    PhoneValidator.validMobile(context),
                  ]),
                ),
                const SizedBox(height: 16),

                // حقل رقم الواتساب
                PhoneFormField(
                  countrySelectorNavigator: CountrySelectorNavigator.draggableBottomSheet(
                    searchBoxIconColor: theme.colorScheme.secondary,
                    searchBoxDecoration: InputDecoration(
                      icon: Icon(Icons.search, color: theme.colorScheme.secondary),
                      hintStyle: TextStyle(color: theme.hintColor, fontSize: 16),
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: S.of(context).search,
                      fillColor: theme.inputDecorationTheme.fillColor,
                    ),
                    backgroundColor: theme.cardColor,
                    titleStyle: TextStyle(color: theme.textTheme.bodyLarge?.color),
                    subtitleStyle: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  ),
                  style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  key: const Key("whatsapp-field"),
                  controller: whatsappController,
                  decoration: InputDecoration(
                    hintText: S.of(context).whatsapp_number,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.inputDecorationTheme.fillColor,
                    hintStyle: TextStyle(color: theme.hintColor),
                    prefixIcon: Icon(FontAwesomeIcons.whatsapp, color: theme.colorScheme.secondary),
                  ),
                  validator: PhoneValidator.compose([
                    PhoneValidator.required(context,
                        errorText: S.of(context).please_enter_whatsapp_number),
                    PhoneValidator.validMobile(context),
                  ]),
                  onChanged: (phoneNumber) {
                    setState(() {
                      whatsappCountryCode = phoneNumber.isoCode.name;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // حقل العنوان
                CustomTextFormField(
                  hintText: S.of(context).address,
                  controller: addressController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return S.of(context).please_enter_address;
                    }
                    return null;
                  },
                  prefixIcon: Icons.home,
                ),
                const SizedBox(height: 16),

                // حقل الموقع
                CustomTextFormField(
                  hintText: S.of(context).location,
                  controller: locationController,
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
                const SizedBox(height: 20),

                // زر الحفظ
                _isLoading
                    ? const CircularProgressIndicator()
                    : CustomButton(
                  onPressed: _saveChanges,
                  text: S.of(context).save_changes,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}