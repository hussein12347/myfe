import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';

import '../../../../../../generated/assets.dart';
import '../../../../../flash_deals/presentation/manger/flash_deals_cubit/flash_deals_cubit.dart';
import '../../../../../notifications/presentation/manger/notifications_cubit/notification_cubit.dart';
import '../../../manger/category_cubit/category_cubit.dart';
import '../../../manger/offer_cubit/offer_cubit.dart';
import '../../../manger/product_cubit/product_cubit.dart';
import '../../../manger/store_category_cubit/store_category_cubit.dart';
import '../../../manger/store_cubit/store_cubit.dart';
import '../nav_bar.dart';

class NoInternetView extends StatefulWidget {
  const NoInternetView({super.key});

  @override
  State<NoInternetView> createState() => _NoInternetViewState();
}

class _NoInternetViewState extends State<NoInternetView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StoreCubit, StoreState>(
          listener: (context, storeState) {
            if (storeState is GetStoresSuccess &&
                context.read<NotificationCubit>().state is GetNotificationSuccess &&
                context.read<FlashDealsCubit>().state is GetFlashDealsSuccess &&
                context.read<OfferCubit>().state is GetOffersSuccess &&
                context.read<ProductCubit>().state is GetProductsSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NavBar()),
              );
            }
          },
        ),
        BlocListener<NotificationCubit, NotificationState>(
          listener: (context, notificationState) {
            if (notificationState is GetNotificationSuccess &&
                context.read<StoreCubit>().state is GetStoresSuccess &&
                context.read<FlashDealsCubit>().state is GetFlashDealsSuccess &&
                context.read<OfferCubit>().state is GetOffersSuccess &&
                context.read<ProductCubit>().state is GetProductsSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NavBar()),
              );
            }
          },
        ),
        BlocListener<FlashDealsCubit, FlashDealsState>(
          listener: (context, flashDealsState) {
            if (flashDealsState is GetFlashDealsSuccess &&
                context.read<StoreCubit>().state is GetStoresSuccess &&
                context.read<NotificationCubit>().state is GetNotificationSuccess &&
                context.read<OfferCubit>().state is GetOffersSuccess &&
                context.read<ProductCubit>().state is GetProductsSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NavBar()),
              );
            }
          },
        ),
        BlocListener<OfferCubit, OfferState>(
          listener: (context, offerState) {
            if (offerState is GetOffersSuccess &&
                context.read<StoreCubit>().state is GetStoresSuccess &&
                context.read<NotificationCubit>().state is GetNotificationSuccess &&
                context.read<FlashDealsCubit>().state is GetFlashDealsSuccess &&
                context.read<ProductCubit>().state is GetProductsSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NavBar()),
              );
            }
          },
        ),
        BlocListener<ProductCubit, ProductState>(
          listener: (context, productState) {
            if (productState is GetProductsSuccess &&
                context.read<StoreCubit>().state is GetStoresSuccess &&
                context.read<NotificationCubit>().state is GetNotificationSuccess &&
                context.read<FlashDealsCubit>().state is GetFlashDealsSuccess &&
                context.read<OfferCubit>().state is GetOffersSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const NavBar()),
              );
            }
          },
        ),
      ],
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  Assets.json404Blue,
                  width: 200,
                  height: 200,
                  repeat: true,
                ),
                const SizedBox(height: 16),
                Text(
                  S.of(context).noInternetConnection,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  S.of(context).pleaseCheckYourConnection,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:isLoading?null: () async {
                    setState(() {
                      isLoading = true;
                    });
                    final productCubit = context.read<ProductCubit>();
                    final storeCubit = context.read<StoreCubit>();
                    final offerCubit = context.read<OfferCubit>();
                    final categoryCubit = context.read<CategoryCubit>();
                    final storeCategoryCubit = context.read<StoreCategoryCubit>();
                    final notificationCubit = context.read<NotificationCubit>();
                    final flashDealsCubit = context.read<FlashDealsCubit>();

                    await storeCubit.getStores();
                    await offerCubit.getOffers();
                    await categoryCubit.getCategories();
                    await storeCategoryCubit.getStoreCategory();
                    // إعادة محاولة جلب البيانات
                    await notificationCubit.getNotifications();
                    await flashDealsCubit.getFlashDeals();
                    await productCubit.getProducts();
                    setState(() {
                      isLoading = false;
                    });
                  },
                  child: isLoading?CircularProgressIndicator(backgroundColor: Colors.white,padding: EdgeInsets.all(8),):Text(S.of(context).retry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}