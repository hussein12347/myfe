import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/data/models/offer_model/offer_model.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/data/repos/home_repo.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/models/wish_list_model.dart';

part 'offer_state.dart';

class OfferCubit extends Cubit<OfferState> {
  final HomeRepo homeRepo;

  OfferCubit(this.homeRepo) : super(OfferInitial());

  List<OfferModel> offers = [];

  Future<void> getOffers() async {
    emit(GetOffersLoading());
    offers = [];
    final result = await homeRepo.getOffers(
      id: Supabase.instance.client.auth.currentUser?.id,
    );

    result.fold((l) => emit(GetOffersError(l.errMessage)), (r) {
      offers = r;
      emit(GetOffersSuccess(offers));
    });
  }

  Future<void> toggleWishlistLocally(String productId) async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) return;

      for (var offer in offers) {
        for (var offerProduct in offer.offerProducts) {
          final product = offerProduct.product;
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
      }

      emit(GetOffersSuccess(offers));
    } catch (e) {
      log(e.toString());
      emit(GetOffersError(e.toString()));
    }
  }
}
