import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_vendor_e_commerce_app/Features/cart/data/repos/cart_repo.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/presentation/manger/product_cubit/product_cubit.dart';
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';

import '../../../../../core/utils/functions/is_arabic.dart';
import '../../../../../core/utils/functions/show_message.dart';
import '../../../../../core/utils/local_storage_helper.dart';
import '../../../data/models/cart_model/cart_model.dart';
import '../../../../../core/models/product_model.dart';
import '../../../data/models/cart_item_model/cart_item_model.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final CartRepo repo;
  CartCubit(this.repo) : super(CartInitial());

  CartModel cart = CartModel(items: []);

  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

  Future<void> addItem(ProductModel product, BuildContext context) async {
    cart.addItem(product);
    emit(CartUpdated(cart));
    await LocalStorageHelper.addToCart(product.id);
    ShowMessage.showToast(S.of(context).addedToCartSuccessfully, backgroundColor: Colors.green);
  }

  Future<void> increaseQuantity(String productId, BuildContext context) async {
    final item = cart.items.firstWhere((e) => e.product.id == productId);

    if (item.quantity < item.product.quantity) {
      item.quantity += 1;
      await   LocalStorageHelper.addToCart(productId);
      emit(CartUpdated(cart));
      ShowMessage.showToast(S.of(context).quantityIncreased, backgroundColor: Colors.green);
    } else {
      ShowMessage.showToast(S.of(context).maxQuantityReached);
    }
  }

  Future<void> decreaseQuantity(String productId, BuildContext context, CartModel filteredCart, GlobalKey<AnimatedListState> listKey) async {
    final item = cart.items.firstWhere((e) => e.product.id == productId);

    if (item.quantity > 1) {
      item.quantity -= 1;
      filteredCart.items
          .firstWhere((e) => e.product.id == productId)
          .quantity -= 1;
      await  LocalStorageHelper.removeFromCart(productId);
      emit(CartUpdated(cart));
      ShowMessage.showToast(S.of(context).quantityDecreased, backgroundColor: Colors.orange);
    } else {
      removeItem(productId, context, filteredCart, listKey);
    }
  }



  Future<String> addProductToCart({
    required BuildContext context,
    required CartModel cart,
    required String name,
    required String phone,
    required String address,
    required bool isPaid,
    required String addressUrl,
    required double price,
    required String store_id,
  }) async {
    emit(AddItemsToCartLoading());
    final result = await repo.addProductToCart(
        cart: cart,
        name: name,
        phone: phone,
        address: address,
        isPaid: isPaid,
        addressUrl: addressUrl,
        price: price,
        store_id: store_id);

    await context.read<ProductCubit>().getProducts();
    return result.fold(
          (failure) {
        log("addProductToCart error: ${failure.errMessage}");
        emit(AddItemsToCartError());
        return failure.errMessage;
      },
          (success) {
        emit(CartUpdated(cart));
        return success;
      },
    );
  }

  Future<String> addProductToLocalCart({
    required BuildContext context,
    required CartModel cart,
    required String name,
    required String phone,
    required String address,
    required bool isPaid,
    required String addressUrl,
    required double price,
    required String store_id,
  }) async {
    emit(AddItemsToCartLoading());
    final result = await repo.addProductToLocalCart(
        cart: cart,
        name: name,
        phone: phone,
        address: address,
        isPaid: isPaid,
        addressUrl: addressUrl,
        price: price,
        store_id: store_id);

    await context.read<ProductCubit>().getProducts();
    return result.fold(
          (failure) {
        log("addProductToCart error: ${failure.errMessage}");
        emit(AddItemsToCartError());
        return failure.errMessage;
      },
          (success) {
        emit(CartUpdated(cart));
        return success;
      },
    );
  }

  Future<bool> checkProductsAvilable(CartModel cart, BuildContext context) async {
    emit(CheckCartAvilableLoading());
    final result = await repo.checkProductsAvilable(context, cart);
    return result.fold(
          (failure) {
        emit(CheckCartAvilableError());
        ShowMessage.showToast(failure.errMessage);
        return false;
      },
          (isAvailable) {
        emit(CheckCartAvilableSuccess());
        return isAvailable;
      },
    );
  }

  Future<void> removeItem(String productId, BuildContext context, CartModel filteredCart, GlobalKey<AnimatedListState> listKey) async {
    final globalIndex = cart.items.indexWhere((item) => item.id == productId);
    final filteredIndex = filteredCart.items.indexWhere((item) => item.id == productId);
    if (globalIndex == -1 || filteredIndex == -1) return;

    final removedItem = cart.items[globalIndex];

    listKey.currentState?.removeItem(
      filteredIndex,
          (context, animation) => SizeTransition(
        sizeFactor: animation,
        child: _buildRemovedItem(removedItem, context),
      ),
      duration: const Duration(milliseconds: 300),
    );

    Future.delayed(const Duration(milliseconds: 300), () {
      cart.items.removeAt(globalIndex);
      filteredCart.items.removeAt(filteredIndex);
      emit(CartUpdated(cart));
    });

    await LocalStorageHelper.removeFromCart(productId);
    ShowMessage.showToast(S.of(context).itemRemoved, backgroundColor: Colors.red);
  }

  Widget _buildRemovedItem(CartItemModel item, BuildContext context) {
    final locale = LanguageHelper.isArabic()
        ? item.product.arabicName
        : item.product.englishName;

    return ListTile(
      title: Text(locale),
      subtitle: Text('${item.quantity} x ${item.product.price.toStringAsFixed(2)} ${S.of(context).currency}'),
      leading: CachedNetworkImage(
       imageUrl: item.product.productImages.isNotEmpty
            ? item.product.productImages[0].imageUrl
            : '',
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
      ),
    );
  }

  // void clearCart(BuildContext context) {
  //   cart.clear();
  //   emit(CartUpdated(cart));
  //   LocalStorageHelper.clearCart();
  //   ShowMessage.showToast(S.of(context).cartCleared, backgroundColor: Colors.red);
  // }

  Future<void> clearCartForStore(String storeId, BuildContext context, CartModel filteredCart, GlobalKey<AnimatedListState> listKey) async {
    final itemsToRemove = cart.items.where((item) => item.product.store.id == storeId).toList();
    for (var item in itemsToRemove) {
      final globalIndex = cart.items.indexOf(item);
      final filteredIndex = filteredCart.items.indexWhere((i) => i.id == item.id);
      if (filteredIndex != -1) {
        listKey.currentState?.removeItem(
          filteredIndex,
              (context, animation) => SizeTransition(
            sizeFactor: animation,
            child: _buildRemovedItem(item, context),
          ),
          duration: const Duration(milliseconds: 300),
        );
      }
      cart.items.removeAt(globalIndex);
      if (filteredIndex != -1) {
        filteredCart.items.removeAt(filteredIndex);
      }
      await  LocalStorageHelper.removeFromCart(item.product.id);
    }
    emit(CartUpdated(cart));
    ShowMessage.showToast(S.of(context).cartCleared, backgroundColor: Colors.red);
  }

  Future<void> clearCartForStoreIcCheckout(String storeId) async {
    // احذف كل المنتجات الخاصة بالمتجر ده
    final itemsToRemove = cart.items.where((item) => item.product.storeId == storeId).toList();

    for (var item in itemsToRemove) {
      cart.items.remove(item);
      await LocalStorageHelper.removeFromCart(item.product.id);
    }

    // بلغ الـ UI إن الكارت اتغير
    emit(CartUpdated(cart));
  }


  Future<void> loadCartFromStorage(BuildContext context) async {
    emit(CheckCartAvilableLoading());
    final ids = await LocalStorageHelper.getCart();

    final Map<String, int> idCount = {};
    for (var id in ids) {
      idCount[id] = (idCount[id] ?? 0) + 1;
    }

    final allProducts = context.read<ProductCubit>().products;

    cart = CartModel(
      items: idCount.entries.map((entry) {
        final product = allProducts.firstWhere((p) => p.id == entry.key);
        return CartItemModel(
          product: product,
          quantity: entry.value,
          id: product.id,
        );
      }).toList(),
    );

    emit(CartUpdated(cart));
  }
}