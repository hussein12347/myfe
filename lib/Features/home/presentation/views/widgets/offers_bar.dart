import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/products_screen.dart';

import '../../../data/models/offer_model/offer_model.dart'; // لو بتستخدم context.read

class _CarouselConstants {
  static const double viewportFraction = 0.75;
  static const int autoPlayIntervalSeconds = 3;
  static const int autoPlayAnimationMillis = 800;
  static const double horizontalPadding = 0.0;
}

class OffersBar extends StatefulWidget {
  final List<OfferModel> offers;
  final CarouselOptions? carouselOptions;
  final GestureTapCallback? onTap;

  const OffersBar({
    super.key,
    required this.offers,
    this.carouselOptions,
    this.onTap,
  });

  @override
  State<OffersBar> createState() => _OffersBarState();
}

class _OffersBarState extends State<OffersBar> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    final double carouselHeight = isPortrait
        ? size.height * 0.19
        : size.height * 0.4;



    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          itemCount: widget.offers.length,
          options:
              (widget.carouselOptions ??
              _buildDefaultCarouselOptions(carouselHeight)),
          itemBuilder: (context, index, realIdx) {
            final offer = widget.offers[index];
            return _buildCarouselItem(offer.imageUrl, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductsScreen(
                    title:LanguageHelper.isArabic()? offer.arabicName:offer.englishName,
                    products: offer.offerProducts
                        .map((e) => e.product)
                        .toList(),
                  ),
                ),
              );
            });
          },
        ),
        const SizedBox(height: 8),
        _buildDotsIndicator(widget.offers.length),
      ],
    );
  }

  CarouselOptions _buildDefaultCarouselOptions(double height) {
    return CarouselOptions(
      height: height,
      autoPlay: true,
      autoPlayInterval: const Duration(
        seconds: _CarouselConstants.autoPlayIntervalSeconds,
      ),
      autoPlayAnimationDuration: const Duration(
        milliseconds: _CarouselConstants.autoPlayAnimationMillis,
      ),
      enlargeCenterPage: true,
      viewportFraction: _CarouselConstants.viewportFraction,
      scrollPhysics: const BouncingScrollPhysics(),
      enableInfiniteScroll: true,
      pauseAutoPlayOnTouch: true,
      onPageChanged: (index, reason) {
        setState(() {
          currentIndex = index;
        });
      },
    );
  }

  Widget _buildCarouselItem(String image, GestureTapCallback? onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: _CarouselConstants.horizontalPadding,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            color: Colors.grey.shade200,
            child: CachedNetworkImage(
              imageUrl:image,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDotsIndicator(int itemCount) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (index) {
          final isActive = index == currentIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 16 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: isActive
                  ? Theme.of(context).colorScheme.secondary
                  : Colors.grey[400],
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}
