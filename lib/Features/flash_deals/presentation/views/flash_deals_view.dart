import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_vendor_e_commerce_app/Features/flash_deals/presentation/manger/flash_deals_cubit/flash_deals_cubit.dart';
import 'package:multi_vendor_e_commerce_app/core/models/product_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/products_screen_body.dart';
import '../../../../generated/l10n.dart';

class FlashDealsScreen extends StatefulWidget {
  const FlashDealsScreen({super.key});

  @override
  State<FlashDealsScreen> createState() => _FlashDealsScreenState();
}

class _FlashDealsScreenState extends State<FlashDealsScreen> {
  List<ProductModel> allFlashProducts = [];
  List<ProductModel> filteredProducts = [];
  String searchQuery = '';
  String selectedSort = 'default';

  final TextEditingController searchController = TextEditingController();
  final TextEditingController priceFromController = TextEditingController();
  final TextEditingController priceToController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void _filterProducts(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredProducts = allFlashProducts.where((product) {
        if (LanguageHelper.isArabic()) {
          return product.arabicName.toLowerCase().contains(searchQuery) ||
              product.arabicDescription.toLowerCase().contains(searchQuery);
        } else {
          return product.englishName.toLowerCase().contains(searchQuery) ||
              product.englishDescription.toLowerCase().contains(searchQuery);
        }
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).flashDeals),
      ),
      body: BlocBuilder<FlashDealsCubit, FlashDealsState>(
        builder: (context, state) {
          if (state is GetFlashDealsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetFlashDealsSuccess) {
            final flashDeals = state.flashDeals;

            // Initialize the original and filtered lists once
            if (allFlashProducts.isEmpty && flashDeals.isNotEmpty) {
              allFlashProducts = flashDeals.map((deal) => deal.product).toList();
              filteredProducts = List.from(allFlashProducts);
            }

            return RefreshIndicator(
              onRefresh: () async {
                await context.read<FlashDealsCubit>().getFlashDeals();
                setState(() {
                  allFlashProducts = flashDeals.map((deal) => deal.product).toList();
                  filteredProducts = List.from(allFlashProducts);
                  searchController.clear();
                  priceFromController.clear();
                  priceToController.clear();
                  searchQuery = '';
                  selectedSort = 'default';
                });
              },
              child: ProductsBody(
                products: allFlashProducts,
                filteredProducts: filteredProducts,
                selectedSort: selectedSort,
                searchController: searchController,
                priceFromController: priceFromController,
                priceToController: priceToController,
                formKey: formKey,
                onSearchChanged: _filterProducts,
                onFilterApplied: (filteredList) {
                  setState(() {
                    filteredProducts = filteredList;
                  });
                },
                onSortApplied: (sort, sortedList) {
                  setState(() {
                    selectedSort = sort;
                    filteredProducts = sortedList;
                  });
                },
              ),
            );
          } else if (state is GetFlashDealsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<FlashDealsCubit>().getFlashDeals(),
                    child: Text('Retry'),
                  ),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
