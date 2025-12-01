import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/store_cubit/store_cubit.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/store_item.dart';
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';
import '../../../Features/home/presentation/views/widgets/bottom_nav_height.dart';
import '../../models/store_model.dart';
import 'custom_text_field.dart';

class StoriesScreenBody extends StatefulWidget {
  final TextEditingController controller;
  final List<StoreModel> stories;
  final String? storeSearchQuery;
  final bool isLoading;

  const StoriesScreenBody({
    super.key,
    required this.controller,
    required this.stories,
    this.storeSearchQuery,
    this.isLoading = false,
  });

  @override
  State<StoriesScreenBody> createState() => _StoriesScreenBodyState();
}

class _StoriesScreenBodyState extends State<StoriesScreenBody> {
  @override
  void initState() {
    super.initState();
    if (widget.storeSearchQuery != null && widget.storeSearchQuery!.isNotEmpty) {
      widget.controller.text = widget.storeSearchQuery!;
    }
  }

  @override
  void didUpdateWidget(StoriesScreenBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.storeSearchQuery != oldWidget.storeSearchQuery &&
        widget.storeSearchQuery != null &&
        widget.storeSearchQuery!.isNotEmpty) {
      widget.controller.text = widget.storeSearchQuery!;
      setState(() {});
    }
  }

  List<StoreModel> _filterStores(String query) {
    if (query.isEmpty) return widget.stories;
    final lowerQuery = query.toLowerCase();
    return widget.stories.where((store) {
      if (LanguageHelper.isArabic()) {
        return store.arabic_name.toLowerCase().contains(lowerQuery);
      } else {
        return store.english_name.toLowerCase().contains(lowerQuery);
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final query = widget.controller.text.isNotEmpty
        ? widget.controller.text.toLowerCase()
        : (widget.storeSearchQuery?.toLowerCase() ?? '');
    final filteredStores = _filterStores(query);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomTextFormField(
            hintText: S.of(context).searchStore,
            controller: widget.controller,
            onChange: (_) => setState(() {}),
            prefixIcon: FontAwesomeIcons.search,
          ),
        ),
        Expanded(
          child: CustomScrollView(
            slivers: [
              filteredStores.isEmpty
                  ? SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Text(
                    S.of(context).no_stores_found,
                    style: AppStyles.semiBold16(context)
                        .copyWith(color: Colors.grey),
                  ),
                ),
              )
                  : SliverPadding(
                padding: const EdgeInsets.all(8.0),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final store = filteredStores[index];
                      return StoreItem(
                        store: store,
                        favoriteOnPressed: () async {
                          await context
                              .read<StoreCubit>()
                              .likeOnTap(store.id);
                        },
                        isDark: Theme.of(context).brightness ==
                            Brightness.dark,
                      );
                    },
                    childCount: filteredStores.length,
                  ),
                  gridDelegate:
                  const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 140,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                    childAspectRatio: 0.75,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  height: AppDimensions.getBottomBarTotalHeight(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
