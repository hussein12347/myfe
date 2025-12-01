import 'package:e_commerce_app/core/constant/constant.dart';
import 'package:flutter/material.dart';
import '../../../generated/l10n.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(S.of(context).about_us),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            children: [

              Text(
                S.of(context).about_us_screen_content, // استخدمنا النص المتغير من ملف الترجمة
                style: TextStyle(
                  fontSize: kFontSize16,
                  height: 1.6, // زيادة التباعد بين الأسطر لتحسين القراءة
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.justify, // محاذاة النص بشكل متناسق
              ),
            ],
          ),
        ),
      ),
    );
  }
}
