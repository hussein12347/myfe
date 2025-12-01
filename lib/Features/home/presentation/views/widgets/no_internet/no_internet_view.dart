import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/store_category_cubit/store_category_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/update_screen/data/repos/update_repo_impl.dart';
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../../../generated/assets.dart';
import '../../../../../flash_deals/presentation/manger/flash_deals_cubit/flash_deals_cubit.dart';
import '../../../../../notifications/presentation/manger/notifications_cubit/notification_cubit.dart';
import '../../../../../update_screen/presentation/manger/update_cubit.dart';
import '../../../../../update_screen/presentation/views/maintance_view.dart';
import '../../../../../update_screen/presentation/views/update_screen_view.dart';
import '../../../manger/offer_cubit/offer_cubit.dart';
import '../../../manger/product_cubit/product_cubit.dart';
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
                context.read<StoreCategoryCubit>().state is GetStoreCategoriesSuccess &&
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
                context.read<StoreCategoryCubit>().state is GetStoreCategoriesSuccess &&
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
                context.read<StoreCategoryCubit>().state is GetStoreCategoriesSuccess &&
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
                context.read<StoreCategoryCubit>().state is GetStoreCategoriesSuccess &&
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
        BlocListener<StoreCategoryCubit, StoreCategoryState>(
          listener: (context, storeCategoryState) {
            if (storeCategoryState is GetStoreCategoriesSuccess &&
                context.read<StoreCubit>().state is GetStoresSuccess &&
                context.read<ProductCubit>().state is GetProductsSuccess &&
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
                  onPressed: isLoading ? null : () async {
                    setState(() => isLoading = true);

                    final storeCubit = context.read<StoreCubit>();
                    final storeCategoryCubit = context.read<StoreCategoryCubit>();
                    final offerCubit = context.read<OfferCubit>();
                    final productCubit = context.read<ProductCubit>();
                    final notificationCubit = context.read<NotificationCubit>();
                    final flashDealsCubit = context.read<FlashDealsCubit>();

                    await Future.wait([
                      storeCubit.getStores(),
                      offerCubit.getOffers(),
                      productCubit.getProducts(),
                      notificationCubit.getNotifications(),
                      flashDealsCubit.getFlashDeals(),
                      storeCategoryCubit.getStoreCategory()
                    ]);

                    // ✅ اتأكد إنهم كلهم نجحوا فعلاً قبل التنقل
                    if (storeCubit.state is GetStoresSuccess &&
                        offerCubit.state is GetOffersSuccess &&
                        storeCategoryCubit.state is GetStoreCategoriesSuccess &&
                        productCubit.state is GetProductsSuccess &&
                        notificationCubit.state is GetNotificationSuccess &&
                        flashDealsCubit.state is GetFlashDealsSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const NavBar()),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('try again...')),
                      );
                    }

                    setState(() => isLoading = false);
                  }

                  ,child: isLoading?const CircularProgressIndicator(backgroundColor: Colors.white,padding: EdgeInsets.all(8),):Text(S.of(context).retry),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}