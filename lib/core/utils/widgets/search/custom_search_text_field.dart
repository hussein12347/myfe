import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../generated/assets.dart';

class CustomSearchTextField extends StatelessWidget {
  const CustomSearchTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.onSubmitted,
    this.filterOnPressed,
    this.orderOnPressed,
  });

  final String hintText;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final VoidCallback? filterOnPressed;
  final VoidCallback? orderOnPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 9,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: Icon(FontAwesomeIcons.search,color: Theme.of(context).colorScheme.secondary,),
          ),
          suffixIcon: (filterOnPressed != null && orderOnPressed != null)
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: filterOnPressed,
                icon: SvgPicture.asset(
                  color: Theme.of(context).colorScheme.secondary,

                  Assets.imagesFillter,
                ),
              ),
              IconButton(
                onPressed: orderOnPressed,
                icon: SvgPicture.asset(
                  color: Theme.of(context).colorScheme.secondary,
                  Assets.imagesArrowSwapHorizontal,
                ),
              ),
            ],
          )
              : null,
          filled: true,
          fillColor: Theme.of(context).brightness==Brightness.light?Colors.white:null,
          hintStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Color(0xff949D9E),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
