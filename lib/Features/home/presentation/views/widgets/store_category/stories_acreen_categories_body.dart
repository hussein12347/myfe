import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/data/models/store_category_model/sub_store_category.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/product_cubit/product_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/store_category/category_suggestions.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/product/products_sliver_grid.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/products_screen.dart';
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
    emit(state.copyWith(query: query, isLoading: true));
    emit(state.copyWith(query: query, isLoading: false));
  }

  void updateSubCategory(String subCategoryId) {
    emit(state.copyWith(subCategoryId: subCategoryId, isLoading: true));
    emit(state.copyWith(subCategoryId: subCategoryId, isLoading: false));
  }

  List<ProductModel> filterProducts(
      String query,
      String subCategoryId,
      List<StoreModel> stories,
      List<ProductModel> products) {
    final lowerQuery = query.toLowerCase();
    final isArabic = LanguageHelper.isArabic();

    // نجهز قائمة بمعرفات المتاجر المتاحة فقط للتأكد من عدم عرض منتج لمتجر محذوف أو غير موجود
    final validStoreIds = stories.map((e) => e.id).toSet();

    return products.where((product) {
      // 1. التحقق من أن المنتج ينتمي لمتجر موجود في القائمة
      if (!validStoreIds.contains(product.storeId)) {
        return false;
      }

      // 2. فلترة المنتجات حسب الفئة الفرعية (subCategoryId)
      // تأكد أن الاسم في موديل المنتج هو subCategoryId أو قم بتغييره هنا
      if (subCategoryId != 'all' && product.sub_category_id != subCategoryId) {
        return false;
      }

      // 3. فلترة البحث (Query)
      if (query.isNotEmpty) {
        final matchesName = isArabic
            ? product.arabicName.toLowerCase().contains(lowerQuery)
            : product.englishName.toLowerCase().contains(lowerQuery);
        if (!matchesName) return false;
      }

      return true;
    }).toList();
  }
}

class SearchFilterState {
  final String query;
  final String subCategoryId;
  final bool isLoading;

  SearchFilterState(
      {this.query = '', this.subCategoryId = 'all', this.isLoading = false});

  SearchFilterState copyWith(
      {String? query, String? subCategoryId, bool? isLoading}) {
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
  State<StoriesScreenCategoriesBody> createState() =>
      _StoriesScreenCategoriesBodyState();
}

class _StoriesScreenCategoriesBodyState
    extends State<StoriesScreenCategoriesBody> {
  Timer? _debounce;
  late SearchFilterCubit _searchFilterCubit;

  @override
  void initState() {
    super.initState();
    _searchFilterCubit = SearchFilterCubit();
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
    _searchFilterCubit.close();
    super.dispose();
  }

  List<Category> _buildCategories() {
    final allCategory = Category(id: 'all', name: S.of(context).all);
    final subCategories = widget.subStoreCategories.map((subCategory) {
      return Category(
        id: subCategory.id,
        name: LanguageHelper.isArabic()
            ? subCategory.arabicName
            : subCategory.englishName,
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

          // 1. نفلتر المنتجات أولاً
          final filteredProducts = _searchFilterCubit.filterProducts(
              query, state.subCategoryId, widget.stories, products);

          // 2. نستخرج أرقام المتاجر من المنتجات المفلترة فقط
          // هذا سيجعل قائمة المتاجر تظهر فقط المتاجر التي تبيع المنتجات المفلترة
          final filteredStoreIds =
          filteredProducts.map((product) => product.storeId).toSet();

          final filteredOffers = context
              .read<OfferCubit>()
              .offers
              .where((offer) {
            return offer.offerProducts.any((offerProduct) =>
                filteredStoreIds.contains(offerProduct.product.storeId));
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextFormField(
                  hintText: S.of(context).search,
                  controller: widget.controller,
                  prefixIcon: FontAwesomeIcons.search,
                  onSubmit: (value) {
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
                  ? Center(child: loadingWidget(context))
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
                            style: AppStyles.semiBold16(context)
                                .copyWith(color: Colors.grey),
                          ),
                        ),
                      )
                          : Shops(
                        // نعرض فقط المتاجر التي تحتوي على المنتجات المفلترة
                          stories: widget.stories
                              .where((store) => filteredStoreIds
                              .contains(store.id))
                              .toList()),
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 60.0),
                        child: Divider(),
                      ),
                    ),
                    const SliverToBoxAdapter(
                        child: SizedBox(height: 5)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0),
                        child: BestSellingHeader(
                          tittle: S.of(context).bestSeller,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductsScreen(
                                  products: filteredProducts
                                    ..sort((a, b) => b.boughtTimes!
                                        .compareTo(a.boughtTimes!)),
                                  title: widget.title,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                        child: SizedBox(height: 10)),
                    ProductsSliverGrid(
                      isHome: true,
                      products: filteredProducts
                        ..sort((a, b) => b.boughtTimes!
                            .compareTo(a.boughtTimes!)),
                    ),
                    if (filteredOffers.isNotEmpty)
                      SliverToBoxAdapter(
                        child: OffersBar(offers: filteredOffers),
                      ),
                    const SliverToBoxAdapter(
                        child: SizedBox(height: 5)),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0),
                        child: BestSellingHeader(
                          tittle: S.of(context).latest,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductsScreen(
                                  products: filteredProducts
                                    ..sort((a, b) => b.createdAt
                                        .compareTo(a.createdAt)),
                                  title: widget.title,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(
                        child: SizedBox(height: 10)),
                    ProductsSliverGrid(
                      isHome: true,
                      products: filteredProducts
                        ..sort((a, b) =>
                            b.createdAt.compareTo(a.createdAt)),
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