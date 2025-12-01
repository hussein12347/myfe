import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_button.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/product_details_screen.dart';
import '../../../Features/cart/presentation/manger/cart_cubit/cart_cubit.dart';
import '../../../generated/l10n.dart';
import '../../models/product_model.dart';
import '../functions/is_arabic.dart';


class ProductItem extends StatelessWidget {
  final ProductModel product;
  final Future<void> Function() favoriteOnPressed;

  const ProductItem({
    super.key,
    required this.product,
    required this.favoriteOnPressed,
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
               Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: product,),));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // ===== صورة المنتج مع Stack =====
                Expanded(
                  child: ProductImage(
                    product: product,
                    isDark: isDark,
                    theme: theme,
                    maxHeight: constraints.maxHeight * 0.55,
                    favoriteOnPressed:
                        favoriteOnPressed, // تخصيص الارتفاع بناءً على القيود
                  ),
                ),

                // ===== السعر =====
                const   SizedBox(height: 10,),
                ProductPrice(product: product, theme: theme),

                // ===== اسم المنتج =====
                     const  SizedBox(height: 5,),
                ProductName(product: product),

                // ===== التقييم والعلامة التجارية =====
                     const  SizedBox(height: 5,),
                ProductRate(isDark: isDark, theme: theme, rate: product.averageRate.toString(), storeName: (LanguageHelper.isArabic())?product.store.arabic_name:product.store.english_name,),

                // ===== زر الإضافة =====
                     const  SizedBox(height: 5,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                    backgroundColor: (product.quantity > 0)?null:Colors.redAccent,
                    height: 36,
                    onPressed: () {
                      if (product.quantity > 0) {
  context.read<CartCubit>().addItem(product,context);
}
                    },
                    text: (product.quantity > 0)? S.of(context).add:S.of(context).notAvailable,
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

class ProductPrice extends StatelessWidget {
  const ProductPrice({super.key, required this.product, required this.theme});

  final ProductModel product;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.oldPrice! > product.price;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              product.quantity > 0
                  ? '${product.price.toStringAsFixed(0)} ${S.of(context).currency}'
                  : S.of(context).notAvailable,
              style: product.quantity > 0
                  ? AppStyles.semiBold18(
                      context,
                    ).copyWith(color: theme.colorScheme.secondary)
                  : AppStyles.semiBold18(context).copyWith(color: Colors.red),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (hasDiscount&&product.quantity>0) const SizedBox(width: 8),
          if (hasDiscount&&product.quantity>0)
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
  const ProductRate({super.key, required this.isDark, required this.theme, required this.rate, required this.storeName});

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
             storeName ,
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
  bool isLoading = false; // متغير الحالة
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Stack(
        children: [
          Container(
            constraints:   const BoxConstraints(
              minHeight: 100,
        
            ),
            width: double.infinity,
            height: double.infinity,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.network(
                widget.product.imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, progress) {
                  return progress == null
                      ? child
                      : Container(
                          height: widget.maxHeight,
                          color: widget.isDark
                              ? Colors.grey[800]
                              : Colors.grey[100],
                          child:  Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Center(
                              child: LoadingAnimationWidget.inkDrop(
                                color:Theme.of(context).colorScheme.secondary,
                                size: 25,
                              )
                            ),
                          ),
                        );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  height: widget.maxHeight,
                  color: widget.isDark ? Colors.grey[800] : Colors.grey[200],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // ===== بانر الخصم =====
          if (widget.product.price < widget.product.oldPrice!&&widget.product.quantity>0)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
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
          // ===== أيقونة القلب =====
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
                          : const   Icon(
                              Icons.favorite,
                              size: 18,
                              color: Colors.redAccent,
                            ),
                      onPressed: () async {
                        if (isLoading==false) {
                          setState(() => isLoading = true); // إظهار اللودينج
                          {
                            await widget.favoriteOnPressed(); // تنفيذ الفانكشن
                          }
                          setState(() => isLoading = false); 
                        }
// إخفاء اللودينج
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
}
