import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/data/repos/home_repo.dart';
import 'package:multi_vendor_e_commerce_app/core/models/product_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/models/wish_list_model.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final HomeRepo repo;
  ProductCubit(this.repo) : super(ProductInitial());

  List<ProductModel>products=[];
  Future<void>getProducts()async{
    emit(GetProductsLoading());
    products=[];
    final result = await repo.getProducts(id: Supabase.instance.client.auth.currentUser?.id);

    result.fold((l) => emit(GetProductsError(l.errMessage)), (r) {
      products=r;
      emit(GetProductsSuccess(products));
    },);
  }
  Future<void> toggleWishlistLocally(String productId) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

        for (var product in products) {
          if (product.id == productId) {
            final existingIndex = product.wishlists.indexWhere(
                  (w) => w.userId == userId,
            );

            if (existingIndex != -1) {
              product.wishlists.removeAt(existingIndex);
            } else {
              product.wishlists.add(
                WishlistModel(
                  userId: userId,
                  id: const Uuid().v4(), // حط ID لو عندك
                  productId: product.id,
                  createdAt: DateTime.now(),
                ),
              );
            }
          }
        }

      emit(GetProductsSuccess(products));
    } catch (e) {
      log(e.toString());
      emit(GetProductsError(e.toString()));
    }
  }

}
