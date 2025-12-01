import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor_e_commerce_app/Features/profile/presentation/widgets/privacy_policy.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/api_services.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/theme_and_local/theme_and_local_cubit.dart';
import 'package:multi_vendor_e_commerce_app/generated/assets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/utils/functions/show_message.dart';
import '../../../../core/utils/local_storage_helper.dart';
import '../../../../core/utils/widgets/ios_widget/go_to_login_screen.dart';
import '../../../../core/utils/widgets/products_and_stores_screen.dart';
import '../../../../generated/l10n.dart';
import '../../../../main.dart';
import '../../../home/presentation/manger/product_cubit/product_cubit.dart';
import '../../../home/presentation/manger/store_cubit/store_cubit.dart';
import '../../../my_orders/presentation/view/order_tap_screen.dart';
import '../widgets/about_us.dart';
import '../widgets/change_password.dart';
import '../widgets/change_personal_details_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Future<void> _changeLanguage(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Directionality(
            textDirection: LanguageHelper.isArabic()
                ? TextDirection.rtl
                : TextDirection.ltr,
            // العنوان يمين
            child: Text(S.of(context).choose_language),
          ),
          content: Directionality(
            textDirection: LanguageHelper.isArabic()
                ? TextDirection.ltr
                : TextDirection.rtl,
            // المحتوى يسار
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title:  Text('العربية',style: AppStyles.semiBold16(context),),
                  onTap: () async {
                    Navigator.pop(context);

                    await context.read<ThemeAndLocalCubit>().changeLanguage('ar');
                  },
                ),
                ListTile(
                  title:  Text('English',style: AppStyles.semiBold16(context)),
                  onTap: () async {
                    Navigator.pop(context);
                    await context.read<ThemeAndLocalCubit>().changeLanguage('en');

                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String? name = "";
  String? job = "";
  String? companyImageUrl = "";
  bool? isEmployee ;

  Future<void> _loadUserName() async {
    final userModel = await LocalStorageHelper.getUser();
     name = userModel?.name;
    job = userModel?.job;
    companyImageUrl = userModel?.company.logoUrl;
    isEmployee = userModel?.role == "employee";
    setState(() {}); // علشان تحدث الـ UI بعد ما الاسم يرجع
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserName();
  }
  String truncateSmart(String? text, int maxLength) {
    if (text == null || text.isEmpty) return "";

    if (text.length <= maxLength) return text;

    // ناخد لحد maxLength
    String cut = text.substring(0, maxLength);

    // لو فيه مسافة → يعني فيه أكتر من كلمة
    if (cut.contains(" ")) {
      List<String> words = cut.split(" ");
      words.removeLast(); // نشيل الكلمة الأخيرة لو ناقصة
      if (words.isEmpty) {
        // في حالة غريبة النص كله كلمة ناقصة
        return "$cut...";
      }
      return "${words.join(" ")}...";
    } else {
      // الكلمة الأولى نفسها أطول من maxLength
      int keep = maxLength - 3; // نخلي مساحة لـ "..."
      return "${text.substring(0, keep)}...";
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Supabase.instance.client.auth.currentUser?.id==null ?const GoToLoginScreen():ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 50),
          Center(
            child: Column(

              children: [
                CircleAvatar(
                  radius: 100,

                  backgroundImage: !(isEmployee ?? false)
                      ? AssetImage(
                    Theme.of(context).brightness == Brightness.light
                        ? Assets.imagesLogo
                        : Assets.imagesLogo2,
                  )
                      : NetworkImage(companyImageUrl ?? ""),
                )
,

                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    name??"",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                      const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,

                  child: Text(
                    job??'',
                    style: const TextStyle(color: Colors.grey),

                  ),
                ),






              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            S.of(context).general,
            style: const TextStyle(fontWeight: FontWeight.bold),
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
            imagePath: Assets.imagesBox,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OrdersTabbedScreen()),
              );
            },
            context: context,
          ),
          _buildMenuItem(
            title: S.of(context).favorites ,
            icon:
              Icons.favorite_outlined,

            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProductsStores(
                  isFavoritesPage: true,
                  stores: context
                      .read<StoreCubit>()
                      .stores
                      .where(
                        (store) => store.favoriteStores.any(
                          (fav) =>
                      fav.storeId == store.id &&
                          fav.userId == Supabase.instance.client.auth.currentUser!.id,
                    ),
                  )
                      .toList(),
                  products: context
                      .read<ProductCubit>()
                      .products
                      .where((element) => element.wishlists.isNotEmpty)
                      .toList(), title: S.of(context).favorites,
                ),
                ),
              );
            }, context: context,
          ),

          // _buildSwitchItem(title: 'الإشعارات', icon: Icons.notifications),
          ListTile(
            leading: Icon(
              Icons.language,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              S.of(context).language,
              style: AppStyles.semiBold14(
                context,
              ).copyWith(color: const Color(0xff949D9E)),
            ),
            trailing: Text(
              LanguageHelper.isArabic() ? 'العربية' : "English",
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () => _changeLanguage(context),
          ),
          BlocBuilder<ThemeAndLocalCubit, ThemeAndLocalState>(
            builder: (context, state) {
              return _buildSwitchItem(
                title: S.of(context).dark_mode,
                icon: Icons.dark_mode,
                value: state.isDark, // هنا بحدد القيمة من الكيوبت
                onChanged: (bool newValue) async {
                  await context.read<ThemeAndLocalCubit>().toggleTheme();
                },
              );
            },
          ),
          // _buildSwitchItem(title: 'الوضع', icon: Icons.color_lens),
          const SizedBox(height: 24),
          Text(
            S.of(context).help,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),

          _buildMenuItem(
            title: S.of(context).changePersonalDetails,
            icon: FontAwesomeIcons.userPen,
            isSvg: false,
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChangePersonalDetailsScreen(),
                ),
              );
              // بعد ما يرجع من الصفحة، نعمل reload
              await _loadUserName();
            },
            context: context,
          ),


          const SizedBox(height: 8),

          _buildMenuItem(
            title: S.of(context).changePassword,
            icon: Icons.password_sharp,
            isSvg: false,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
              );
            },
            context: context,
          ),
          _buildMenuItem(
            title: S.of(context).contact_support,
            icon: Icons.support_agent_outlined,
            onTap: () async {
              final Uri whatsappUrl = Uri.parse('https://wa.me/201000107209');

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
            },
            context: context,
          ),
          _buildMenuItem(
            title: S.of(context).deleteAccount,
            icon: Icons.no_accounts,
            onTap: () async {

              await LocalStorageHelper.clearUser();
              await ApiServices().deleteData(path: "users?id=eq.${Supabase.instance.client.auth.currentUser!.id}");

              await LocalStorageHelper.clearCart();
              await Supabase.instance.client.auth.signOut();
              final prefs = await SharedPreferences.getInstance();
              final String? langCode = prefs.getString('language_code');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyApp(
                    // initialLocale:
                    //     langCode != null
                    //         ? Locale(langCode)
                    //         : const Locale('ar'),
                  ),
                ),
                    (route) => false,
              );
            },
            context: context,
          ),

          const SizedBox(height: 8),
          _buildMenuItem(
            title: S.of(context).about_us,
            icon: Icons.info_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutUs()),
              );
            },
            context: context,
          ),const SizedBox(height: 8),
          _buildMenuItem(
            title: S.of(context).privacy_policy,
            icon: Icons.privacy_tip_outlined,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
              );
            },
            context: context,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(
                context,
              ).colorScheme.secondary.withOpacity(0.1),
              foregroundColor: Theme.of(context).colorScheme.secondary,
              minimumSize: const Size.fromHeight(48),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () async {
              await LocalStorageHelper.clearUser();

              await LocalStorageHelper.clearCart();
              await Supabase.instance.client.auth.signOut();
              final prefs = await SharedPreferences.getInstance();
              final String? langCode = prefs.getString('language_code');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyApp(
                    // initialLocale:
                    //     langCode != null
                    //         ? Locale(langCode)
                    //         : const Locale('ar'),
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
                const SizedBox(width: 18), // المسافة بين النص والأيقونة
                LanguageHelper.isArabic()
                    ? SvgPicture.asset(
                        color: Theme.of(context).colorScheme.secondary,
                        Assets.imagesLogout,
                        height: 18,
                        width: 18,
                      )
                    : const Icon(Icons.logout),
              ],
            ),
          ),
          const SizedBox(height: 35 + kBottomNavigationBarHeight),
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
    required BuildContext context,
  }) {
    return ListTile(
      leading: isSvg
          ? SvgPicture.asset(
              imagePath,
              width: 20,
              height: 20,
              color: Theme.of(context).colorScheme.secondary,
            )
          : Icon(icon, color: Theme.of(context).colorScheme.secondary),
      title: Text(
        title,
        style: AppStyles.semiBold16(context).copyWith(color: const Color(0xff949D9E)),
      ),
      trailing:  Icon(Icons.arrow_forward_ios, size: 16,color: Theme.of(context).colorScheme.secondary,),
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem({
    required String title,
    required IconData icon,
    required bool value,
    required void Function(bool) onChanged,
  }) {
    return SwitchListTile(
      secondary: Icon(icon, color: Theme.of(context).colorScheme.secondary),
      title: Text(title,   style: AppStyles.semiBold16(context).copyWith(color: const Color(0xff949D9E)),),
      value: value,
      onChanged: onChanged,
    );
  }
}
