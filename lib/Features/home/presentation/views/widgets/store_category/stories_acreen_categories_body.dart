import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/data/models/store_category_model/sub_store_category.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/product_cubit/product_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/store_cubit/store_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/store_category/category_suggestions.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/product/products_sliver_grid.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/products_screen.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/store_item.dart';
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';
import '../../../../../../core/models/product_model.dart';
import '../../../../../../core/models/store_model.dart';
import '../../../../../../core/utils/widgets/custom_text_field.dart';
import '../../../../../../core/utils/widgets/loading_widget.dart';
import '../../../manger/offer_cubit/offer_cubit.dart';
import '../best_selling_header.dart';
import '../offers_bar.dart';
import '../shops.dart';

// Cubit for managing search and category state
class SearchFilterCubit extends Cubit<SearchFilterState> {
  SearchFilterCubit() : super(SearchFilterState());

  void updateQuery(String query) {
    print('Updating query: $query'); // Debug print
    emit(state.copyWith(query: query, isLoading: true));
    emit(state.copyWith(query: query, isLoading: false));
  }

  void updateSubCategory(String subCategoryId) {
    print('Updating subCategoryId: $subCategoryId'); // Debug print
    emit(state.copyWith(subCategoryId: subCategoryId, isLoading: true));
    emit(state.copyWith(subCategoryId: subCategoryId, isLoading: false));
  }

  List<ProductModel> filterProducts(String query, String subCategoryId, List<StoreModel> stories, List<ProductModel> products) {
    final lowerQuery = query.toLowerCase();
    final isArabic = LanguageHelper.isArabic();

    // Filter stores by subCategoryId
    final filteredStoreIds = subCategoryId == 'all'
        ? stories.map((store) => store.id).toSet()
        : stories.where((store) => store.storeSubCategoryId == subCategoryId).map((store) => store.id).toSet();

    print('Filtering products: query=$query, subCategoryId=$subCategoryId, storeCount=${filteredStoreIds.length}'); // Debug print

    // Filter products by store and query
    final result = products.where((product) {
      final isInCategory = filteredStoreIds.contains(product.storeId);
      if (!isInCategory) return false;

      if (query.isEmpty) return true;

      return isArabic
          ? product.arabicName?.toLowerCase().contains(lowerQuery) ?? false
          : product.englishName?.toLowerCase().contains(lowerQuery) ?? false;
    }).toList();

    print('Filtered products count: ${result.length}'); // Debug print
    return result;
  }
}

class SearchFilterState {
  final String query;
  final String subCategoryId;
  final bool isLoading;

  SearchFilterState({this.query = '', this.subCategoryId = 'all', this.isLoading = false});

  SearchFilterState copyWith({String? query, String? subCategoryId, bool? isLoading}) {
    return SearchFilterState(
      query: query ?? this.query,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class StoriesScreenCategoriesBody extends StatefulWidget {
  final TextEditingController controller;
  final List<StoreModel> stories;
  final List<SubStoreCategory> subStoreCategories;
  final String title;

  const StoriesScreenCategoriesBody({
    super.key,
    required this.controller,
    required this.stories,
    required this.subStoreCategories,
    required this.title,
  });

  @override
  State<StoriesScreenCategoriesBody> createState() => _StoriesScreenCategoriesBodyState();
}

class _StoriesScreenCategoriesBodyState extends State<StoriesScreenCategoriesBody> {
  Timer? _debounce;
  late SearchFilterCubit _searchFilterCubit;

  @override
  void initState() {
    super.initState();
    _searchFilterCubit = SearchFilterCubit();
    // Initialize controller listener to sync with Cubit
    widget.controller.addListener(() {
      _onSearchChanged(widget.controller.text);
    });
    if (widget.controller.text.isNotEmpty) {
      _searchFilterCubit.updateQuery(widget.controller.text);
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.controller.removeListener(() {
      _onSearchChanged(widget.controller.text);
    });
    widget.controller.dispose(); // Dispose controller
    _searchFilterCubit.close(); // Close Cubit
    super.dispose();
  }

  List<Category> _buildCategories() {
    final allCategory = Category(id: 'all', name: S.of(context).all);
    final subCategories = widget.subStoreCategories.map((subCategory) {
      return Category(
        id: subCategory.id,
        name: LanguageHelper.isArabic() ? subCategory.arabicName : subCategory.englishName,
        imageUrl: subCategory.logoUrl,
      );
    }).toList();
    return [allCategory, ...subCategories];
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 100), () {
      _searchFilterCubit.updateQuery(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final products = context.read<ProductCubit>().products; // Cache products
    return BlocProvider.value(
      value: _searchFilterCubit,
      child: BlocBuilder<SearchFilterCubit, SearchFilterState>(
        builder: (context, state) {
          final query = state.query.toLowerCase();
          final filteredProducts = _searchFilterCubit.filterProducts(query, state.subCategoryId, widget.stories, products);
          final filteredStoreIds = filteredProducts.map((product) => product.storeId).toSet();
          final filteredOffers = context.read<OfferCubit>().offers.where((offer) {
            return offer.offerProducts.any((offerProduct) => filteredStoreIds.contains(offerProduct.product.storeId));
          }).toList();

          print('Building UI with query: $query, subCategory: ${state.subCategoryId}, filteredProducts: ${filteredProducts.length}, isLoading: ${state.isLoading}'); // Debug print

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextFormField(
                  hintText: S.of(context).search,
                  controller: widget.controller,
                  prefixIcon: FontAwesomeIcons.search,
                  onSubmit: (value) {
                    print('Search submitted: $value'); // Debug print
                    _searchFilterCubit.updateQuery(value);
                  },
                ),
              ),
              CategorySuggestions(
                categories: _buildCategories(),
                onCategorySelected: (subCategoryId) {
                  _searchFilterCubit.updateSubCategory(subCategoryId);
                },
              ),
              state.isLoading
                  ?  Center(child: loadingWidget(context))
                  : filteredProducts.isEmpty
                  ? Center(child: Text(S.of(context).no_products_found))
                  : Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: widget.stories.isEmpty
                          ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            S.of(context).no_stores_found,
                            style: AppStyles.semiBold16(context).copyWith(color: Colors.grey),
                          ),
                        ),
                      )
                          : Shops(stories: widget.stories.where((store) => filteredStoreIds.contains(store.id)).toList()),
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60.0),
                        child: Divider(),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 5)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: BestSellingHeader(
                          tittle: S.of(context).bestSeller,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductsScreen(
                                  products: filteredProducts
                                    ..sort((a, b) => b.boughtTimes!.compareTo(a.boughtTimes!)),
                                  title: widget.title,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),
                    ProductsSliverGrid(
                      isHome: true,
                      products: filteredProducts
                        ..sort((a, b) => b.boughtTimes!.compareTo(a.boughtTimes!)),
                    ),
                    if (filteredOffers.isNotEmpty)
                      SliverToBoxAdapter(
                        child: OffersBar(offers: filteredOffers),
                      ),
                    const SliverToBoxAdapter(child: SizedBox(height: 5)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: BestSellingHeader(
                          tittle: S.of(context).latest,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductsScreen(
                                  products: filteredProducts
                                    ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!)),
                                  title: widget.title,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 10)),
                    ProductsSliverGrid(
                      isHome: true,
                      products: filteredProducts
                        ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!)),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}