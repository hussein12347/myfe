import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/store_cubit/store_cubit.dart';
import 'package:multi_vendor_e_commerce_app/core/models/product_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/show_message.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/local_storage_helper.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/product/products_sliver_grid.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/search/custom_search_text_field.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/search/search_filter_actions.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/store_item.dart';
import '../../../../generated/l10n.dart';
import '../../../Features/home/presentation/views/widgets/bottom_nav_height.dart';
import '../../models/store_model.dart';
import '../functions/calculate_distance.dart';
import '../styles/app_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreProductsScreen extends StatefulWidget {
  final List<ProductModel> products;
  final StoreModel store;

  const StoreProductsScreen({super.key, required this.products, required this.store});

  @override
  State<StoreProductsScreen> createState() => _StoreProductsScreenState();
}

class _StoreProductsScreenState extends State<StoreProductsScreen> {
  List<ProductModel> filteredProducts = [];
  String searchQuery = '';
  String selectedSort = 'default';

  final TextEditingController searchController = TextEditingController();
  final TextEditingController priceFromController = TextEditingController();
  final TextEditingController priceToController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    filteredProducts = widget.products;
  }

  void _filterProducts(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredProducts = widget.products.where((product) {
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
      body: CustomScrollView(
        slivers: [
          ProductDetailsAppBar(store: widget.store),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CustomSearchTextField(
                hintText: S.of(context).searchProduct,
                controller: searchController,
                onChanged: _filterProducts,
                filterOnPressed: () {
                  ProductFilterActions.showPriceFilterSheet(
                    context: context,
                    products: widget.products,
                    fromController: priceFromController,
                    toController: priceToController,
                    formKey: formKey,
                    onApply: (filteredList) {
                      setState(() {
                        filteredProducts = filteredList;
                      });
                    },
                  );
                },
                orderOnPressed: () {
                  ProductFilterActions.showSortSheet(
                    context: context,
                    selectedSort: selectedSort,
                    currentProducts: filteredProducts,
                    onApply: (sort, sortedList) {
                      setState(() {
                        selectedSort = sort;
                        filteredProducts = sortedList;
                      });
                    },
                  );
                },
              ),
            ),
          ),
          ProductsSliverGrid(products: filteredProducts, isHome: false),
          SliverToBoxAdapter(
            child: SizedBox(
              height: AppDimensions.getBottomBarTotalHeight(context),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductDetailsAppBar extends StatelessWidget {
  final StoreModel store;

  const ProductDetailsAppBar({
    super.key,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    bool kIsArabic = LanguageHelper.isArabic();

    return SliverAppBar(
      actionsPadding: EdgeInsets.zero,
      expandedHeight: 130,
      pinned: true,
      floating: false,
      automaticallyImplyLeading: false,
      titleTextStyle: AppStyles.bold20(context),
      elevation: 4,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: store.id,
              child: StoreBar(store: store),
            ),
          ],
        ),
        title: LayoutBuilder(
          builder: (context, constraints) {
            final percent = ((constraints.maxHeight - kToolbarHeight) /
                (120 - kToolbarHeight))
                .clamp(0.0, 1.0);
            final opacity = (1 - percent).clamp(0.0, 1.0);

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 320 * opacity,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.2 * opacity)
                    : Colors.white.withOpacity(0.1 * opacity),
              ),
              child: Row(
                children: [
                  // Back button
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Theme.of(context).brightness == Brightness.light
                        ? Colors.white
                        : Theme.of(context).colorScheme.secondary,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new_outlined,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Store image and details
                  Expanded(
                    child: Opacity(
                      opacity: opacity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Store image
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl:store.imageUrl ?? '',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorWidget: (context, error, stackTrace) =>
                              const Icon(Icons.store),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Store name
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  kIsArabic ? store.arabic_name : store.english_name,
                                  style: AppStyles.semiBold18(context),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Favorite button
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: FavoriteButton(
                      store: store,
                      onTap: () async {
                        await context.read<StoreCubit>().likeOnTap(store.id);
                      },
                      isDark: Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        titlePadding: EdgeInsets.zero,
      ),
    );
  }
}

class StoreBar extends StatefulWidget {
  const StoreBar({
    super.key,
    required this.store,
  });

  final StoreModel store;

  @override
  State<StoreBar> createState() => _StoreBarState();
}

class _StoreBarState extends State<StoreBar> {

  Map<String, double>? _nearest;

  @override
  void initState() {
    super.initState();

    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await LocalStorageHelper.getUser();
    if (mounted) {
      setState(() {
        _nearest = getNearestLocation(
          store: widget.store,
          userLat: user?.latitude ?? 0,
          userLog: user?.longitude ?? 0,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16, top: 0),
            child: Card(
              color: Theme.of(context).cardColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildStoreImage(),
                    const SizedBox(width: 16),
                    Expanded(child: _buildInfo(context)),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 25,
            child: FavoriteButton(
              store: widget.store,
              onTap: () async {
                await context.read<StoreCubit>().likeOnTap(widget.store.id);
              },
              isDark: Theme.of(context).brightness == Brightness.dark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreImage() {
    return SizedBox(
      width: 90,
      height: 90,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl:widget.store.imageUrl,
          fit: BoxFit.cover,
          errorWidget: (_, __, ___) => Container(
            color: Colors.grey.shade200,
            child: Icon(Icons.store, size: 36, color: Colors.grey.shade400),
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(BuildContext context) {
    if ( _nearest == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Store Name
        Text(
          LanguageHelper.isArabic()
              ? widget.store.arabic_name
              : widget.store.english_name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        // Social Media and Contact Links
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (widget.store.webSite?.isNotEmpty ?? false)
              _buildSocialIcon(
                icon: Icons.language,
                url: widget.store.webSite!,
                tooltip: S.of(context).website,
                context: context,
              ),
            if (widget.store.facebook?.isNotEmpty ?? false)
              _buildSocialIcon(
                icon: Icons.facebook,
                url: widget.store.facebook!,
                tooltip: S.of(context).facebook,
                context: context,
              ),
            if (widget.store.insta?.isNotEmpty ?? false)
              _buildSocialIcon(
                icon: FontAwesomeIcons.instagram,
                url: widget.store.insta!,
                tooltip: S.of(context).instagram,
                context: context,
              ),
            if (widget.store.ticTok?.isNotEmpty ?? false)
              _buildSocialIcon(
                icon: FontAwesomeIcons.tiktok,
                url: widget.store.ticTok!,
                tooltip: S.of(context).tiktok,
                context: context,
              ),
            if (widget.store.whatsapp?.isNotEmpty ?? false)
              _buildSocialIcon(
                icon: FontAwesomeIcons.whatsapp,
                url: widget.store.whatsapp!,
                tooltip: S.of(context).whatsapp,
                context: context,
              ),
            if (widget.store.hotline?.isNotEmpty ?? false)
              _buildSocialIcon(
                icon: Icons.phone,
                url: 'tel:${widget.store.hotline}',
                tooltip: S.of(context).hotline,
                context: context,
              ),
            if (_nearest != null)
              _buildSocialIcon(
                icon: CupertinoIcons.location_solid,
                url:
                'https://www.google.com/maps/search/?api=1&query=${_nearest!['lat']},${_nearest!['log']}',
                tooltip: S.of(context).location,
                context: context,
              ),

            if (widget.store.address != null)
              Tooltip(
                message:widget.store.address,
                child: InkWell(
                  onTap: () {
                    showDialog(context: context, builder: (context) => AlertDialog(title: Text(widget.store.address!),backgroundColor: Theme.of(context).cardColor,),);
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ),
                    child: Icon(
                      FontAwesomeIcons.location,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              )
,

            if (widget.store.img_url_menu_for_resturant?.isNotEmpty ?? false)
              Tooltip(
                message: S.of(context).resturantMenu,
                child: InkWell(
                  onTap: ()  {
                    final imageProvider = Image.network(widget.store.img_url_menu_for_resturant!).image;
                    showImageViewer(context, imageProvider, onViewerDismissed: () {
                      print("dismissed");
                    });
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    ),
                    child: Icon(
                      Icons.menu_book,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              )
          ],
        ),
      ],
    );
  }

  Widget _buildSocialIcon({
    required IconData icon,
    required String url,
    required String tooltip,
    required BuildContext context,
  }) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {
            ShowMessage.showToast(S.of(context).cannotLaunchUrl);
          }
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          ),
          child: Icon(
            icon,
            size: 20,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }


}
