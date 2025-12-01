import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';


class CustomSocialLoginButton extends StatelessWidget {
  const CustomSocialLoginButton({super.key, required this.onPressed, required this.text, this.icon});
  final VoidCallback onPressed;
  final String text;
  final Widget? icon ;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: TextButton(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Theme.of(context).colorScheme.secondary),
            borderRadius: BorderRadius.circular(
              16,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              icon??const SizedBox.shrink(),
              Text(
                  text,
                  style:AppStyles.semiBold18(context)
              ),
              const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}