import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_vendor_e_commerce_app/Features/cart/data/models/cart_model/cart_model.dart';
import 'package:multi_vendor_e_commerce_app/Features/cart/presentation/manger/cart_cubit/cart_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/cart/presentation/views/store_cart_view.dart';
import 'package:multi_vendor_e_commerce_app/core/models/store_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';

import '../../../../generated/assets.dart';

class StoresInCartView extends StatelessWidget {
  const StoresInCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).cart),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final cart = context.read<CartCubit>().cart;
    if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(Assets.jsonSadEmptyBox,
                      width: 250, height: 250),
                  const SizedBox(height: 20),
                  Text(
                    S.of(context).cartEmpty,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    S.of(context).addItemsToCart,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          // Get unique stores from cart items
          final storeMap = <String, StoreModel>{};
          for (var item in cart.items) {
            storeMap[item.product.store.id] = item.product.store;
          }
          final stores = storeMap.values.toList();

          return ListView.builder(
            itemCount: stores.length,
            itemBuilder: (context, index) {
              final store = stores[index];
              return _buildStoreItem(context, store, cart);
            },
          );
        },
      ),
    );
  }

  Widget _buildStoreItem(BuildContext context, StoreModel store, CartModel cart) {
    return Card(
      color: Theme.of(context).cardColor,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              store.imageUrl ?? '',
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.store),
            ),
          ),
        ),
        title: Text(
          LanguageHelper.isArabic() ? store.arabic_name : store.english_name,
          style: AppStyles.semiBold16(context),
        ),
        trailing:  Icon(Icons.arrow_forward_ios, size: 16,color: Theme.of(context).colorScheme.secondary,),
        onTap: () {
          final filteredCart = CartModel(
            items: cart.items
                .where((item) => item.product.store.id == store.id)
                .toList(),
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StoreCartView(
                store: store,
                cart: filteredCart,
              ),
            ),
          );
        },
      ),
    );
  }
}