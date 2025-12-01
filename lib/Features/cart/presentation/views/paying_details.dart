import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor_e_commerce_app/Features/cart/data/models/cart_model/cart_model.dart';
import 'package:multi_vendor_e_commerce_app/Features/cart/presentation/views/chick_out.dart';
import 'package:multi_vendor_e_commerce_app/Features/cart/presentation/views/widgets/map_picker.dart';
import 'package:multi_vendor_e_commerce_app/core/models/user_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/show_message.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/local_storage_helper.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_button.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_text_field.dart';
import '../../../../core/utils/functions/calculate_distance.dart';
import '../../../../generated/l10n.dart';

class PayingView extends StatefulWidget {
  final CartModel cart;
  const PayingView({super.key, required this.cart});

  @override
  State<PayingView> createState() => _PayingViewState();
}

bool enableAddressTextField = false;



class _PayingViewState extends State<PayingView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  double deliveryPrice = 0;

  double? selectedLat;
  double? selectedLng;
  int _selectedPaymentMethod = 0;

  @override
  void initState() {
    super.initState();
    _initUserData();
  }
  String addressUrl = '';


  Future<void>_initUserData() async{
    nameController = TextEditingController();
    phoneController = TextEditingController();
    addressController = TextEditingController();

    UserModel? user= await LocalStorageHelper.getUser();

    nameController.text = user?.name ?? '';
    phoneController.text = '+${user?.phone?? ''}';
    addressController.text = user?.address?? '';
    selectedLat = user?.latitude;
    selectedLng = user?.longitude;

    if (selectedLat != null && selectedLng != null) {
      addressUrl = 'https://www.google.com/maps/search/?api=1&query=$selectedLat,$selectedLng';
    }

  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).shipping)),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).userDetails,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    CustomTextFormField(
                      hintText: S.of(context).fullName,
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return S.of(context).pleaseEnterYourName;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    CustomTextFormField(
                      hintText: S.of(context).phone,
                      controller: phoneController,
                      textInputType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return S.of(context).phone;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: CustomTextFormField(
                            hintText: S.of(context).deliveryAddress,
                            controller: addressController,
                            readOnly: !enableAddressTextField,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return S.of(context).deliveryAddress;
                              }
                              return null;
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(FontAwesomeIcons.mapMarkerAlt),
                          onPressed: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MapPickerScreen(),
                              ),
                            );

                            if (result is Map<String, dynamic>) {
                              addressController.text = result['address'] ?? '';
                              addressUrl = result['url'] ?? '';

                              setState(() {
                                enableAddressTextField = false;
                                selectedLat = result['lat'];
                                selectedLng = result['lng'];
                                deliveryPrice = calculateDeliveryForOrder(
                                  cart: widget.cart,
                                  userLat: selectedLat!,
                                  userLog: selectedLng!,
                                );
                              });
                            } else {
                              UserModel? user = await LocalStorageHelper.getUser();
                              setState(() {
                                enableAddressTextField = false;
                                selectedLat = user?.latitude;
                                selectedLng = user?.longitude;
                                deliveryPrice = calculateDeliveryForOrder(
                                  cart: widget.cart,
                                  userLat: selectedLat!,
                                  userLog: selectedLng!,
                                );
                              });
                            }


                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    const Divider(height: 32),
                    Text(
                      S.of(context).payment,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),

                    Card(
                      color: Theme.of(context).cardColor.withOpacity(0.4), // باهت شوية
                      elevation: 0, // شكل أنعم
                      child: AbsorbPointer( // يمنع أي ضغط على الـ RadioListTile
                        child: Opacity(
                          opacity: 0.5, // يخلي الشكل كله باهت
                          child: RadioListTile<int>(
                            title: Text(
                              S.of(context).payOnline,
                              style: AppStyles.semiBold18(context).copyWith(
                                color: Theme.of(context).disabledColor, // لون باهت للنص
                              ),
                            ),
                            subtitle: Text(
                              S.of(context).comingSoon,
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 12,
                              ),
                            ),

                            value: 1,
                            groupValue: _selectedPaymentMethod,
                            onChanged: null, // يخليه غير قابل للتفاعل برضو
                          ),
                        ),
                      ),
                    ),
                    
                    Card(
                      color: Theme.of(context).cardColor,
                      child: RadioListTile<int>(
                        title: Text(
                          S.of(context).cashOnDelivery,
                          style: AppStyles.semiBold18(context),
                        ),
                        value: 0,
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                    ),


                    Card(
                      color: Theme.of(context).cardColor,
                      child: RadioListTile<int>(
                        title: Text(
                          S.of(context).payLocally,
                          style: AppStyles.semiBold18(context),
                        ),
                        value: 2,
                        groupValue: _selectedPaymentMethod,
                        onChanged: (value) {
                          setState(() {
                            _selectedPaymentMethod = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              if(deliveryPrice==0){
                UserModel? user= await LocalStorageHelper.getUser();
                setState(() {
                  enableAddressTextField = false;
                  deliveryPrice = calculateDeliveryForOrder(
                    cart: widget.cart,
                    userLat:user!.latitude ,
                    userLog: user.longitude,
                  );
                });
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChickOutView(
                    cart: widget.cart,
                    name: nameController.text,
                    phone: phoneController.text,
                    address: addressController.text,
                    deliveryPrice: deliveryPrice,
                    payWay: _selectedPaymentMethod,
                    addressUrl: addressUrl,
                    userLat: selectedLat! ,   // أو user.latitude من LocalStorage
                    userLog: selectedLng!,   // أو user.longitude
                  ),
                ),
              );
            } else {
              ShowMessage.showToast(S.of(context).pleaseFillData);
            }
          },
          text: S.of(context).next,
        ),
      ),
    );

  }
}