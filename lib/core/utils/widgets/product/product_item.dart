import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_button.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/product/product_details_screen.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/product/product_reviews_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../generated/l10n.dart';
import '../../../models/product_model.dart';
import '../../functions/is_arabic.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../../functions/show_message.dart';

class ProductItem extends StatelessWidget {
  final ProductModel product;
  final Future<void> Function() favoriteOnPressed;
  final Future<void> Function() addToCartOnPressed;
final bool isLocalPaid;
  const ProductItem({
    super.key,
    required this.product,
    required this.favoriteOnPressed, required this.addToCartOnPressed, required this.isLocalPaid,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          color: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.08),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(
                    product: product,
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductReviewsScreen(product: product),));

                    },
                  ),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Product image with carousel
                Expanded(
                  child: ProductImage(
                    product: product,
                    isDark: isDark,
                    theme: theme,
                    maxHeight: constraints.maxHeight * 0.55,
                    favoriteOnPressed: favoriteOnPressed,
                  ),
                ),
                // Price
                const SizedBox(height: 10),
                ProductPrice(product: product, theme: theme),
                // Product name
                const SizedBox(height: 5),
                ProductName(product: product),
                // Rating and store name
                const SizedBox(height: 5),
                ProductRate(
                  isDark: isDark,
                  theme: theme,
                  rate: product.averageRate.toString(),
                  storeName: LanguageHelper.isArabic()
                      ? product.store.arabic_name
                      : product.store.english_name,
                ),
                // Flash deal timer or "Offer Ended" message
                if (product.isFlash && product.flashEndTime != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: FlashTimer(
                      flashEndTime: product.flashEndTime!,
                      theme: theme,
                    ),
                  ),
                // Add to cart button
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    backgroundColor:
                        (product.quantity > 0 &&
                            (!product.isFlash ||
                                (product.flashEndTime != null &&
                                    product.flashEndTime!.isAfter(
                                      DateTime.now(),
                                    ))))
                        ? null
                        : Colors.redAccent,
                    height: 36,
                    onPressed:


                        () {



                      if (product.quantity > 0 &&
                          (!product.isFlash ||
                              (product.flashEndTime != null &&
                                  product.flashEndTime!.isAfter(
                                    DateTime.now(),
                                  )))) {
                        addToCartOnPressed();
                      }
                    },
                    text:
                        (product.quantity > 0 &&
                            (!product.isFlash ||
                                (product.flashEndTime != null &&
                                    product.flashEndTime!.isAfter(
                                      DateTime.now(),
                                    ))))
                        ? (isLocalPaid?S.of(context).addToLocalCart:S.of(context).add)
                        : S.of(context).notAvailable,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class FlashTimer extends StatefulWidget {
  final DateTime flashEndTime;
  final ThemeData theme;

  const FlashTimer({
    super.key,
    required this.flashEndTime,
    required this.theme,
  });

  @override
  State<FlashTimer> createState() => _FlashTimerState();
}

class _FlashTimerState extends State<FlashTimer> {
  late Duration remainingTime;
  late bool isExpired;

  @override
  void initState() {
    super.initState();
    updateRemainingTime();
    // Update timer every second
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          updateRemainingTime();
        });
        return true;
      }
      return false;
    });
  }

  void updateRemainingTime() {
    final now = DateTime.now();
    remainingTime = widget.flashEndTime.difference(now);
    isExpired = remainingTime.isNegative || remainingTime.inSeconds == 0;
  }

  @override
  Widget build(BuildContext context) {
    if (isExpired) {
      return Text(
        S.of(context).offerEnded,
        style: AppStyles.semiBold14(context).copyWith(color: Colors.red),
        textAlign: TextAlign.center,
      );
    }

    final hours = remainingTime.inHours;
    final minutes = remainingTime.inMinutes.remainder(60);
    final seconds = remainingTime.inSeconds.remainder(60);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: widget.theme.colorScheme.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        '${S.of(context).timeLeft}: ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
        style: AppStyles.semiBold14(
          context,
        ).copyWith(color: widget.theme.colorScheme.primary),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class ProductPrice extends StatelessWidget {
  const ProductPrice({super.key, required this.product, required this.theme});

  final ProductModel product;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final hasDiscount =
        product.oldPrice != null && product.oldPrice! > product.price;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              product.quantity > 0 &&
                      (!product.isFlash ||
                          (product.flashEndTime != null &&
                              product.flashEndTime!.isAfter(DateTime.now())))
                  ? '${product.price.toStringAsFixed(0)} ${S.of(context).currency}'
                  : S.of(context).notAvailable,
              style:
                  product.quantity > 0 &&
                      (!product.isFlash ||
                          (product.flashEndTime != null &&
                              product.flashEndTime!.isAfter(DateTime.now())))
                  ? AppStyles.semiBold18(
                      context,
                    ).copyWith(color: theme.colorScheme.secondary)
                  : AppStyles.semiBold18(context).copyWith(color: Colors.red),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hasDiscount &&
              product.quantity > 0 &&
              (!product.isFlash ||
                  (product.flashEndTime != null &&
                      product.flashEndTime!.isAfter(DateTime.now()))))
            const SizedBox(width: 8),
          if (hasDiscount &&
              product.quantity > 0 &&
              (!product.isFlash ||
                  (product.flashEndTime != null &&
                      product.flashEndTime!.isAfter(DateTime.now()))))
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${product.oldPrice!.toStringAsFixed(0)} ${S.of(context).currency}',
                style: AppStyles.regular16(context).copyWith(
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}

class ProductName extends StatelessWidget {
  const ProductName({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          LanguageHelper.isArabic() ? product.arabicName : product.englishName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppStyles.semiBold16(context),
        ),
      ),
    );
  }
}

class ProductRate extends StatelessWidget {
  const ProductRate({
    super.key,
    required this.isDark,
    required this.theme,
    required this.rate,
    required this.storeName,
  });

  final bool isDark;
  final String rate;
  final String storeName;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : const Color(0xFFF5F5F7),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, size: 14, color: Color(0xFFFFC107)),
                const SizedBox(width: 4),
                Text(
                  rate,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.grey[300] : Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              storeName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductImage extends StatefulWidget {
  const ProductImage({
    super.key,
    required this.product,
    required this.isDark,
    required this.theme,
    required this.maxHeight,
    required this.favoriteOnPressed,
  });

  final ProductModel product;
  final bool isDark;
  final ThemeData theme;
  final double maxHeight;
  final Future<void> Function() favoriteOnPressed;

  @override
  State<ProductImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<ProductImage> {
  bool isLoading = false;
  int _currentImageIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Collect valid image URLs, falling back to product.imageUrl if productImages is empty or invalid
    final imageUrls = widget.product.productImages
        .where((img) => img.imageUrl.isNotEmpty)
        .map((img) => img.imageUrl)
        .toList();


    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Stack(
        children: [
          // Carousel for product images
          imageUrls.isNotEmpty
              ? CarouselSlider(
                  options: CarouselOptions(
                    height: widget.maxHeight,
                    viewportFraction: 1.0,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: imageUrls.length > 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _currentImageIndex = index;
                      });
                    },
                  ),
                  items: imageUrls.map((imageUrl) {
                    return CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: widget.maxHeight,
                      placeholder: (context, url) => Container(
                        height: widget.maxHeight,
                        color: widget.isDark
                            ? Colors.grey[800]
                            : Colors.grey[100],
                        child: Center(
                          child: LoadingAnimationWidget.inkDrop(
                            color: widget.theme.colorScheme.secondary,
                            size: 25,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: widget.maxHeight,
                        color: widget.isDark
                            ? Colors.grey[800]
                            : Colors.grey[200],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              : Container(
                  height: widget.maxHeight,
                  color: widget.isDark ? Colors.grey[800] : Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
          // Image indicator dots
          if (imageUrls.length > 1)
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imageUrls.asMap().entries.map((entry) {
                  return Container(
                    width: _currentImageIndex == entry.key ? 10.0 : 6.0,
                    height: 6.0,
                    margin: const EdgeInsets.symmetric(horizontal: 3.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentImageIndex == entry.key
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                    ),
                  );
                }).toList(),
              ),
            ),
          // Discount banner
          if (widget.product.price <
                  (widget.product.oldPrice ?? double.infinity) &&
              widget.product.quantity > 0 &&
              (!widget.product.isFlash ||
                  (widget.product.flashEndTime != null &&
                      widget.product.flashEndTime!.isAfter(DateTime.now()))))
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      darken(widget.theme.colorScheme.primary, 0.18),
                      widget.theme.colorScheme.secondary,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '${(((widget.product.oldPrice! - widget.product.price) / widget.product.oldPrice!) * 100).toStringAsFixed(0)}% ${S.of(context).discount}',
                  style: AppStyles.semiBold14(
                    context,
                  ).copyWith(color: Colors.white),
                ),
              ),
            ),
          // Favorite icon
          Positioned(
            top: 5,
            right: 5,
            child: Container(
              height: 36,
              width: 36,
              decoration: BoxDecoration(
                color: widget.theme.scaffoldBackgroundColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: isLoading
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: LoadingAnimationWidget.bouncingBall(
                        color: Colors.redAccent,
                        size: 18,
                      ),
                    )
                  : IconButton(
                      icon: widget.product.wishlists.isEmpty
                          ? Icon(
                              Icons.favorite_border,
                              size: 18,
                              color: widget.isDark
                                  ? Colors.white70
                                  : Colors.black54,
                            )
                          : const Icon(
                              Icons.favorite,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                      onPressed: () async {
                        if (!isLoading) {
                          setState(() => isLoading = true);
                          try {
                            await widget.favoriteOnPressed();
                          } finally {
                            setState(() => isLoading = false);
                          }
                        }
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Color darken(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }
}
