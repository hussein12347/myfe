// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/data/models/offer_model/offer_model.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/data/models/store_category_model/store_category_model.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/category_cubit/category_cubit.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/offer_cubit/offer_cubit.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/product_cubit/product_cubit.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/store_cubit/store_cubit.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/best_selling_header.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/bottom_nav_height.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/home_header.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/offers_bar.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/shops.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/store_category/store_categories_list.dart';
// import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/store_category/store_category_screen.dart';
// import 'package:multi_vendor_e_commerce_app/core/models/store_model.dart';
// import 'package:multi_vendor_e_commerce_app/core/utils/widgets/products_screen.dart';
// import 'package:multi_vendor_e_commerce_app/core/utils/widgets/product/products_sliver_grid.dart';
// import 'package:multi_vendor_e_commerce_app/core/models/product_model.dart';
// import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_text_field.dart';
// import 'package:skeletonizer/skeletonizer.dart';
// import '../../../../core/utils/widgets/products_and_stores_screen.dart';
// import '../../../../generated/l10n.dart';
// import '../../../../core/utils/widgets/stories_screen.dart';
// import '../manger/store_category_cubit/store_category_cubit.dart';
//
// class HomeView extends StatefulWidget {
//   const HomeView({super.key});
//
//   @override
//   State<HomeView> createState() => _HomeViewState();
// }
//
// class _HomeViewState extends State<HomeView> {
//   late TextEditingController _searchController;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _searchController=TextEditingController();
//   }
//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     _searchController.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: RefreshIndicator(
//         onRefresh: () async {
//           final productCubit = context.read<ProductCubit>();
//           final storeCubit = context.read<StoreCubit>();
//           final offerCubit = context.read<OfferCubit>();
//           final categoryCubit = context.read<CategoryCubit>();
//           final storeCategoryCubit = context.read<StoreCategoryCubit>();
//
//           await productCubit.getProducts();
//           await storeCubit.getStores();
//           await offerCubit.getOffers();
//           await categoryCubit.getCategories();
//           await storeCategoryCubit.getStoreCategory();
//         },
//
//         child: CustomScrollView(
//           slivers: [
//             const SliverToBoxAdapter(child: SizedBox(height: 30)),
//             const SliverToBoxAdapter(child: HomeHeader()),
//             const SliverToBoxAdapter(child: SizedBox(height: 10)),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: CustomTextFormField(
//                   hintText: S.of(context).searchProductOrStore,
//                   controller: _searchController,
//                   prefixIcon: FontAwesomeIcons.search,
//                   onSubmit: (value) => Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ProductsStores(
//                         products: context.read<ProductCubit>().products,
//                         stores: context.read<StoreCubit>().stores,
//                         productSearchQuery: value,
//                         storeSearchQuery: value,
//                         title: S.of(context).searchResults,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SliverToBoxAdapter(child: SizedBox(height: 10)),
//             SliverToBoxAdapter(
//               child: BlocBuilder<OfferCubit, OfferState>(
//                 builder: (context, state) {
//                   final isLoading =
//                       (state is! GetOffersSuccess &&
//                       context.watch<ProductCubit>().state
//                           is! GetProductsSuccess);
//                   List<OfferModel> offers = state is GetOffersSuccess
//                       ? state.offers
//                       : [
//                           OfferModel(
//                             id: "1",
//                             arabicName: "عرض الصيف المجنون ☀️",
//                             englishName: "Crazy Summer Offer",
//                             imageUrl: "https://picsum.photos/300/200?random=1",
//                             deleteImageUrl: "https://delete.fake.com/1",
//                             createdAt: DateTime.now().subtract(
//                               const Duration(days: 1),
//                             ),
//                             offerProducts: [],
//                           ),
//                           OfferModel(
//                             id: "2",
//                             arabicName: "خصم العيد الكبير 🎉",
//                             englishName: "Eid Mega Sale",
//                             imageUrl: "https://picsum.photos/300/200?random=2",
//                             deleteImageUrl: "https://delete.fake.com/2",
//                             createdAt: DateTime.now().subtract(
//                               const Duration(days: 2),
//                             ),
//                             offerProducts: [],
//                           ),
//                           OfferModel(
//                             id: "3",
//                             arabicName: "عرض العودة للمدارس 🎒",
//                             englishName: "Back to School Offer",
//                             imageUrl: "https://picsum.photos/300/200?random=3",
//                             deleteImageUrl: "https://delete.fake.com/3",
//                             createdAt: DateTime.now().subtract(
//                               const Duration(days: 3),
//                             ),
//                             offerProducts: [],
//                           ),
//                         ];
//                   return Skeletonizer(
//                     enabled: isLoading,
//                     child: OffersBar(offers: offers),
//                   );
//                 },
//               ),
//             ),
//
//
//             // SliverToBoxAdapter(child: SizedBox(height: 20)),
//             // SliverToBoxAdapter(
//             //   child: Padding(
//             //     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             //     child: BlocBuilder<CategoryCubit, CategoryState>(
//             //       builder: (context, state) => Skeletonizer(
//             //         enabled: (state is! GetCategoriesSuccess),
//             //         child: BestSellingHeader(
//             //           tittle: S.of(context).categories,
//             //           onTap: () {
//             //             Navigator.push(
//             //               context,
//             //               MaterialPageRoute(
//             //                 builder: (context) => CategoryScreen(
//             //                   categories: (state is! GetCategoriesSuccess)
//             //                       ? [
//             //                           CategoryModel(
//             //                             arabicName: 'name',
//             //                             englishName: 'e name',
//             //                             createdAt: DateTime.now(),
//             //                             id: 'sasa',
//             //                             isShow: true,
//             //                             imageUrl:
//             //                                 'https://cdn-icons-png.flaticon.com/512/706/706164.png',
//             //                           ),
//             //                           CategoryModel(
//             //                             arabicName: 'name',
//             //                             englishName: 'e name',
//             //                             createdAt: DateTime.now(),
//             //                             id: 'sasa',
//             //                             isShow: true,
//             //                             imageUrl:
//             //                                 'https://cdn-icons-png.flaticon.com/512/706/706164.png',
//             //                           ),
//             //                         ]
//             //                       : state.categories,
//             //                 ),
//             //               ),
//             //             );
//             //           },
//             //         ),
//             //       ),
//             //     ),
//             //   ),
//             // ),
//             //
//             // SliverToBoxAdapter(child: SizedBox(height: 10)),
//             // SliverToBoxAdapter(
//             //   child: BlocBuilder<CategoryCubit, CategoryState>(
//             //     builder: (context, state) => Skeletonizer(
//             //       enabled: state is! GetCategoriesSuccess,
//             //       child: Categories(
//             //         categories: (state is! GetCategoriesSuccess)
//             //             ? [
//             //                 CategoryModel(
//             //                   arabicName: 'name',
//             //                   englishName: 'e name',
//             //                   createdAt: DateTime.now(),
//             //                   id: 'sasa',
//             //                   isShow: true,
//             //                   imageUrl:
//             //                       'https://cdn-icons-png.flaticon.com/512/706/706164.png',
//             //                 ),
//             //                 CategoryModel(
//             //                   arabicName: 'name',
//             //                   englishName: 'e name',
//             //                   createdAt: DateTime.now(),
//             //                   id: 'sasa',
//             //                   isShow: true,
//             //                   imageUrl:
//             //                       'https://cdn-icons-png.flaticon.com/512/706/706164.png',
//             //                 ),
//             //               ]
//             //             : state.categories,
//             //       ),
//             //     ),
//             //   ),
//             // ),
//
//             /////////////////////////////////////////
//             const SliverToBoxAdapter(child: SizedBox(height: 20)),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: BlocBuilder<StoreCategoryCubit, StoreCategoryState>(
//                   builder: (context, state) => Skeletonizer(
//                     enabled: (state is! GetStoreCategoriesSuccess),
//                     child: BestSellingHeader(
//                       tittle: S.of(context).categories,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => StoreCategoryScreen(
//                               categories: (state is! GetStoreCategoriesSuccess)
//                                   ? [
//                                 StoreCategory(
//                                   arabicName: 'name',
//                                   englishName: 'e name',
//                                   createdAt: DateTime.now(),
//                                   id: 'sasa',
//                                   isShow: true,
//                                   logoUrl:
//                                   'https://cdn-icons-png.flaticon.com/512/706/706164.png',
//                                   stores: [],
//                                   storeSubCategory: [],
//                                 ),
//                                 StoreCategory(
//                                   arabicName: 'name',
//                                   englishName: 'e name',
//                                   createdAt: DateTime.now(),
//                                   id: 'sasa',
//                                   isShow: true,
//                                   logoUrl:
//                                   'https://cdn-icons-png.flaticon.com/512/706/706164.png',
//                                   stores: [],
//                                   storeSubCategory: [],
//                                 ),
//                               ]
//                                   : state.categories,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             const SliverToBoxAdapter(child: SizedBox(height: 10)),
//             SliverToBoxAdapter(
//               child: BlocBuilder<StoreCategoryCubit, StoreCategoryState>(
//                 builder: (context, state) => Skeletonizer(
//                   enabled: state is! GetStoreCategoriesSuccess,
//                   child: StoreCategoriesList(
//                     categories: (state is! GetStoreCategoriesSuccess)
//                         ? [
//                             StoreCategory(
//                               arabicName: 'name',
//                               englishName: 'e name',
//                               createdAt: DateTime.now(),
//                               id: 'sasa',
//                               isShow: true,
//                               logoUrl:
//                                   'https://cdn-icons-png.flaticon.com/512/706/706164.png',
//                               stores: [],
//                               storeSubCategory: [],
//                             ),
//                             StoreCategory(
//                               arabicName: 'name',
//                               englishName: 'e name',
//                               createdAt: DateTime.now(),
//                               id: 'sasa',
//                               isShow: true,
//                               logoUrl:
//                                   'https://cdn-icons-png.flaticon.com/512/706/706164.png',
//                               stores: [],
//                               storeSubCategory: [],
//                             ),
//                           ]
//                         : state.categories,
//                   ),
//                 ),
//               ),
//             ),
//
//             ///////////////////////////////////////////
//             const SliverToBoxAdapter(child: SizedBox(height: 5)),
//             BlocBuilder<ProductCubit, ProductState>(
//               builder: (context, state) {
//                 if (state is! GetProductsSuccess) {
//                   return SliverToBoxAdapter(
//                     child: Skeletonizer(
//                       enabled: true,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: BestSellingHeader(
//                           tittle: S.of(context).bestSeller,
//                           onTap: () {},
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//                 return SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: BestSellingHeader(
//                       tittle: S.of(context).bestSeller,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ProductsScreen(
//                               products: [...state.products]
//                                 ..sort(
//                                   (a, b) => (b.boughtTimes ?? 0).compareTo(
//                                     a.boughtTimes ?? 0,
//                                   ),
//                                 ),
//                               title: S.of(context).bestSeller,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//             BlocBuilder<ProductCubit, ProductState>(
//               builder: (context, state) {
//                 if (state is! GetProductsSuccess) {
//                   return ProductsSliverGrid(
//                     isHome: true,
//                     isLoading: true,
//                     products: _getPlaceholderProducts(),
//                   );
//                 }
//                 return ProductsSliverGrid(
//                   isHome: true,
//                   isLoading: false,
//                   products: [...state.products]
//                     ..sort(
//                       (a, b) =>
//                           (b.boughtTimes ?? 0).compareTo(a.boughtTimes ?? 0),
//                     ),
//                 );
//               },
//             ),
//             const SliverToBoxAdapter(child: SizedBox(height: 5)),
//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: BlocBuilder<StoreCubit, StoreState>(
//                   builder: (context, state) => Skeletonizer(
//                     enabled:
//                         (state is! GetStoresSuccess &&
//                         context.watch<ProductCubit>().state
//                             is! GetProductsSuccess),
//                     child: BestSellingHeader(
//                       tittle: S.of(context).stores,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => StoriesScreen(
//                               stories: state is GetStoresSuccess
//                                   ? state.stores
//                                   : _getPlaceholderStores(),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SliverToBoxAdapter(child: SizedBox(height: 10)),
//             SliverToBoxAdapter(
//               child: BlocBuilder<StoreCubit, StoreState>(
//                 builder: (context, state) => Skeletonizer(
//                   enabled:
//                       (state is! GetStoresSuccess &&
//                       context.watch<ProductCubit>().state
//                           is! GetProductsSuccess),
//                   child: Shops(
//                     stories: state is GetStoresSuccess
//                         ? state.stores
//                         : _getPlaceholderStores(),
//                   ),
//                 ),
//               ),
//             ),
//             const SliverToBoxAdapter(child: SizedBox(height: 10)),
//             BlocBuilder<ProductCubit, ProductState>(
//               builder: (context, state) {
//                 if (state is! GetProductsSuccess) {
//                   return SliverToBoxAdapter(
//                     child: Skeletonizer(
//                       enabled: true,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                         child: BestSellingHeader(
//                           tittle: S.of(context).latest,
//                           onTap: () {},
//                         ),
//                       ),
//                     ),
//                   );
//                 }
//                 return SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: BestSellingHeader(
//                       tittle: S.of(context).latest,
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => ProductsScreen(
//                               products: state.products
//                                 ..sort(
//                                   (a, b) =>
//                                       b.createdAt.compareTo(a.createdAt),
//                                 ),
//                               title: S.of(context).latest,
//                             ),
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//             BlocBuilder<ProductCubit, ProductState>(
//               builder: (context, state) {
//                 if (state is! GetProductsSuccess) {
//                   return ProductsSliverGrid(
//                     isLoading: true,
//                     isHome: true,
//                     products: _getPlaceholderProducts(),
//                   );
//                 }
//                 return ProductsSliverGrid(
//                   isLoading: false,
//                   isHome: true,
//                   products: [...state.products]
//                     ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
//                 );
//               },
//             ),
//             SliverToBoxAdapter(
//               child: SizedBox(
//                 height: AppDimensions.getBottomBarTotalHeight(context),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<ProductModel> _getPlaceholderProducts() {
//     return List.generate(
//       4,
//       (_) => ProductModel(
//         createdAt: DateTime.now().toString(),
//         id: 'id',
//         arabicName: 'arabicName',
//         englishName: 'englishName',
//         arabicDescription: 'arabicDescription',
//         englishDescription: 'englishDescription',
//         price: 50,
//         weight: 1,
//         oldPrice: 12,
//         isShow: true,
//         quantity: 5,
//         storeId: 'storeId',
//         wishlists: [],
//         store: StoreModel(
//           userRating: 5,
//           deleteImageUrl: 'fdsfdsfds',
//           id: 'id',
//           arabic_name: 'arabic_name',
//           english_name: "english_name",
//           imageUrl: "imageUrl",
//           arabic_description: "description",
//           english_description: "description",
//           userId: "userId",
//           createdAt: DateTime.now(),
//           isShow: true,
//           // rating: 4.5,
//           // ratingCount: 25,
//           favoriteStores: [],
//           lat: 1,
//           log: 1, storeBranches: []
//         ),
//         rates: []
//        , productImages: [],
//       ),
//     );
//   }
//
//   List<StoreModel> _getPlaceholderStores() {
//     return List.generate(
//       3,
//       (_) => StoreModel(
//         lat: 1,
//         log: 1,
//         favoriteStores: [],
//         userRating: 5,
//         deleteImageUrl: 'fdsfdsfd',
//         id: "id",
//         arabic_name: "storeName",
//         english_name: "storeName",
//         imageUrl: "imageUrl",
//         arabic_description: "description",
//         english_description: "description",
//         userId: "userId",
//         createdAt: DateTime.now(),
//         isShow: true, storeBranches: [],
//         // rating: 4.5,
//         // ratingCount: 5,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/data/models/offer_model/offer_model.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/data/models/store_category_model/store_category_model.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/category_cubit/category_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/offer_cubit/offer_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/product_cubit/product_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/store_cubit/store_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/best_selling_header.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/bottom_nav_height.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/home_header.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/offers_bar.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/shops.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/store_category/store_categories_list.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/views/widgets/store_category/store_category_screen.dart';
import 'package:multi_vendor_e_commerce_app/core/models/store_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/products_screen.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/product/products_sliver_grid.dart';
import 'package:multi_vendor_e_commerce_app/core/models/product_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_text_field.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/utils/widgets/products_and_stores_screen.dart';
import '../../../../core/utils/widgets/stories_screen.dart';
import '../../../../generated/l10n.dart';
import '../manger/store_category_cubit/store_category_cubit.dart';

// Predefined placeholder data to avoid repeated creation
final List<ProductModel> _placeholderProducts = List.generate(
  4,
      (_) => ProductModel(
    createdAt: DateTime.now().toString(),
    id: 'id',
    arabicName: 'arabicName',
    englishName: 'englishName',
    arabicDescription: 'arabicDescription',
    englishDescription: 'englishDescription',
    price: 50,
    weight: 1,
    oldPrice: 12,
    isShow: true,
    quantity: 5,
    storeId: 'storeId',
    wishlists: [],
    store: StoreModel(
      storeSubCategoryRelations: [],

      userRating: 5,
      deleteImageUrl: 'fdsfdsfds',
      id: 'id',
      arabic_name: 'arabic_name',
      english_name: "english_name",
      imageUrl: "imageUrl",
      arabic_description: "description",
      english_description: "description",
      userId: "userId",
      createdAt: DateTime.now(),
      isShow: true,
      lat: 1,
      log: 1,
      storeBranches: [],
      favoriteStores: [],
    ),
    rates: [],
    productImages: [], sub_category_id: '',
  ),
);

final List<StoreModel> _placeholderStores = List.generate(
  3,
      (_) => StoreModel(
        storeSubCategoryRelations: [],
    lat: 1,
    log: 1,
    favoriteStores: [],
    userRating: 5,
    deleteImageUrl: 'fdsfdsfd',
    id: "id",
    arabic_name: "storeName",
    english_name: "storeName",
    imageUrl: "imageUrl",
    arabic_description: "description",
    english_description: "description",
    userId: "userId",
    createdAt: DateTime.now(),
    isShow: true,
    storeBranches: [],
  ),
);

final List<OfferModel> _placeholderOffers = [
  OfferModel(
    id: "1",
    arabicName: "عرض الصيف المجنون ☀️",
    englishName: "Crazy Summer Offer",
    imageUrl: "https://picsum.photos/300/200?random=1",
    deleteImageUrl: "https://delete.fake.com/1",
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    offerProducts: [],
  ),
  OfferModel(
    id: "2",
    arabicName: "خصم العيد الكبير 🎉",
    englishName: "Eid Mega Sale",
    imageUrl: "https://picsum.photos/300/200?random=2",
    deleteImageUrl: "https://delete.fake.com/2",
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
    offerProducts: [],
  ),
  OfferModel(
    id: "3",
    arabicName: "عرض العودة للمدارس 🎒",
    englishName: "Back to School Offer",
    imageUrl: "https://picsum.photos/300/200?random=3",
    deleteImageUrl: "https://delete.fake.com/3",
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    offerProducts: [],
  ),
];

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    // _fetchInitialData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async{
          final cubits = [
            context.read<ProductCubit>().getProducts(),
            context.read<StoreCubit>().getStores(),
            context.read<OfferCubit>().getOffers(),
            context.read<StoreCategoryCubit>().getStoreCategory(),
          ];
          await Future.wait(cubits);
        },
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 30)),
            const SliverToBoxAdapter(child: HomeHeader()),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomTextFormField(
                  hintText: S.of(context).searchProductOrStore,
                  controller: _searchController,
                  prefixIcon: FontAwesomeIcons.search,
                  onSubmit: (value) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductsStores(
                        products: context.read<ProductCubit>().products,
                        stores: context.read<StoreCubit>().stores,
                        productSearchQuery: value,
                        storeSearchQuery: value,
                        title: S.of(context).searchResults,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: BlocBuilder<OfferCubit, OfferState>(
                buildWhen: (previous, current) =>
                current is GetOffersSuccess || previous is! GetOffersSuccess,
                builder: (context, state) {
                  final isLoading = state is! GetOffersSuccess;
                  return Skeletonizer(
                    enabled: isLoading,
                    child: OffersBar(
                      offers: state is GetOffersSuccess
                          ? state.offers
                          : _placeholderOffers,
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: BlocBuilder<StoreCategoryCubit, StoreCategoryState>(
                  buildWhen: (previous, current) =>
                  current is GetStoreCategoriesSuccess ||
                      previous is! GetStoreCategoriesSuccess,
                  builder: (context, state) {
                    return Skeletonizer(
                      enabled: state is! GetStoreCategoriesSuccess,
                      child: BestSellingHeader(
                        tittle: S.of(context).categories,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreCategoryScreen(
                                categories: state is GetStoreCategoriesSuccess
                                    ? state.categories
                                    : [
                                  StoreCategory(
                                    arabicName: 'name',
                                    englishName: 'e name',
                                    createdAt: DateTime.now(),
                                    id: 'sasa',
                                    isShow: true,
                                    logoUrl:
                                    'https://cdn-icons-png.flaticon.com/512/706/706164.png',
                                    stores: [],
                                    storeSubCategory: [],
                                  ),
                                  StoreCategory(
                                    arabicName: 'name',
                                    englishName: 'e name',
                                    createdAt: DateTime.now(),
                                    id: 'sasa',
                                    isShow: true,
                                    logoUrl:
                                    'https://cdn-icons-png.flaticon.com/512/706/706164.png',
                                    stores: [],
                                    storeSubCategory: [],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: BlocBuilder<StoreCategoryCubit, StoreCategoryState>(
                buildWhen: (previous, current) =>
                current is GetStoreCategoriesSuccess ||
                    previous is! GetStoreCategoriesSuccess,
                builder: (context, state) {
                  return Skeletonizer(
                    enabled: state is! GetStoreCategoriesSuccess,
                    child: StoreCategoriesList(
                      categories: state is GetStoreCategoriesSuccess
                          ? state.categories
                          : [
                        StoreCategory(
                          arabicName: 'name',
                          englishName: 'e name',
                          createdAt: DateTime.now(),
                          id: 'sasa',
                          isShow: true,
                          logoUrl:
                          'https://cdn-icons-png.flaticon.com/512/706/706164.png',
                          stores: [],
                          storeSubCategory: [],
                        ),
                        StoreCategory(
                          arabicName: 'name',
                          englishName: 'e name',
                          createdAt: DateTime.now(),
                          id: 'sasa',
                          isShow: true,
                          logoUrl:
                          'https://cdn-icons-png.flaticon.com/512/706/706164.png',
                          stores: [],
                          storeSubCategory: [],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 5)),
            SliverToBoxAdapter(
              child: BlocBuilder<ProductCubit, ProductState>(
                buildWhen: (previous, current) =>
                current is GetProductsSuccess ||
                    previous is! GetProductsSuccess,
                builder: (context, state) {
                  return Skeletonizer(
                    enabled: state is! GetProductsSuccess,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: BestSellingHeader(
                        tittle: S.of(context).bestSeller,
                        onTap: state is GetProductsSuccess
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductsScreen(
                                products: [...state.products]
                                  ..sort((a, b) => (b.boughtTimes ?? 0)
                                      .compareTo(a.boughtTimes ?? 0)),
                                title: S.of(context).bestSeller,
                              ),
                            ),
                          );
                        }
                            : () {},
                      ),
                    ),
                  );
                },
              ),
            ),
            BlocBuilder<ProductCubit, ProductState>(
              buildWhen: (previous, current) =>
              current is GetProductsSuccess ||
                  previous is! GetProductsSuccess,
              builder: (context, state) {
                return ProductsSliverGrid(
                  isHome: true,
                  isLoading: state is! GetProductsSuccess,
                  products: state is GetProductsSuccess
                      ? ([...state.products]
                    ..sort((a, b) =>
                        (b.boughtTimes ?? 0).compareTo(a.boughtTimes ?? 0)))
                      : _placeholderProducts,
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 5)),
            SliverToBoxAdapter(
              child: BlocBuilder<StoreCubit, StoreState>(
                buildWhen: (previous, current) =>
                current is GetStoresSuccess || previous is! GetStoresSuccess,
                builder: (context, state) {
                  return Skeletonizer(
                    enabled: state is! GetStoresSuccess,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: BestSellingHeader(
                        tittle: S.of(context).stores,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoriesScreen(
                                stories: state is GetStoresSuccess
                                    ? state.stores
                                    : _placeholderStores,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: BlocBuilder<StoreCubit, StoreState>(
                buildWhen: (previous, current) =>
                current is GetStoresSuccess || previous is! GetStoresSuccess,
                builder: (context, state) {
                  return Skeletonizer(
                    enabled: state is! GetStoresSuccess,
                    child: Shops(
                      stories: state is GetStoresSuccess
                          ? state.stores
                          : _placeholderStores,
                    ),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(
              child: BlocBuilder<ProductCubit, ProductState>(
                buildWhen: (previous, current) =>
                current is GetProductsSuccess ||
                    previous is! GetProductsSuccess,
                builder: (context, state) {
                  return Skeletonizer(
                    enabled: state is! GetProductsSuccess,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: BestSellingHeader(
                        tittle: S.of(context).latest,
                        onTap: state is GetProductsSuccess
                            ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductsScreen(
                                products: [...state.products]
                                  ..sort((a, b) =>
                                      b.createdAt.compareTo(a.createdAt)),
                                title: S.of(context).latest,
                              ),
                            ),
                          );
                        }
                            : () {},
                      ),
                    ),
                  );
                },
              ),
            ),
            BlocBuilder<ProductCubit, ProductState>(
              buildWhen: (previous, current) =>
              current is GetProductsSuccess ||
                  previous is! GetStoresSuccess,
              builder: (context, state) {
                return ProductsSliverGrid(
                  isLoading: state is! GetProductsSuccess,
                  isHome: true,
                  products: state is GetProductsSuccess
                      ? ([...state.products]
                    ..sort((a, b) => b.createdAt.compareTo(a.createdAt)))
                      : _placeholderProducts,
                );
              },
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: AppDimensions.getBottomBarTotalHeight(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}