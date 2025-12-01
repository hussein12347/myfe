import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/Features/splash/presentation/views/widgets/sliding_text.dart';
import 'package:multi_vendor_e_commerce_app/generated/assets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/models/user_model.dart';
import '../../../../../core/utils/local_storage_helper.dart';
import '../../../../auth/presentation/views/login_view.dart';
import '../../../../home/presentation/views/widgets/nav_bar.dart';


class SplashBody extends StatefulWidget {
  const SplashBody({super.key});

  @override
  State<SplashBody> createState() => _SplashBodyState();
}

class _SplashBodyState extends State<SplashBody>with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;
  @override
  void initState() {
    super.initState();
    initSlidingAnimation();

    navigateToHome();
  }

  @override
  void dispose() {
    super.dispose();

    animationController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
        child: Stack(
          children: [
              Image.asset(Theme.of(context).brightness == Brightness.light?
              Assets.imagesLogo:Assets.imagesLogo2),

            Positioned(
                bottom:0,
                right: 32,
                child: SlidingText(slidingAnimation: slidingAnimation,)),

          ],
        ),
      ),
    );
  }
  void initSlidingAnimation() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    slidingAnimation =
        Tween<Offset>(begin: const Offset(0, 2), end: Offset.zero)
            .animate(animationController);

    animationController.forward();
  }

  void navigateToHome() {
    Future.delayed(
      const Duration(seconds: 2),
          () async {

        if ((Supabase.instance.client.auth.currentUser)==null) {
          UserModel?user=await  LocalStorageHelper.getUser();

          (user==null) ? Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView(),)):Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavBar(),));
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const NavBar(),));

        }


          },
    );
  }
}
