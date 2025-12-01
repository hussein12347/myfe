// import 'dart:developer';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/offer_cubit/offer_cubit.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/product_cubit/product_cubit.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/store_category_cubit/store_category_cubit.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/store_cubit/store_cubit.dart';
// import 'package:multi_vendor_e_commerce_app/Features/notifications/presentation/manger/notifications_cubit/notification_cubit.dart';
// import 'package:multi_vendor_e_commerce_app/Features/update_screen/data/repos/update_repo_impl.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:skeletonizer/skeletonizer.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:package_info_plus/package_info_plus.dart';
// import '../../../../../core/utils/local_storage_helper.dart';
// import '../../../../../generated/l10n.dart';
// import '../../../../cart/presentation/views/stores_section.dart';
// import '../../../../flash_deals/presentation/manger/flash_deals_cubit/flash_deals_cubit.dart';
// import '../../../../flash_deals/presentation/views/flash_deals_view.dart';
// import '../../../../profile/presentation/views/profile_view.dart';
// import '../../../../update_screen/presentation/manger/update_cubit.dart';
// import '../../../../update_screen/presentation/views/maintance_view.dart';
// import '../../../../update_screen/presentation/views/update_screen_view.dart';
// import '../home_view.dart';
// import 'no_internet/no_internet_view.dart';
//
// class NavBar extends StatefulWidget {
//   const NavBar({super.key});
//
//   @override
//   State<NavBar> createState() => _NavBarState();
// }
//
// class _NavBarState extends State<NavBar> {
//   int _selectedIndex = 0;
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     checkForUpdate();
//
//   if(Supabase.instance.client.auth.currentUser!=null){
//     LocalStorageHelper.updateUserFromInternet(Supabase.instance.client.auth.currentUser!.id);
//
//   }
//     requestNotificationPermission();
//
//     // ✅ فحص التحديثات
//   }
//
//   Future<void> checkForUpdate() async {
//     final packageInfo = await PackageInfo.fromPlatform();
//     final currentVersion = packageInfo.version;
// log(currentVersion);
//     final updateCubit = UpdateCubit(UpdateRepoImpl());
//     final result = await updateCubit.getUpdate(); // دي بترجع الحالة الجديدة بعد التنفيذ
//
//     if (updateCubit.state is GetUpdateSuccess) {
//       final latest = (updateCubit.state as GetUpdateSuccess).updateModel;
//
//         if (!mounted) return; // عشان تتأكد إن الواجهة لسه مفتوحة
//         if (latest.isUnderMaintenance) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const MaintenanceView()),
//           );
//         } else if (latest.version != currentVersion) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//               builder: (_) => UpdateScreenView(updateModel: latest),
//             ),
//           );
//         }
//
//     }
//   }
//
//
//   Future<bool> requestNotificationPermission() async {
//     try {
//       PermissionStatus status = await Permission.notification.status;
//       if (status.isGranted) {
//         print("✅ إذن الإشعارات مفعّل بالفعل");
//         return true;
//       }
//       status = await Permission.notification.request();
//       if (status.isGranted) {
//         print("🎉 تم منح إذن الإشعارات");
//         return true;
//       } else {
//         print("⚠️ تم رفض إذن الإشعارات");
//       }
//     } catch (e) {
//       print("❌ حصل خطأ أثناء طلب الإذن: $e");
//     }
//     return false;
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//
//     final List<Widget> pages = <Widget>[
//       const HomeView(),
//       const FlashDealsScreen(),
//       const StoresInCartView(),
//       const ProfileScreen(),
//     ];
//
//     return MultiBlocListener(
//       listeners: [
//         BlocListener<StoreCubit, StoreState>(
//           listener: (context, state) {
//             if (state is GetStoresError) {
//               log("GetStoresError: ${state.errorMessage}");
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const NoInternetView()),
//               );
//             }
//           },
//         ),
//         BlocListener<StoreCategoryCubit, StoreCategoryState>(
//           listener: (context, state) {
//             if (state is GetStoreCategoriesError) {
//               log("GetCategoriesError");
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const NoInternetView()),
//               );
//             }
//           },
//         ),
//         BlocListener<NotificationCubit, NotificationState>(
//           listener: (context, state) {
//             if (state is GetNotificationFailure) {
//               log("GetNotificationFailure: ${state.failure}");
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const NoInternetView()),
//               );
//             }
//           },
//         ),
//
//
//         BlocListener<FlashDealsCubit, FlashDealsState>(
//           listener: (context, state) {
//             if (state is GetFlashDealsError) {
//               log("GetFlashDealsError: ${state.error}");
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const NoInternetView()),
//               );
//             }
//           },
//         ),
//         BlocListener<OfferCubit, OfferState>(
//           listener: (context, state) {
//             if (state is GetOffersError) {
//               log("GetOffersError: ${state.errorMessage}");
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const NoInternetView()),
//               );
//             }
//           },
//         ),
//         BlocListener<ProductCubit, ProductState>(
//           listener: (context, state) {
//             if (state is GetProductsError) {
//               log("GetProductsError: ${state.errorMessage}");
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => const NoInternetView()),
//               );
//             }
//           },
//         ),
//       ],
//       child: Skeletonizer(
//         enabled: (context.watch<StoreCubit>().state is! GetStoresSuccess ||
//             context.watch<UpdateCubit>().state is! GetUpdateSuccess ||
//             context.watch<NotificationCubit>().state is! GetNotificationSuccess ||
//             context.watch<StoreCategoryCubit>().state is! GetStoreCategoriesSuccess ||
//             context.watch<FlashDealsCubit>().state is! GetFlashDealsSuccess ||
//             context.watch<OfferCubit>().state is! GetOffersSuccess ||
//             context.watch<ProductCubit>().state is! GetProductsSuccess),
//         child: Scaffold(
//           extendBody: true,
//           body: AnimatedSwitcher(
//             duration: const Duration(milliseconds: 300),
//             child: pages[_selectedIndex],
//           ),
//           bottomNavigationBar: Container(
//             margin: EdgeInsets.symmetric(
//               vertical: screenHeight * 0.025,
//               horizontal: screenWidth * 0.05,
//             ),
//             decoration: BoxDecoration(
//               color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.90),
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.2),
//                   blurRadius: 8,
//                   offset: const Offset(0, -2),
//                 ),
//               ],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(24),
//               child: BottomNavigationBar(
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 type: BottomNavigationBarType.fixed,
//                 currentIndex: _selectedIndex,
//                 onTap: _onItemTapped,
//                 selectedItemColor: Theme.of(context).colorScheme.primary,
//                 unselectedItemColor: Colors.grey[500],
//                 enableFeedback: true,
//                 selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
//                 unselectedLabelStyle: const TextStyle(),
//                 items: [
//                   BottomNavigationBarItem(
//                     icon: Icon(
//                       (_selectedIndex == 0) ? Icons.home : Icons.home_outlined,
//                     ),
//                     label: S.of(context).home,
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(
//                       (_selectedIndex == 1)
//                           ? FontAwesomeIcons.boltLightning
//                           : FontAwesomeIcons.bolt,
//                     ),
//                     label: S.of(context).flashDeals,
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(
//                       (_selectedIndex == 2)
//                           ? Icons.shopping_cart
//                           : Icons.shopping_cart_outlined,
//                     ),
//                     label: S.of(context).cart,
//                   ),
//                   BottomNavigationBarItem(
//                     icon: Icon(
//                       (_selectedIndex == 3)
//                           ? Icons.person
//                           : Icons.person_outline,
//                     ),
//                     label: S.of(context).profile,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/offer_cubit/offer_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/product_cubit/product_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/store_category_cubit/store_category_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/store_cubit/store_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/notifications/presentation/manger/notifications_cubit/notification_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/update_screen/data/repos/update_repo_impl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../../core/utils/local_storage_helper.dart';
import '../../../../../generated/l10n.dart';
import '../../../../cart/presentation/views/stores_section.dart';
import '../../../../flash_deals/presentation/manger/flash_deals_cubit/flash_deals_cubit.dart';
import '../../../../flash_deals/presentation/views/flash_deals_view.dart';
import '../../../../profile/presentation/views/profile_view.dart';
import '../../../../update_screen/presentation/manger/update_cubit.dart';
import '../../../../update_screen/presentation/views/maintance_view.dart';
import '../../../../update_screen/presentation/views/update_screen_view.dart';
import '../home_view.dart';
import 'no_internet/no_internet_view.dart';

// Static list of pages to avoid recreation
const List<Widget> _pages = [
  HomeView(),
  FlashDealsScreen(),
  StoresInCartView(),
  ProfileScreen(),
];

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  // Consolidated initialization logic
  Future<void> _initialize() async {
    if (Supabase.instance.client.auth.currentUser != null) {
      await LocalStorageHelper.updateUserFromInternet(
          Supabase.instance.client.auth.currentUser!.id);
    }
    await Future.wait([
      _checkForUpdate(),
      _requestNotificationPermission(),
      context.read<ProductCubit>().getProducts(),
      context.read<StoreCubit>().getStores(),
      context.read<OfferCubit>().getOffers(),
      context.read<StoreCategoryCubit>().getStoreCategory(),
    ]);
  }

  // Optimized update check using provided UpdateCubit
  Future<void> _checkForUpdate() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;
      final updateCubit = context.read<UpdateCubit>();
      await updateCubit.getUpdate();

      if (!mounted) return;

      if (updateCubit.state is GetUpdateSuccess) {
        final latest = (updateCubit.state as GetUpdateSuccess).updateModel;
        if (latest.isUnderMaintenance) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MaintenanceView()),
          );
        } else if (latest.version != currentVersion) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => UpdateScreenView(updateModel: latest),
            ),
          );
        }
      }
    } catch (e) {
      log("Error checking for update: $e");
    }
  }

  // Optimized notification permission request
  Future<bool> _requestNotificationPermission() async {
    try {
      final status = await Permission.notification.status;
      if (status.isGranted) {
        log("✅ Notification permission already granted");
        return true;
      }
      final newStatus = await Permission.notification.request();
      if (newStatus.isGranted) {
        log("🎉 Notification permission granted");
        return true;
      } else {
        log("⚠️ Notification permission denied");
      }
    } catch (e) {
      log("❌ Error requesting notification permission: $e");
    }
    return false;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return MultiBlocListener(
      listeners: [
        BlocListener<StoreCubit, StoreState>(
          listenWhen: (previous, current) => current is GetStoresError,
          listener: (context, state) {
            log("GetStoresError: ${(state as GetStoresError).errorMessage}");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const NoInternetView()),
            );
          },
        ),
        BlocListener<StoreCategoryCubit, StoreCategoryState>(
          listenWhen: (previous, current) => current is GetStoreCategoriesError,
          listener: (context, state) {
            log("GetStoreCategoriesError: ${(state as GetStoreCategoriesError).errorMessage}");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const NoInternetView()),
            );
          },
        ),
        BlocListener<NotificationCubit, NotificationState>(
          listenWhen: (previous, current) => current is GetNotificationFailure,
          listener: (context, state) {
            log("GetNotificationFailure: ${(state as GetNotificationFailure).failure}");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const NoInternetView()),
            );
          },
        ),
        BlocListener<FlashDealsCubit, FlashDealsState>(
          listenWhen: (previous, current) => current is GetFlashDealsError,
          listener: (context, state) {
            log("GetFlashDealsError: ${(state as GetFlashDealsError).error}");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const NoInternetView()),
            );
          },
        ),
        BlocListener<OfferCubit, OfferState>(
          listenWhen: (previous, current) => current is GetOffersError,
          listener: (context, state) {
            log("GetOffersError: ${(state as GetOffersError).errorMessage}");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const NoInternetView()),
            );
          },
        ),
        BlocListener<ProductCubit, ProductState>(
          listenWhen: (previous, current) => current is GetProductsError,
          listener: (context, state) {
            log("GetProductsError: ${(state as GetProductsError).errorMessage}");
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const NoInternetView()),
            );
          },
        ),
      ],
      child: BlocBuilder<UpdateCubit, UpdateState>(
        buildWhen: (previous, current) =>
        current is GetUpdateSuccess || current is GetUpdateLoading,
        builder: (context, updateState) {
          log('StoreCubit: ${context.read<StoreCubit>().state}');
          log('NotificationCubit: ${context.read<NotificationCubit>().state}');
          log('StoreCategoryCubit: ${context.read<StoreCategoryCubit>().state}');
          log('FlashDealsCubit: ${context.read<FlashDealsCubit>().state}');
          log('OfferCubit: ${context.read<OfferCubit>().state}');
          log('ProductCubit: ${context.read<ProductCubit>().state}');
          log('UpdateCubit: $updateState');

          final isLoading = updateState is GetUpdateLoading ||
              context.watch<StoreCubit>().state is! GetStoresSuccess ||
              context.watch<NotificationCubit>().state is! GetNotificationSuccess ||
              context.watch<StoreCategoryCubit>().state is! GetStoreCategoriesSuccess ||
              context.watch<FlashDealsCubit>().state is! GetFlashDealsSuccess ||
              context.watch<OfferCubit>().state is! GetOffersSuccess ||
              context.watch<ProductCubit>().state is! GetProductsSuccess;

          return Skeletonizer(
            enabled: isLoading,
            child: Scaffold(
              extendBody: true,
              body: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _pages[_selectedIndex],
              ),
              bottomNavigationBar: Container(
                margin: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.025,
                  horizontal: screenWidth * 0.05,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.90),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow:  [
                    BoxShadow(
                      color: Theme.of(context).brightness==Brightness.dark?Colors.white12:Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                    selectedItemColor: Theme.of(context).colorScheme.primary,
                    unselectedItemColor: Colors.grey[500],
                    enableFeedback: true,
                    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    unselectedLabelStyle: const TextStyle(),
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(
                          _selectedIndex == 0 ? Icons.home : Icons.home_outlined,
                        ),
                        label: S.of(context).home,
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          _selectedIndex == 1
                              ? FontAwesomeIcons.boltLightning
                              : FontAwesomeIcons.bolt,
                        ),
                        label: S.of(context).flashDeals,
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          _selectedIndex == 2
                              ? Icons.shopping_cart
                              : Icons.shopping_cart_outlined,
                        ),
                        label: S.of(context).cart,
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(
                          _selectedIndex == 3 ? Icons.person : Icons.person_outline,
                        ),
                        label: S.of(context).profile,
                      ),
                    ],
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