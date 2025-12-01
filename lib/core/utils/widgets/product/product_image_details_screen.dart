import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../Features/home/data/repos/home_repo_impl.dart';
import '../../../../Features/home/presentation/manger/offer_cubit/offer_cubit.dart';
import '../../../../Features/home/presentation/manger/product_cubit/product_cubit.dart';
import '../../../models/product_model.dart';

class ProductImageDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductImageDetailsScreen({super.key, required this.product});

  @override
  State<ProductImageDetailsScreen> createState() => _ProductImageDetailsScreenState();
}

class _ProductImageDetailsScreenState extends State<ProductImageDetailsScreen> {
  bool isLoading = false;
  int _currentImageIndex = 0; // To track the current image in the carousel

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Carousel for multiple images
        widget.product.productImages.isNotEmpty
            ? CarouselSlider(
          options: CarouselOptions(
            height: MediaQuery.of(context).size.height * 0.5,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            enableInfiniteScroll: widget.product.productImages.length > 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
          items: widget.product.productImages.map((productImage) {
            return ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: CachedNetworkImage(
                imageUrl: productImage.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                placeholder: (context, url) => const Skeletonizer(
                  enabled: true,
                  child: ColoredBox(color: Colors.grey), // Skeleton placeholder
                ),
                errorWidget: (context, url, error) => const Icon(
                  Icons.error,
                  color: Colors.red,
                  size: 50,
                ),
              ),
            );
          }).toList(),
        )
            : const Center(
          child: Text('No images available'),
        ),

        // Image indicator dots
        if (widget.product.productImages.length > 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.product.productImages.asMap().entries.map((entry) {
                return Container(
                  width: _currentImageIndex == entry.key ? 12.0 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
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

        // Back and Wishlist buttons
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_outlined,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
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
                      ? const Icon(
                    Icons.favorite_border,
                    size: 32,
                    color: Colors.black54,
                  )
                      : const Icon(
                    Icons.favorite,
                    size: 32,
                    color: Colors.redAccent,
                  ),
                  onPressed: () async {
                    if (!isLoading) {
                      setState(() => isLoading = true);
                      try {
                        await HomeRepoImpl().addOnlineProductLike(widget.product.id);
                        await context.read<OfferCubit>().toggleWishlistLocally(
                          widget.product.id,
                        );
                        await context.read<ProductCubit>().toggleWishlistLocally(
                          widget.product.id,
                        );
                      } finally {
                        setState(() => isLoading = false);
                      }
                    }
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}