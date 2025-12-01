import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/models/local_order_model.dart';
import '../../../../../core/models/order_model.dart';
import '../../../../../core/utils/functions/is_arabic.dart';
import '../../../../../core/utils/styles/app_styles.dart';
import '../../../../../generated/l10n.dart';
import '../../manger/local_order_cubit/local_order_cubit.dart';
import '../../manger/order_cubit/order_cubit.dart';
import 'add_review_screen.dart';

class LocalOrderItemTile extends StatelessWidget {
  final LocalOrderItem item;
  final int status;

  const LocalOrderItemTile({super.key, required this.item, required this.status});

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final locale = S.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .colorScheme
            .surfaceContainerHighest
            .withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: 60,
              height: 60,
              color: Theme
                  .of(context)
                  .colorScheme
                  .surface,
              child: product.productImages.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl:product.productImages[0].imageUrl,
                fit: BoxFit.cover,
                errorWidget: (context, error, stackTrace) =>
                    _buildPlaceholder(),
              )
                  : _buildPlaceholder(),
            ),
          ),
          const SizedBox(width: 16),

          // Product details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LanguageHelper.isArabic()
                      ? product.arabicName
                      : product.englishName,
                  style: AppStyles.semiBold14(context).copyWith(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${locale.quantity}: ${item.quantity}',
                  style: AppStyles.regular12(context).copyWith(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.price.toStringAsFixed(2)} ${locale.currency}',
                  style: AppStyles.semiBold14(context).copyWith(
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                  ),
                ),
              ],
            ),
          ),
          if  (status==1)
            const SizedBox(width: 2,),
          if  (status==1)

            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiBlocProvider(
                      providers: [
                        BlocProvider.value(
                          value: context.read<LocalOrderCubit>(), // خد الموجود
                        ),
                        BlocProvider.value(
                          value: context.read<OrderCubit>(), // خد الموجود
                        ),
                      ],
                      child: AddReviewScreen(
                        item: OrderItem(
                          id: item.id,
                          product: item.product,
                          orderId: item.orderId,
                          price: item.price,
                          quantity: item.quantity,
                          productId: item.productId,
                        ),
                      ),
                    ),
                  ),
                );


              },
              icon: const FaIcon(FontAwesomeIcons.filePen, color: Colors.orange),
              label:  Text(
                S.of(context).addReview,
                style: const TextStyle(color: Colors.orange),
              ),
            )

        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.shopping_bag_outlined,
        size: 24,
        color: Colors.grey.shade400,
      ),
    );
  }
}
