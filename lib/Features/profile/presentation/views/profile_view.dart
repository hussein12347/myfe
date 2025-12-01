import 'package:e_commerce_app/core/constant/constant.dart';
import 'package:e_commerce_app/core/logic/get_best_selling_product_data/get_product_data_cubit.dart';
import 'package:e_commerce_app/core/widgets/showMessage.dart';
import 'package:e_commerce_app/core/widgets/type_products_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/logic/get_user_data/get_user_data_cubit.dart';
import '../../../generated/l10n.dart';
import '../../../main.dart';
import '../../myOrders_screen/views/my_orders_view.dart';

import '../widgets/about_us.dart';
import '../widgets/change_password.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _changeLanguage(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Directionality(
            textDirection: kIsArabic() ? TextDirection.rtl : TextDirection.ltr,
            // العنوان يمين
            child: Text(S.of(context).choose_language),
          ),
          content: Directionality(
            textDirection: kIsArabic() ? TextDirection.ltr : TextDirection.rtl,
            // المحتوى يسار
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: const Text('العربية'),
                  onTap: () async {
                    await prefs.setString('language_code', 'ar');
                    _restartApp(context);
                  },
                ),
                ListTile(
                  title: const Text('English'),
                  onTap: () async {
                    await prefs.setString('language_code', 'en');
                    _restartApp(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _restartApp(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final String? langCode = prefs.getString('language_code');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder:
            (context) => MyApp(
              initialLocale:
                  langCode != null ? Locale(langCode) : const Locale('ar'),
            ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          SizedBox(height: 65.h),
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  child: SvgPicture.asset(
                    'assets/image/images/user.svg',
                    height: 30.r,
                    width: 30.r,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.read<GetUserDataCubit>().userModel!.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  context.read<GetUserDataCubit>().userModel!.email,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            S.of(context).general,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          // _buildMenuItem(
          //   title: S.of(context).my_account,
          //   icon: Icons.person_outline,
          //   onTap: () {
          //     // TODO: انتقل للملف الشخصي
          //   },
          // ),
          _buildMenuItem(
            isSvg: true,
            title: S.of(context).myOrders,
            icon: Icons.inventory_2_outlined,
            imagePath: 'assets/image/images/box.svg',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyOrdersView()),
              );
            },
          ),

          _buildMenuItem(
            title: S.of(context).favorites,
            icon: Icons.favorite_outline,
            isSvg: false,

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => TypeProductsScreen(
                    title: S.of(context).favorites,
                    products:
                    context
                        .read<GetProductDataCubit>()
                        .bestSellingProductModelList
                        .where(
                          (element) =>
                      element.favoriteProducts.isNotEmpty,
                    )
                        .toList(), // تحويل Iterable إلى List
                    onRefresh:
                        () async =>
                    await context
                        .read<GetProductDataCubit>()
                        .getBestSellingProductData(), isHaveSearch: false,
                  ),
                ),
              );
            },
          ),

          // _buildSwitchItem(title: 'الإشعارات', icon: Icons.notifications),
          ListTile(
            leading: const Icon(Icons.language, color: Colors.green),
            title: Text(
              S.of(context).language,
              style: TextStyle(
                color: const Color(0xff949D9E),
                fontSize: kFontSize13,
              ),
            ),
            trailing: Text(
              kIsArabic() ? 'العربية' : "English",
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () => _changeLanguage(context),
          ),
          // _buildSwitchItem(title: 'الوضع', icon: Icons.color_lens),
          const SizedBox(height: 24),
          Text(
            S.of(context).help,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          _buildMenuItem(
            title: S.of(context).changePassword,
            icon: Icons.password_sharp,
            isSvg: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ChangePasswordScreen(

                  ),
                ),
              );
            },
          ),
          _buildMenuItem(
            title: S.of(context).contact_support,
            icon: Icons.support_agent_outlined,
              onTap: () async {
                final Uri whatsappUrl = Uri.parse('https://wa.me/201150155517');

                try {
                  final canLaunch = await canLaunchUrl(whatsappUrl);
                  if (!canLaunch) {
                    throw 'الرابط مش مدعوم على الجهاز 😢';
                  }

                  final launched = await launchUrl(
                    whatsappUrl,
                    mode: LaunchMode.externalApplication,
                  );

                  if (!launched) {
                    throw 'فشل في فتح واتساب 😞';
                  }
                } catch (e) {
                  debugPrint('🚨 خطأ أثناء محاولة فتح واتساب: $e');
                  ShowMessage.showToast(S.of(context).unexpectedError);

                }
              }
          ),   const SizedBox(height: 8),
          _buildMenuItem(
            title: S.of(context).about_us,
            icon: Icons.info_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUs()),
              );
            },
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.withOpacity(0.1),
              foregroundColor: Colors.green,
              minimumSize: const Size.fromHeight(48),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              await context.read<GetUserDataCubit>().clearUserData();
              final prefs = await SharedPreferences.getInstance();
              final String? langCode = prefs.getString('language_code');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => MyApp(
                        initialLocale:
                            langCode != null
                                ? Locale(langCode)
                                : const Locale('ar'),
                      ),
                ),
                (route) => false,
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(S.of(context).logout),
                SizedBox(width: 18.w), // المسافة بين النص والأيقونة
                kIsArabic()
                    ? SvgPicture.asset(
                      'assets/image/images/logout.svg',
                      height: 18,
                      width: 18,
                    )
                    : const Icon(Icons.logout),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    String imagePath = "",
    bool isSvg = false,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading:
          isSvg
              ? SvgPicture.asset(
                imagePath,
                width: 20,
                height: 20,
                color: kLightPrimaryColor,
              )
              : Icon(icon, color: kLightPrimaryColor),
      title: Text(
        title,
        style: TextStyle(color: Color(0xff949D9E), fontSize: kFontSize13),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem({required String title, required IconData icon}) {
    return SwitchListTile(
      secondary: Icon(icon, color: Colors.green),
      title: Text(title),
      value: false,
      onChanged: (value) {
        // TODO: التعامل مع التبديل
      },
    );
  }
}
