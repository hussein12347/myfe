import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/store_category/store_category_item.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_text_field.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../data/models/store_category_model/store_category_model.dart';

class StoreCategoryScreen extends StatefulWidget {
  final List<StoreCategory> categories;

  const StoreCategoryScreen({super.key, required this.categories});

  @override
  State<StoreCategoryScreen> createState() => _StoreCategoryScreenState();
}

class _StoreCategoryScreenState extends State<StoreCategoryScreen> {
  final TextEditingController controller = TextEditingController();
  late List<StoreCategory> filteredCategories;

  @override
  void initState() {
    super.initState();
    filteredCategories = widget.categories;
  }

  void _filterCategories(String query) {
    setState(() {
      if (LanguageHelper.isArabic()) {
        filteredCategories = widget.categories
            .where((category) =>
            category.arabicName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      } else {
        filteredCategories = widget.categories
            .where((category) =>
            category.englishName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).categories)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomTextFormField(
              hintText: S.of(context).searchCategory,
              controller: controller,
              onChange: _filterCategories,
              prefixIcon: FontAwesomeIcons.search,
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                filteredCategories.isEmpty
                    ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      S.of(context).no_categories_found,
                      style: const TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ),
                )
                    : SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverGrid.builder(
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = filteredCategories[index];
                      return StoreCategoryItem(category: category);
                    },
                    gridDelegate:
                    const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 140,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.85,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
