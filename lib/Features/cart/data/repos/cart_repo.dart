import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/Features/cart/data/models/cart_model/cart_model.dart';
import 'package:multi_vendor_e_commerce_app/core/errors/failures.dart';

abstract class CartRepo{
  Future <Either<Failure, bool>> checkProductsAvilable(BuildContext context, CartModel cart) ;
  Future <Either<Failure, String>> addProductToCart( {required CartModel cart,required String store_id,required String name,required String phone,required String address,required bool isPaid,required String addressUrl,required double price,}) ;
  Future <Either<Failure, String>> addProductToLocalCart( {required CartModel cart,required String store_id,required String name,required String phone,required String address,required bool isPaid,required String addressUrl,required double price,}) ;

}


