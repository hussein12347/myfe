import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/Features/splash/presentation/views/widgets/splash_view_body.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: Center(child: SplashBody()),
    );
  }
}
