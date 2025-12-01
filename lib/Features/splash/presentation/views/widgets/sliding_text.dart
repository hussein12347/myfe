import 'package:flutter/material.dart';

import '../../../../../core/utils/styles/app_styles.dart';
import '../../../../../generated/l10n.dart';

class SlidingText extends StatelessWidget {
  const SlidingText({super.key, required this.slidingAnimation});

  final Animation<Offset> slidingAnimation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: slidingAnimation,
      builder: (context, _) {
        return Align(
          alignment: const Alignment(0.9,5),
          // 👈 0.6 معناها قريب لليمين
          // -0.3 معناها فوق المنتصف
          child: SlideTransition(
            position: slidingAnimation,
            child: Text(
              S.of(context).splashWord,
              style: AppStyles.semiBold18 (context).copyWith(
                color: Theme.of(context).brightness == Brightness.light?const Color(0xff131155):Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
    );
  }
}
