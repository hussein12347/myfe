import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/product_cubit/product_cubit.dart';
import 'package:multi_vendor_e_commerce_app/core/models/product_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/product/product_item.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../Features/cart/presentation/manger/cart_cubit/cart_cubit.dart';
import '../../../../Features/home/data/repos/home_repo_impl.dart';
import '../../../../Features/home/presentation/manger/offer_cubit/offer_cubit.dart';
import '../../../../generated/l10n.dart';
import '../../functions/show_message.dart';
import '../../styles/app_styles.dart';

class ProductsSliverGrid extends StatelessWidget {
  final List<ProductModel> products;
  final bool isHome;
  final bool isLoading;
  final bool isLocalPaid;
  final Future<void> Function(ProductModel product)? addToCartLocalOnPressed;


  const ProductsSliverGrid({
    super.key,
    required this.products,
    this.isHome = false,  this.isLoading = false,  this.isLocalPaid = false,  this.addToCartLocalOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    final filteredProducts = products.where((p) => p.quantity > 0).toList();

    return SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: (filteredProducts.isEmpty)?SliverToBoxAdapter(child: Center(child: Text(S.of(context).no_products_found
,          style: AppStyles.semiBold16(context).copyWith(color: Colors.grey),

      ),),):SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) => Skeletonizer(
            enabled: isLoading,
            child: ProductItem(
              isLocalPaid:isLocalPaid,
              product: filteredProducts[index],
              favoriteOnPressed: () async {
                (Supabase.instance.client.auth.currentUser?.id == null)?
                {
                ShowMessage.showToast(S
                    .of(context)
                    .mustLoginFirst)
              } :
                await HomeRepoImpl().addOnlineProductLike(filteredProducts[index].id);
                await context.read<OfferCubit>().toggleWishlistLocally(
                  filteredProducts[index].id,
                );
                await context.read<ProductCubit>().toggleWishlistLocally(
                  filteredProducts[index].id,
                );
              }, addToCartOnPressed:
            (Supabase.instance.client.auth.currentUser?.id==null)?
            ()async{
              ShowMessage.showToast(S.of(context).mustLoginFirst);

            }
                :
            isLocalPaid
    ? () async {
    if (addToCartLocalOnPressed != null) {
    await addToCartLocalOnPressed!(filteredProducts[index]);
    }
    }
        : () async {
    context.read<CartCubit>().addItem(filteredProducts[index], context);
    },

    ),
    ),
          childCount: isHome
              ? (filteredProducts.length < 20 ? filteredProducts.length : 20)
              : filteredProducts.length,
        ),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220, // قيمة ثابتة معقولة لعرض العنصر
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: _calculateAspectRatio(context),
        ),
      ),
    );
  }

  double _calculateAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // نسبة العرض إلى الارتفاع محسوبة ديناميكيًا
    return width < 350
        ? 0.45
        : width < 600
        ? 0.5
        : 0.55;
  }
}

