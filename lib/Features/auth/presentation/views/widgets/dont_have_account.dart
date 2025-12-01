import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/styles/app_styles.dart';
import '../../../../../generated/l10n.dart';
import '../sign_up_view.dart';

class DontHaveAccount extends StatelessWidget {
  const DontHaveAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style:AppStyles.semiBold16(context),
        children: [
          TextSpan(text: "${S.of(context).dontHaveAccount} "),
          TextSpan(
            text: S.of(context).createAccount,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpView(),));
              },
          ),
        ],
      ),
    );
  }
}
