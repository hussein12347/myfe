
import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/core/models/product_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/product/products_sliver_grid.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/search/custom_search_text_field.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/search/search_filter_actions.dart';
import '../../../../generated/l10n.dart';
import '../../../Features/home/presentation/views/widgets/bottom_nav_height.dart';

class ProductsBody extends StatelessWidget {
  final List<ProductModel> products;
  final List<ProductModel> filteredProducts;
  final String selectedSort;
  final TextEditingController searchController;
  final TextEditingController priceFromController;
  final TextEditingController priceToController;
  final GlobalKey<FormState> formKey;
  final Function(String) onSearchChanged;
  final Function(List<ProductModel>) onFilterApplied;
  final Function(String, List<ProductModel>) onSortApplied;
  final bool isScrollable;

  const ProductsBody({
    super.key,
    required this.products,
    required this.filteredProducts,
    required this.selectedSort,
    required this.searchController,
    required this.priceFromController,
    required this.priceToController,
    required this.formKey,
    required this.onSearchChanged,
    required this.onFilterApplied,
    required this.onSortApplied,  this.isScrollable = true,
  });

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: CustomSearchTextField(
            hintText: locale.searchProduct,
            controller: searchController,
            onChanged: onSearchChanged,
            filterOnPressed: () {
              ProductFilterActions.showPriceFilterSheet(
                context: context,
                products: products,
                fromController: priceFromController,
                toController: priceToController,
                formKey: formKey,
                onApply: onFilterApplied,
              );
            },
            orderOnPressed: () {
              ProductFilterActions.showSortSheet(
                context: context,
                selectedSort: selectedSort,
                currentProducts: filteredProducts,
                onApply: onSortApplied,
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: CustomScrollView(
            physics: !isScrollable?const NeverScrollableScrollPhysics():null,
            slivers: [
              ProductsSliverGrid(products: filteredProducts,isHome: false,),
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
