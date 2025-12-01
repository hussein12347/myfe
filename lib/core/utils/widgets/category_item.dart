// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/product_cubit/product_cubit.dart';
// import 'package:multi_vendor_e_commerce_app/core/models/category_model.dart';
// import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
// import 'package:multi_vendor_e_commerce_app/core/utils/widgets/products_screen.dart';
//
// import '../styles/app_styles.dart';
//
// class CategoryItem extends StatelessWidget {
//   final CategoryModel category;
//
//   const CategoryItem({super.key, required this.category});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 8, top: 2),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ProductsScreen(
//                 products: context
//                     .read<ProductCubit>()
//                     .products
//                     .where((element) => element.categoryId == category.id)
//                     .toList(),
//                 title: LanguageHelper.isArabic()
//                     ? category.arabicName
//                     : category.englishName,
//               ),
//             ),
//           );
//         },
//         child: Container(
//           width: 100,
//           margin: const EdgeInsets.symmetric(horizontal: 8),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(16),
//             color: Theme.of(context).cardColor,
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 4,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // ✅ خلفية رمادية للصورة
//               AspectRatio(
//                 aspectRatio: 1,
//                 child: Container(
//                   decoration: ShapeDecoration(
//                     color: Colors.grey[200],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadiusGeometry.only(
//                         topLeft: Radius.circular(16),
//                         topRight: Radius.circular(16),
//                       ),
//                     ), // الخلفية الرمادية
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Image.network(
//                       category.imageUrl,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) =>
//                           Icon(Icons.category, size: 30),
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 8),
//
//               // اسم الفئة
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 4.0),
//                 child: Text(
//                   LanguageHelper.isArabic()
//                       ? category.arabicName
//                       : category.englishName,
//                   style: AppStyles.semiBold14(context),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
