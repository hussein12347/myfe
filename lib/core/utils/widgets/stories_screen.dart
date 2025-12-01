import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/core/models/store_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/stories_screen_body.dart';

import '../../../generated/l10n.dart';

class StoriesScreen extends StatefulWidget {
  final List<StoreModel> stories;
  final String?title;


  const StoriesScreen({super.key, required this.stories, this.title});

  @override
  State<StoriesScreen> createState() => _StoriesScreenState();
}

class _StoriesScreenState extends State<StoriesScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title??S.of(context).stores)),
      body: StoriesScreenBody(
        controller: controller,
        stories: widget.stories,
      ),
    );
  }
}
