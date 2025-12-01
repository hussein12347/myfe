import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/store_category/stories_acreen_categories_body.dart';
import 'package:multi_vendor_e_commerce_app/core/models/store_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/stories_screen_body.dart';

import '../../../../data/models/store_category_model/sub_store_category.dart';


class StoriesScreenCategories extends StatefulWidget {
  final List<StoreModel> stories;
  final String title;
  final  List<SubStoreCategory> subStoreCategories;


  const StoriesScreenCategories({super.key, required this.stories,required this.title, required this.subStoreCategories});

  @override
  State<StoriesScreenCategories> createState() => _StoriesScreenCategoriesState();
}

class _StoriesScreenCategoriesState extends State<StoriesScreenCategories> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),
      ),
      body: StoriesScreenCategoriesBody(
        controller: controller,
        stories: widget.stories, subStoreCategories: widget.subStoreCategories, title: widget.title,
      ),
    );
  }
}
