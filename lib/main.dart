import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/data/repos/auth_repo_impl.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/presentation/manger/login_cubit/login_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/cart/data/repos/cart_repo_impl.dart';
import 'package:multi_vendor_e_commerce_app/Features/flash_deals/presentation/manger/flash_deals_cubit/flash_deals_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/data/repos/home_repo_impl.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/store_cubit/store_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/my_orders/data/repos/my_order_repo/my_order_repo_impl.dart';
import 'package:multi_vendor_e_commerce_app/Features/notifications/data/repos/notification_repo_impl.dart';
import 'package:multi_vendor_e_commerce_app/Features/update_screen/data/repos/update_repo_impl.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/local_notification_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'Features/auth/presentation/manger/reset_password_cubit/reset_password_cubit.dart';
import 'Features/cart/presentation/manger/cart_cubit/cart_cubit.dart';
import 'Features/home/presentation/manger/category_cubit/category_cubit.dart';
import 'Features/home/presentation/manger/offer_cubit/offer_cubit.dart';
import 'Features/home/presentation/manger/product_cubit/product_cubit.dart';
import 'Features/home/presentation/manger/store_category_cubit/store_category_cubit.dart';
import 'Features/my_orders/presentation/manger/local_order_cubit/local_order_cubit.dart';
import 'Features/my_orders/presentation/manger/order_cubit/order_cubit.dart';
import 'Features/notifications/presentation/manger/notifications_cubit/notification_cubit.dart';
import 'Features/splash/presentation/views/splash_view.dart';
import 'Features/update_screen/presentation/manger/update_cubit.dart';
import 'core/utils/theme_and_local/theme_and_local_cubit.dart';
import 'core/utils/theme_and_local/app_themes.dart';
import 'generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: "https://hegfuluilgqgbcvtnymv.supabase.co",
    anonKey:
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhlZ2Z1bHVpbGdxZ2JjdnRueW12Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTM5NjY4MTAsImV4cCI6MjA2OTU0MjgxMH0.1_zZ2sKOW0FKobr9V8FwAfq2kaqF6CdiQS42PU71HfM",
  );
  await LocalNotificationServices.init();
  await Firebase.initializeApp();
  FirebaseMessaging.instance.subscribeToTopic('all_users');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OfferCubit>(
          create: (context) => OfferCubit(HomeRepoImpl())..getOffers(),
        ),
        BlocProvider<StoreCubit>(
          create: (context) => StoreCubit(HomeRepoImpl())..getStores(),
        ),
        BlocProvider<ProductCubit>(
          create: (context) => ProductCubit(HomeRepoImpl())..getProducts(),
        ),
        BlocProvider<CategoryCubit>(
          create: (context) => CategoryCubit(HomeRepoImpl())..getCategories(),
        ),
        BlocProvider<StoreCategoryCubit>(
          create: (context) => StoreCategoryCubit(HomeRepoImpl())..getStoreCategory(),
        ),
        BlocProvider<CartCubit>(
          create: (context) => CartCubit(CartRepoImpl())..loadCartFromStorage(context),
        ),
        BlocProvider<ThemeAndLocalCubit>(
          create: (context) => ThemeAndLocalCubit()..loadPreferences(),
        ),
        BlocProvider<FlashDealsCubit>(

          create: (context) => FlashDealsCubit(HomeRepoImpl())..getFlashDeals(),
        ),
        BlocProvider<NotificationCubit>(

          create: (context) => NotificationCubit(NotificationRepoImpl())..getNotifications(),
        ),
        BlocProvider<ResetPasswordCubit>(

          create: (context) => ResetPasswordCubit(),
        ),
        BlocProvider<LoginCubit>(

          create: (context) => LoginCubit(AuthRepoImpl()),
        ),
        BlocProvider<LocalOrderCubit>(
          create: (_) => LocalOrderCubit(MyOrderRepoImpl()),
        ),
        BlocProvider<OrderCubit>(
          create: (_) => OrderCubit(MyOrderRepoImpl()),
        ),  BlocProvider<UpdateCubit>(
          create: (_) => UpdateCubit(UpdateRepoImpl())..getUpdate(),
        ),
      ],
      child: BlocBuilder<ThemeAndLocalCubit, ThemeAndLocalState>(
        builder: (context, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Locale(state.locale),
          title: 'MyFe',
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('ar', ''),
          ],
          theme: AppThemes.lightThemes[state.theme] ?? AppThemes.lightThemes['blue']!,
          darkTheme: AppThemes.darkThemes[state.theme] ?? AppThemes.darkThemes['blue']!,

          themeMode: state.isDark ? ThemeMode.dark : ThemeMode.light,
          home: const SplashView(),
        ),
      ),
    );
  }
}




