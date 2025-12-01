import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/core/models/product_model.dart';
import 'package:multi_vendor_e_commerce_app/core/models/store_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/products_screen_body.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/stories_screen_body.dart';
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';
import '../functions/is_arabic.dart';

class ProductsStores extends StatefulWidget {
  final List<ProductModel> products;
  final List<StoreModel> stores;
  final bool isFavoritesPage;
  final String? storeSearchQuery;
  final String? productSearchQuery;
  final String title;

  const ProductsStores({
    super.key,
    required this.products,
    required this.stores,
    this.isFavoritesPage = false,
    this.storeSearchQuery,
    this.productSearchQuery, required this.title,
  });

  @override
  State<ProductsStores> createState() => _ProductsStoresState();
}

class _ProductsStoresState extends State<ProductsStores> {
  final TextEditingController productSearchController = TextEditingController();
  final TextEditingController storeSearchController = TextEditingController();
  final TextEditingController priceFromController = TextEditingController();
  final TextEditingController priceToController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<ProductModel> filteredProducts = [];
  String selectedSort = '';
  String productSearchQuery = '';

  @override
  void initState() {
    super.initState();
    // Initialize filteredProducts with all products
    filteredProducts = widget.products;
    // Apply productSearchQuery if provided
    if (widget.productSearchQuery != null && widget.productSearchQuery!.isNotEmpty) {
      productSearchQuery = widget.productSearchQuery!.toLowerCase();
      _filterProducts(productSearchQuery);
      productSearchController.text = productSearchQuery;
    }
    // Apply storeSearchQuery if provided
    if (widget.storeSearchQuery != null && widget.storeSearchQuery!.isNotEmpty) {
      storeSearchController.text = widget.storeSearchQuery!;
    }
  }

  @override
  void didUpdateWidget(ProductsStores oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reapply product filtering if productSearchQuery changes
    if (widget.productSearchQuery != oldWidget.productSearchQuery) {
      productSearchQuery = widget.productSearchQuery?.toLowerCase() ?? '';
      _filterProducts(productSearchQuery);
      productSearchController.text = productSearchQuery;
    }
    // Reapply store search if storeSearchQuery changes
    if (widget.storeSearchQuery != oldWidget.storeSearchQuery) {
      storeSearchController.text = widget.storeSearchQuery ?? '';
    }
  }

  @override
  void dispose() {
    productSearchController.dispose();
    storeSearchController.dispose();
    priceFromController.dispose();
    priceToController.dispose();
    super.dispose();
  }

  void _filterProducts(String query) {
    setState(() {
      productSearchQuery = query.toLowerCase();
      filteredProducts = widget.products.where((product) {
        if (LanguageHelper.isArabic()) {
          return product.arabicName.toLowerCase().contains(productSearchQuery) ||
              product.arabicDescription.toLowerCase().contains(productSearchQuery);
        } else {
          return product.englishName.toLowerCase().contains(productSearchQuery) ||
              product.englishDescription.toLowerCase().contains(productSearchQuery);
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : Colors.grey,
            tabs: [
              Tab(text: S.of(context).products),
              Tab(text: S.of(context).stores),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ProductsBody(
              products: widget.products,
              filteredProducts: widget.isFavoritesPage
                  ? filteredProducts.where((element) => element.wishlists.isNotEmpty).toList()
                  : filteredProducts,
              selectedSort: selectedSort,
              searchController: productSearchController, // Use product-specific controller
              priceFromController: priceFromController,
              priceToController: priceToController,
              formKey: formKey,
              onSearchChanged: _filterProducts,
              onFilterApplied: (List<ProductModel> filtered) {
                setState(() {
                  filteredProducts = filtered;
                });
              },
              onSortApplied: (String sortType, List<ProductModel> sorted) {
                setState(() {
                  selectedSort = sortType;
                  filteredProducts = sorted;
                });
              },
            ),
            StoriesScreenBody(
              controller: storeSearchController, // Use store-specific controller
              stories: widget.stores,
              storeSearchQuery: widget.storeSearchQuery,
            ),
          ],
        ),
      ),
    );
  }
}
