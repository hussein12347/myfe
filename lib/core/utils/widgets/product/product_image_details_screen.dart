import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../Features/home/data/repos/home_repo_impl.dart';
import '../../../Features/home/presentation/manger/offer_cubit/offer_cubit.dart';
import '../../../Features/home/presentation/manger/product_cubit/product_cubit.dart';
import '../../models/product_model.dart';

class ProductImageDetailsScreen extends StatefulWidget {
  final ProductModel product;
  const ProductImageDetailsScreen({super.key, required this.product});

  @override
  State<ProductImageDetailsScreen> createState() => _ProductImageDetailsScreenState();
}

class _ProductImageDetailsScreenState extends State<ProductImageDetailsScreen> {
  bool isLoading = false;
  // متغير الحالة
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [

          Container(
            width: double.infinity,

            decoration: ShapeDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,

                image: NetworkImage(widget.product.imageUrl ?? ''),
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0,horizontal: 16),
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
                  child:  IconButton(onPressed: () {
                    Navigator.pop(context);
                  } , icon:  const Icon(Icons.arrow_back_ios_new_outlined,color:Colors.black ,),),
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
                        ? Icon(
                      Icons.favorite_border,
                      size: 32,
                      color:  Colors.black54,
                    )
                        : const   Icon(
                      Icons.favorite,
                      size: 32,
                      color: Colors.redAccent,
                    ),
                    onPressed: () async {
                      if (isLoading==false) {
                        setState(() => isLoading = true); // إظهار اللودينج
                            {
                          await HomeRepoImpl().addOnlineProductLike(widget.product.id);
                          await context.read<OfferCubit>().toggleWishlistLocally(
                            widget.product.id,
                          );
                          await context.read<ProductCubit>().toggleWishlistLocally(
                            widget.product.id,
                          );// تنفيذ الفانكشن
                        }
                        setState(() => isLoading = false);
                      }
                      // إخفاء اللودينج
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ],),
          )


        ]
    );
  }
}