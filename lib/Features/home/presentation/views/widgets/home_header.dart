import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor_e_commerce_app/Features/notifications/presentation/views/view/notification_view.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/local_storage_helper.dart';
import 'package:multi_vendor_e_commerce_app/generated/assets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../generated/l10n.dart';
import '../../../../notifications/presentation/manger/notifications_cubit/notification_cubit.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String? userName;
  String? companyName;
  String? logoUrlImage;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final userModel = await LocalStorageHelper.getUser();
    final name = userModel?.name;
    final company = userModel?.company.name;
    final logoUrl = userModel?.company.logoUrl;
    setState(() {
      userName = name ?? Supabase.instance.client.auth.currentUser?.email;
      companyName = company??S.of(context).greeting ;
      logoUrlImage = logoUrl ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:           CircleAvatar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          backgroundImage: (logoUrlImage == null)
              ? AssetImage(
            Theme.of(context).brightness == Brightness.dark
                ? Assets.imagesLogo2
                : Assets.imagesLogo,
          )
              : NetworkImage(logoUrlImage!),),


      title: Text(Supabase.instance.client.auth.currentUser?.id==null?'':companyName??'', style: AppStyles.semiBold24(context).copyWith(color: Theme.of(context).colorScheme.primary)),
      subtitle: Text(userName ?? '', style: AppStyles.medium18(context)),
      trailing: Stack(
        clipBehavior: Clip.none,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationView(),));
            },
            child: CircleAvatar(
              backgroundColor: const Color(0xFFE3F2FD),
              child: Icon(
                FontAwesomeIcons.bell,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          // 🔴 النقطة الحمراء

          if(context.watch<NotificationCubit>().unReadNotifications>0)
          Positioned(
            top: -2,
            right: -2,
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
