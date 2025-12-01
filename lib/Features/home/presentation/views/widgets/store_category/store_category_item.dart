import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/data/models/store_category_model/store_category_model.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/store_cubit/store_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/store_category/stories_screen_categories.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';

import '../../../../../../core/utils/styles/app_styles.dart';


class StoreCategoryItem extends StatelessWidget {
  final StoreCategory category;

  const StoreCategoryItem({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 2,right: 8,left: 8),
      child: GestureDetector(
        onTap: () {
          //هنا
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ProductsScreen(
          //       products: context
          //           .read<ProductCubit>()
          //           .products
          //           .where((element) => element.categoryId == category.id)
          //           .toList(),
          //       title: LanguageHelper.isArabic()
          //           ? category.arabicName
          //           : category.englishName,
          //     ),
          //   ),
          // );



          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoriesScreenCategories(
                stories: context
                    .read<StoreCubit>()
                    .stores
                    .where((element) => element.storeCategoryId == category.id)
                    .toList(),
                title: LanguageHelper.isArabic()?category.arabicName:category.englishName, subStoreCategories: category.storeSubCategory,

              ),
            ),
          );
        },
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).cardColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ✅ خلفية رمادية للصورة
              AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: ShapeDecoration(
                    color: Colors.grey[200],
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ), // الخلفية الرمادية
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CachedNetworkImage(
                      imageUrl:category.logoUrl,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) =>
                          const Icon(Icons.category, size: 30),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // اسم الفئة
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  LanguageHelper.isArabic()
                      ? category.arabicName
                      : category.englishName,
                  style: AppStyles.semiBold14(context),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
