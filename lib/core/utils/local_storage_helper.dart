import 'dart:convert';
import 'package:multi_vendor_e_commerce_app/core/utils/api_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class LocalStorageHelper {
  static const String _userKey = "user";
  static const String _cartKey = 'cart_product_ids';
  static const String _notificationKey = 'read_notification_ids';

  // Save user
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  // Retrieve user
  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;
    final Map<String, dynamic> userMap = jsonDecode(userJson);
    return UserModel.fromJson(userMap);
  }

  // Clear user
  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

// Update user
  static Future<void> updateUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    // خزن الموديل الجديد مكان القديم
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

// تحديث بيانات المستخدم من الإنترنت وتخزينها محليًا
  static Future<UserModel?> updateUserFromInternet(String userId) async {
    try {
      final userResponse = await ApiServices().getData(
        path:
        'users?select=*,companies!inner(*)&id=eq.$userId&companies.isShow=eq.true',
      );

      if (userResponse.data == null || userResponse.data.isEmpty) {
        return null; // أو ممكن ترمي Exception / ترجع Failure حسب البنية بتاعتك
      }

      // حوّل JSON → UserModel
      final userModel = UserModel.fromJson(userResponse.data[0]);

      // خزّنه محليًا
      await LocalStorageHelper.saveUser(userModel);

      return userModel;
    } catch (e) {
      print("❌ Error updating user from internet: $e");
      return null;
    }
  }













  // Save cart product IDs
  static Future<void> saveCart(List<String> productIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_cartKey, productIds);
  }

  // Retrieve cart product IDs
  static Future<List<String>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_cartKey) ?? [];
  }

  // Add product to cart
  static Future<void> addToCart(String productId) async {
    final ids = await getCart();
    ids.add(productId);
    await saveCart(ids);
  }

  // Remove one instance of product from cart
  static Future<void> removeFromCart(String productId) async {
    final ids = await getCart();
    final index = ids.indexOf(productId);
    if (index != -1) {
      ids.removeAt(index);
      await saveCart(ids);
    }
  }

  // Clear cart
  static Future<void> clearCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
  }
  // Clear cart for specific store (by productIds list)
  static Future<void> clearCartForStore(List<String> storeProductIds) async {
    final prefs = await SharedPreferences.getInstance();
    final cart = prefs.getStringList(_cartKey) ?? [];

    // شيل أي منتج من منتجات المتجر
    cart.removeWhere((productId) => storeProductIds.contains(productId));

    await prefs.setStringList(_cartKey, cart);
  }

  // Save read notification IDs
  static Future<void> saveNotifications(List<String> notificationIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_notificationKey, notificationIds);
  }

  // Retrieve read notification IDs
  static Future<List<String>> getReadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_notificationKey) ?? [];
  }

  // Mark a notification as read
  static Future<void> markNotificationAsRead(String notificationId) async {
    final ids = await getReadNotifications();
    if (!ids.contains(notificationId)) {
      ids.add(notificationId);
      await saveNotifications(
        ids,
      ); // Fixed: Use saveNotifications instead of saveCart
    }
  }

  // Clear read notifications
  static Future<void> clearNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationKey);
  }
}
