import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/nav_bar.dart';
import '../../../../../core/utils/styles/app_styles.dart';
import '../../../../../generated/l10n.dart';

class ContinueAsGuestText extends StatelessWidget {
  const ContinueAsGuestText({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppStyles.semiBold16(context),
        children: [
          // TextSpan(text: "${S.of(context).dontWantToSignIn} "), // ترجمها من ملفك
          TextSpan(
            text: S.of(context).continueAsGuest, // "كمل كزائر"
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // هنا تقدر تحط دالة تسجيل كزائر أو تروح صفحة معينة
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const NavBar()),
                );
              },
          ),
        ],
      ),
    );
  }
}
