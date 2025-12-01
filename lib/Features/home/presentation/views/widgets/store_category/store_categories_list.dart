import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/store_category/store_category_item.dart';

import '../../../../data/models/store_category_model/store_category_model.dart';


class StoreCategoriesList extends StatelessWidget {
  final List<StoreCategory>categories;
  const StoreCategoriesList({
    super.key, required this.categories,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140, // ارتفاع أكبر لاستيعاب المحتوى
      child: ListView.builder(
        itemCount: categories.length, // عدد المتاجر
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // تأثير تمرير طبيعي
        padding: const EdgeInsets.symmetric(horizontal: 16), // تباعد جانبي
        itemBuilder: (context, index) {
          return StoreCategoryItem(category: categories[index],);
        },

      ),
    );
  }
}

