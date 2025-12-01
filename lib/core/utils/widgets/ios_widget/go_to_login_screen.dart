import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_vendor_e_commerce_app/Features/auth/presentation/views/login_view.dart';

import '../../../../generated/assets.dart';
import '../../../../generated/l10n.dart';
import '../../styles/app_styles.dart';

class GoToLoginScreen extends StatelessWidget {

  const GoToLoginScreen({super.key, });

  @override
  Widget build(BuildContext context) {
    final lang=S.of(context);
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // لوتي
                Lottie.asset(
                  Assets.jsonLogin,
                  height: 300,
                  repeat: true,
                ),

                const SizedBox(height: 24),

                // العنوان
                Text(
                  lang.loginRequired, // "يجب تسجيل الدخول" / "Login Required"
                  style: AppStyles.bold32(context),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // الوصف
                Text(
                  lang.loginToContinue,
                  // "من فضلك سجّل الدخول للمتابعة"
                  // "Please log in to continue"
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.color
                        ?.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 32),

                // زر تسجيل الدخول
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor:
                    Theme.of(context).colorScheme.primary,
                    elevation: 4,
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginView()),
                          (route) => false, // دي بتمسح كل الصفحات القديمة
                    );
                  },
                  icon: const Icon(Icons.login_rounded, size: 22),
                  label: Text(
                    lang.login, // "تسجيل الدخول" / "Login"
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
