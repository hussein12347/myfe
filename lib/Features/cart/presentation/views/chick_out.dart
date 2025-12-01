import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:multi_vendor_e_commerce_app/Features/cart/data/models/cart_model/cart_model.dart';
import 'package:multi_vendor_e_commerce_app/Features/cart/presentation/manger/cart_cubit/cart_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/cart/presentation/views/widgets/chick_out_success.dart';
import 'package:multi_vendor_e_commerce_app/Features/cart/presentation/views/widgets/chick_out_widget.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/show_message.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_button.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/loading_widget.dart';
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';
import 'package:pay_with_paymob/pay_with_paymob.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/functions/calculate_distance.dart';
import '../../data/models/cart_item_model/cart_item_model.dart';

class ChickOutView extends StatefulWidget {
  final CartModel cart;
  final String name;
  final int payWay;
  final String phone;
  final String address;
  final double deliveryPrice;
  final String addressUrl;
  final double userLat;
  final double userLog;

  const ChickOutView({
    super.key,
    required this.cart,
    required this.name,
    required this.phone,
    required this.address,
    required this.deliveryPrice,
    required this.payWay,
    required this.addressUrl, required this.userLat, required this.userLog,
  });

  @override
  State<ChickOutView> createState() => _ChickOutViewState();
}

class _ChickOutViewState extends State<ChickOutView> {
  @override
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final theme = Theme.of(context);

    PaymentData.initialize(
      apiKey: "ZXlKaGJHY2lPaUpJVXpVeE1pSXNJblI1Y0NJNklrcFhWQ0o5LmV5SmpiR0Z6Y3lJNklrMWxjbU5vWVc1MElpd2ljSEp2Wm1sc1pWOXdheUk2TVRBMk5qWTVNQ3dpYm1GdFpTSTZJbWx1YVhScFlXd2lmUS5wNVdMZkV1NEx6TWJPVWVkRDVfY3AwQWtWelB4OXV4R1FYRk9SSldRTWxyLUk4T0pCdXFnWk5QQl9pWWFkQ2FpUWRkTVJNT29PamFxY250NjVPRU1pUQ==",
      iframeId: "947241",
      integrationCardId: "5229376",
      integrationMobileWalletId: "5229377",
      userData: UserData(
        email: Supabase.instance.client.auth.currentUser?.email ?? '',
        phone: widget.phone,
        name: widget.name,
      ),
      style: Style(
        primaryColor: theme.colorScheme.primary,
        scaffoldColor: theme.scaffoldBackgroundColor,
        appBarBackgroundColor: theme.appBarTheme.backgroundColor ?? theme.colorScheme.primary,
        appBarForegroundColor: theme.appBarTheme.foregroundColor ?? theme.colorScheme.onPrimary,
        textStyle: theme.textTheme.bodyMedium ?? const TextStyle(),
        buttonStyle: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        circleProgressColor: theme.colorScheme.secondary,
        unselectedColor: theme.unselectedWidgetColor,
      ),
    );
  }

  // Group cart items by storeId
  Map<String, List<CartItemModel>> _groupItemsByStore() {
    final Map<String, List<CartItemModel>> storeItems = {};
    for (var item in widget.cart.items) {
      final storeId = item.product.storeId;
      if (!storeItems.containsKey(storeId)) {
        storeItems[storeId] = [];
      }
      storeItems[storeId]!.add(item);
    }
    return storeItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).checkout)),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) => ModalProgressHUD(
          inAsyncCall: state is AddItemsToCartLoading || state is AddItemsToCartError,
          dismissible: state is! AddItemsToCartLoading && state is! AddItemsToCartError,
          opacity: 0.4,
          progressIndicator: loadingWidget(context),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: ChickOutWidget(
                  cart: widget.cart,
                  name: widget.name,
                  phone: widget.phone,
                  address: widget.address,
                  deliveryPrice: widget.payWay == 2?0:widget.deliveryPrice,
                  payWay: widget.payWay,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
          onPressed: () async {
            // Group items by store
            final storeItems = _groupItemsByStore();
            final orderNumbers = <String>[];

            if (widget.payWay == 1) {
              // Online payment: Pay only for cart total (excluding delivery)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentView(
                    onPaymentSuccess: () async {
                      // Create an order for each store
                      final storeItems = _groupItemsByStore();
                      final deliveryPerStore = calculateDeliveryPerStore(
                        cart: widget.cart,
                        userLat: widget.userLat, // TODO: هات إحداثيات المستخدم
                        userLog: widget.userLog,
                      );

                      for (var storeId in storeItems.keys) {
                        final storeCart = CartModel(items: storeItems[storeId]!);
                        final storeTotal = storeCart.total;
                        final deliveryForThisStore = deliveryPerStore[storeId] ?? 0;

                        final orderNumber = await context.read<CartCubit>().addProductToCart(
                          cart: storeCart,
                          name: widget.name,
                          phone: widget.phone,
                          address: widget.address,
                          isPaid: widget.payWay == 1,
                          addressUrl: widget.addressUrl,
                          price: storeTotal + deliveryForThisStore, // 🟢 توصيل خاص بالمتجر فقط
                          context: context,
                          store_id: storeId,
                        );
                        context.read<CartCubit>().clearCartForStoreIcCheckout(storeId);
                        orderNumbers.add(orderNumber);
                      }


                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChickOutSuccess(
                            number: orderNumbers.join(', '), // Combine order numbers
                            date: DateTime.now().toUtc().toString(),
                          ),
                        ),
                            (route) => false,
                      );
                    },
                    onPaymentError: () {
                      ShowMessage.showToast(
                        S.of(context).errorOccurred('Payment failed'),
                        backgroundColor: Colors.red,
                      );
                    },
                    price: widget.cart.total, // Only cart total, no delivery
                  ),
                ),
              );
            } else if(widget.payWay == 2) {
              // Cash on delivery: Create orders without payment
              final storeItems = _groupItemsByStore();


              for (var storeId in storeItems.keys) {
                final storeCart = CartModel(items: storeItems[storeId]!);
                final storeTotal = storeCart.total;


                final orderNumber = await context.read<CartCubit>().addProductToLocalCart(
                  cart: storeCart,
                  name: widget.name,
                  phone: widget.phone,
                  address: widget.address,
                  isPaid: widget.payWay == 1,
                  addressUrl: widget.addressUrl,
                  price: storeTotal + 0, // 🟢 توصيل خاص بالمتجر فقط
                  context: context,
                  store_id: storeId,
                );
                context.read<CartCubit>().clearCartForStoreIcCheckout(storeId);
                orderNumbers.add(orderNumber);

              }

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ChickOutSuccess(
                    number: orderNumbers.join(', '), // Combine order numbers
                    date: DateTime.now().toUtc().toString(),
                  ),
                ),
                    (route) => false,
              );
            }else {
              // Cash on delivery: Create orders without payment
              final storeItems = _groupItemsByStore();
              final deliveryPerStore = calculateDeliveryPerStore(
                cart: widget.cart,
                userLat: widget.userLat, // TODO: هات إحداثيات المستخدم
                userLog: widget.userLog,
              );

              for (var storeId in storeItems.keys) {
                final storeCart = CartModel(items: storeItems[storeId]!);
                final storeTotal = storeCart.total;
                final deliveryForThisStore = deliveryPerStore[storeId] ?? 0;

                final orderNumber = await context.read<CartCubit>().addProductToCart(
                  cart: storeCart,
                  name: widget.name,
                  phone: widget.phone,
                  address: widget.address,
                  isPaid: widget.payWay == 1,
                  addressUrl: widget.addressUrl,
                  price: storeTotal + deliveryForThisStore, // 🟢 توصيل خاص بالمتجر فقط
                  context: context,
                  store_id: storeId,
                );
                context.read<CartCubit>().clearCartForStoreIcCheckout(storeId);
                orderNumbers.add(orderNumber);
              }


              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ChickOutSuccess(
                    number: orderNumbers.join(', '), // Combine order numbers
                    date: DateTime.now().toUtc().toString(),
                  ),
                ),
                    (route) => false,
              );
            }
          },
          text: S.of(context).confirmOrder,
        ),
      ),
    );
  }
}