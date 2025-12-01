// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:multi_vendor_e_commerce_app/core/models/category_model.dart';
// import 'package:multi_vendor_e_commerce_app/core/models/store_model.dart';
// import 'package:multi_vendor_e_commerce_app/core/utils/widgets/category_item.dart';
// import 'package:multi_vendor_e_commerce_app/core/utils/widgets/store_item.dart';
//
// import '../../manger/store_cubit/store_cubit.dart';
//
// class Categories extends StatelessWidget {
//   final List<CategoryModel>categories;
//   const Categories({
//     super.key, required this.categories,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 140, // ارتفاع أكبر لاستيعاب المحتوى
//       child: ListView.builder(
//         itemCount: categories.length, // عدد المتاجر
//         scrollDirection: Axis.horizontal,
//         physics: const BouncingScrollPhysics(), // تأثير تمرير طبيعي
//         padding: const EdgeInsets.symmetric(horizontal: 16), // تباعد جانبي
//         itemBuilder: (context, index) {
//           return CategoryItem(category: categories[index],);
//         },
//
//       ),
//     );
//   }
// }
//
