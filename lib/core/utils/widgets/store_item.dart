
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/product_cubit/product_cubit.dart';
import 'package:multi_vendor_e_commerce_app/core/models/store_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/store_products_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../styles/app_styles.dart';

class StoreItem extends StatelessWidget {
  final StoreModel store;
  final Future<void> Function() favoriteOnPressed;

  final bool isDark;

  const StoreItem({
    super.key,
    required this.store,
    required this.favoriteOnPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => StoreProductsScreen(products: context.read<ProductCubit>().products.where((element) => element.storeId==store.id,).toList(), store: store),));
        },
        child: Stack(
          children: [
            // ✅ الكارت الأساسي بتاع المتجر (اختصرته هنا)
            Container(
              width: 140,
              margin: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).cardColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // صورة المتجر
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: CachedNetworkImage(
                      imageUrl:store.imageUrl,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        height: 100,
                        color: Colors.grey[200],
                        child: const Center(child: Icon(Icons.store, size: 40)),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          LanguageHelper.isArabic()
                              ? store.arabic_name
                              : store.english_name,
                          style: AppStyles.semiBold16(context),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),

                        //remove it if you want show rate
                        const SizedBox(
                          height: 8,
                        )
                        // SizedBox(height: 4),
                        // Row(
                        //   children: [
                        //     Icon(Icons.star, color: Colors.amber, size: 16),
                        //     SizedBox(width: 4),
                        //     Text(
                        //       "${store.rating} (${store.ratingCount})",
                        //       style: TextStyle(
                        //         fontSize: 12,
                        //         color: Colors.grey[600],
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // ✅ زرار المفضلة
            Positioned(
              top: 5,
              right: 5,
              child: FavoriteButton(
                store: store,
                onTap: favoriteOnPressed,
                isDark: isDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  final StoreModel store;
  final Future<void> Function() onTap;

  final bool isDark;

  const FavoriteButton({super.key, 
    required this.store,
    required this.onTap,
    required this.isDark,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isFavorited =(Supabase.instance.client.auth.currentUser?.id==null)?false: widget.store.favoriteStores.any((fav) => (fav.storeId == widget.store.id && fav.userId==Supabase.instance.client.auth.currentUser!.id));

    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
              icon: Icon(
                isFavorited ? Icons.favorite : Icons.favorite_border,
                size: 18,
                color: isFavorited
                    ? Colors.redAccent
                    : (widget.isDark ? Colors.white70 : Colors.black54),
              ),
              onPressed: isLoading
                  ? null
                  : () async {
                      setState(() => isLoading = true);
                      await widget.onTap(); // نفذ الفانكشن اللي جاية من الأب
                      setState(() => isLoading = false);
                    },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
    );
  }
}
