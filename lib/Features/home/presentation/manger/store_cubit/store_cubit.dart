import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/data/repos/home_repo.dart';
import 'package:multi_vendor_e_commerce_app/core/models/store_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/models/favorite_store_model.dart';

part 'store_state.dart';

class StoreCubit extends Cubit<StoreState> {
  final HomeRepo repo;

  StoreCubit(this.repo) : super(StoreInitial());
  List<StoreModel> stores = [];

  Future<void> getStores() async {
    emit(GetStoresLoading());
    stores = [];
    final result = await repo.getStores();

    result.fold((l) => emit(GetStoresError(l.errMessage)), (r) {

      stores=r;

      emit(
        GetStoresSuccess(
            stores
        ),
      );
    });
  }

  Future<void> likeOnTap(String storeId) async {
    // شوف المتجر المطلوب
    try {
      final index = stores.indexWhere((e) => e.id == storeId);
      if (index == -1) return; // لو مش لاقي المتجر، خلاص امشي من هنا
      if(Supabase.instance.client.auth.currentUser?.id==null) return;
      final store = stores[index];
      final isFavorite = store.favoriteStores.any((fav) => (fav.storeId == storeId && fav.userId==Supabase.instance.client.auth.currentUser!.id));

      // ابعت الريكوست حسب الحالة
      if (isFavorite) {
        await repo.addOnlineStoreLike(storeId);
        store.favoriteStores.removeWhere((fav) => fav.storeId == storeId);
      } else {
        await repo.addOnlineStoreLike(storeId);
        store.favoriteStores.add(FavoriteStoreModel(storeId: storeId, id: const Uuid().v4(), userId: Supabase.instance.client.auth.currentUser!.id, createdAt: DateTime.now())); // استخدم موديلك هنا
      }

      // حدّث الليست وابعث الحالة
      stores[index] = store;
      emit(GetStoresSuccess(List.from(stores)));
    } on Exception catch (e) {
      // TODO
      log(e.toString());
    }
// لازم نعمل نسخة جديدة علشان الـ UI يسمع
  }
  // Future<void> rateOnTap(String storeId, double rate) async {
  //   try {
  //     final index = stores.indexWhere((e) => e.id == storeId);
  //     if (index == -1) return;
  //
  //     final store = stores[index];
  //
  //     // أول حاجة نعمل الريكويست
  //     await repo.addOnlineStoreRate(storeId, rate);
  //
  //     // بنحدث القيم
  //     final oldUserRating = store.userRating;
  //     final oldRatingCount = store.ratingCount;
  //     final oldRatingSum = store.rating * oldRatingCount;
  //
  //     double newRatingSum;
  //     int newRatingCount;
  //
  //     if (oldUserRating != null) {
  //       // المستخدم كان مدي تقييم قبل كده
  //       newRatingSum = oldRatingSum - oldUserRating + rate;
  //       newRatingCount = oldRatingCount;
  //     } else {
  //       // أول مرة المستخدم يقيم
  //       newRatingSum = oldRatingSum + rate;
  //       newRatingCount = oldRatingCount + 1;
  //     }
  //
  //     // نحسب المتوسط ونقربه لنص
  //     final newAverageRating = (newRatingSum / newRatingCount * 2).round() / 2;
  //
  //     // نحدث المتجر
  //     stores[index] = store.copyWith(
  //       rating: newAverageRating,
  //       ratingCount: newRatingCount,
  //       userRating: rate,
  //     );
  //
  //     emit(GetStoresSuccess(List.from(stores)));
  //   } catch (e) {
  //     log('Error rating store: $e');
  //   }
  // }

}
