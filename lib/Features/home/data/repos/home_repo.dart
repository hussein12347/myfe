import 'package:dartz/dartz.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/data/models/flash_product_model/flash_product_model.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/data/models/offer_model/offer_model.dart';
import 'package:multi_vendor_e_commerce_app/Features/home/data/models/store_category_model/store_category_model.dart';
import 'package:multi_vendor_e_commerce_app/core/models/category_model.dart';
import 'package:multi_vendor_e_commerce_app/core/models/store_model.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/models/product_model.dart';

abstract class HomeRepo {
  Future<void> addOnlineProductLike(String productId) ;
  Future<void> addOnlineStoreLike(String storeId) ;
  // Future<void> addOnlineStoreRate(String storeId , double rate) ;
  Future<Either<Failure, List<OfferModel>>> getOffers({required String? id});
  Future<Either<Failure, List<ProductModel>>> getProducts({required String? id});
  Future<Either<Failure, List<FlashProductDealModel>>> getFlashDeals({required String? id});
  Future<Either<Failure, List<StoreModel>>> getStores();
  Future<Either<Failure, List<CategoryModel>>> getCategory();
  Future<Either<Failure, List<StoreCategory>>> getStoreCategory();

}
