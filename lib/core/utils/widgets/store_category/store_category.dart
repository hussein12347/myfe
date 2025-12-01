// import 'package:flutter/material.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
// import 'package:multi_vendor_e_commerce_app/core/utils/widgets/category_item.dart';
// import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_text_field.dart';
//
// import '../../../generated/l10n.dart';
// import '../../models/category_model.dart';
//
// class CategoryScreen extends StatefulWidget {
//   final List<CategoryModel> categories;
//
//   const CategoryScreen({super.key, required this.categories});
//
//   @override
//   State<CategoryScreen> createState() => _CategoryScreenState();
// }
//
// class _CategoryScreenState extends State<CategoryScreen> {
//   final TextEditingController controller = TextEditingController();
//   late List<CategoryModel> filteredCategories;
//
//   @override
//   void initState() {
//     super.initState();
//     filteredCategories = widget.categories; // في البداية بنعرض الكل
//   }
//
//   void _filterCategories(String query) {
//     setState(() {
//       if (LanguageHelper.isArabic()) {
//         filteredCategories = widget.categories
//             .where(
//               (category) =>
//               category.arabicName.toLowerCase().contains(query.toLowerCase()),
//         )
//             .toList();
//       }else{
//         filteredCategories = widget.categories
//             .where(
//               (category) =>
//               category.englishName.toLowerCase().contains(query.toLowerCase()),
//         )
//             .toList();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(S.of(context).categories)),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: CustomTextFormField(
//               hintText: S.of(context).searchCategory,
//               controller: controller,
//               onChange: _filterCategories,
//               prefixIcon: FontAwesomeIcons.search,
//             ),
//           ),
//
//           Expanded(
//             child: CustomScrollView(
//               slivers: [
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Center(
//                       child: Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: List.generate(
//                           filteredCategories.length,
//                               (index) => SizedBox(
//                             width: 100,
//                             child: CategoryItem(
//                               category: filteredCategories[index],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
