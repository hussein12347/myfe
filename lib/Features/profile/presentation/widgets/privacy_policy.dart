import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';

import '../../../../generated/l10n.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).privacy_policy),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            children: [

              Text(
                S.of(context).privacy_policy_content, // استخدمنا النص المتغير من ملف الترجمة
                style:  AppStyles.semiBold16(context).copyWith(
                    color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
