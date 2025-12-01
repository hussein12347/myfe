import 'dart:math';
import 'package:multi_vendor_e_commerce_app/core/models/store_model.dart';
import 'package:multi_vendor_e_commerce_app/core/models/store_branch_model.dart';

import '../../../Features/cart/data/models/cart_item_model/cart_item_model.dart';
import '../../../Features/cart/data/models/cart_model/cart_model.dart';

/// دالة لحساب المسافة بين نقطتين بالإحداثيات
double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const earthRadius = 6371; // نصف قطر الأرض بالكيلومتر
  final dLat = _deg2rad(lat2 - lat1);
  final dLon = _deg2rad(lon2 - lon1);

  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
          sin(dLon / 2) * sin(dLon / 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadius * c; // النتيجة بالكيلومتر
}

double _deg2rad(double deg) => deg * (pi / 180);

/// دالة ترجع أقرب موقع (المتجر أو الفرع) بالنسبة لموقع المستخدم
Map<String, double> getNearestLocation({
  required StoreModel store,
  required double userLat,
  required double userLog,
}) {
  // نبدأ بالموقع الأساسي للمتجر
  double nearestDistance = calculateDistance(userLat, userLog, store.lat, store.log);
  double nearestLat = store.lat;
  double nearestLog = store.log;

  // نقارن بالفروع
  for (StoreBranchModel branch in store.storeBranches) {
    double branchDistance = calculateDistance(userLat, userLog, branch.lat, branch.log);
    if (branchDistance < nearestDistance) {
      nearestDistance = branchDistance;
      nearestLat = branch.lat;
      nearestLog = branch.log;
    }
  }

  return {
    "lat": nearestLat,
    "log": nearestLog,
    "distance_km": nearestDistance,
  };
}

/// تحسب التوصيل لكل متجر على حدة
Map<String, double> calculateDeliveryPerStore({
  required CartModel cart,
  required double userLat,
  required double userLog,
}) {
  final Map<String, List<CartItemModel>> storeItems = {};
  final Map<String, double> deliveryPerStore = {};

  // نقسم المنتجات حسب المتجر
  for (var item in cart.items) {
    final storeId = item.product.store.id;
    if (!storeItems.containsKey(storeId)) {
      storeItems[storeId] = [];
    }
    storeItems[storeId]!.add(item);
  }

  // نحسب التوصيل لكل متجر
  storeItems.forEach((storeId, items) {
    final store = items.first.product.store;

    // الوزن الكلي للمنتجات من المتجر
    double totalWeight = items.fold(
      0.0,
          (sum, item) => sum + (item.product.weight * item.quantity),
    );

    double deliveryCost = 0;

    if (store.deliveryPriceStatic != null) {
      // ✅ لو فيه توصيل ثابت
      deliveryCost = store.deliveryPriceStatic!;
    } else {
      // ✅ لو توصيل بالمسافة × الوزن
      final nearest = getNearestLocation(
        store: store,
        userLat: userLat,
        userLog: userLog,
      );

      double distanceKm = nearest["distance_km"] ?? 0.0;
      double costPerKmPerKg = store.deliveryPricePerKmPerKg ?? 0;

      deliveryCost = distanceKm * totalWeight * costPerKmPerKg;

      // الحد الأدنى 40
      if (deliveryCost < 40) deliveryCost = 40;
    }

    deliveryPerStore[storeId] = deliveryCost;

    print("🚚 Store ${store.arabic_name} → $deliveryCost EGP");
  });

  return deliveryPerStore;
}


double calculateDeliveryForOrder({
  required CartModel cart,
  required double userLat,
  required double userLog,
}) {
  double totalDelivery = 0;

  // 1️⃣ نقسم المنتجات حسب المتجر
  final Map<String, List<CartItemModel>> storeItems = {};
  for (var item in cart.items) {
    final storeId = item.product.store.id;
    if (!storeItems.containsKey(storeId)) {
      storeItems[storeId] = [];
    }
    storeItems[storeId]!.add(item);
  }

  // 2️⃣ نحسب التوصيل لكل متجر
  storeItems.forEach((storeId, items) {
    final store = items.first.product.store;

    // الوزن الكلي للمنتجات من المتجر
    double totalWeight = items.fold(
      0.0,
          (sum, item) => sum + (item.product.weight * item.quantity),
    );

    double deliveryCost = 0;

    if (store.deliveryPriceStatic != null) {
      // ✅ لو فيه توصيل ثابت
      deliveryCost = store.deliveryPriceStatic!;
    } else {
      // ✅ لو توصيل بالمسافة × الوزن
      final nearest = getNearestLocation(
        store: store,
        userLat: userLat,
        userLog: userLog,
      );

      double distanceKm = nearest["distance_km"] ?? 0.0;
      double costPerKmPerKg = store.deliveryPricePerKmPerKg ?? 0;

      deliveryCost = distanceKm * totalWeight * costPerKmPerKg;

      // اختياري: أقل تكلفة للشحن
      double minShippingCost = 40;
      if (deliveryCost < minShippingCost) {
        deliveryCost = minShippingCost;
      }
    }

    totalDelivery += deliveryCost;

    print("🚚 Store ${store.arabic_name} → $deliveryCost EGP");
  });

  return totalDelivery;
}

