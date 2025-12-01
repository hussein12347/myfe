// import 'package:flutter/material.dart' hide Badge;
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
// import 'package:multi_vendor_e_commerce_app/Features/cart/data/models/cart_model/cart_model.dart';
// import 'package:multi_vendor_e_commerce_app/Features/cart/presentation/manger/cart_cubit/cart_cubit.dart';
// import 'package:multi_vendor_e_commerce_app/Features/cart/presentation/views/paying_details.dart';
// import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
// import 'package:badges/badges.dart';
// import 'package:lottie/lottie.dart';
// import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
// import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_button.dart';
// import 'package:multi_vendor_e_commerce_app/core/utils/widgets/loading_widget.dart';
// import 'package:multi_vendor_e_commerce_app/generated/assets.dart';
// import '../../../../generated/l10n.dart';
// import '../../../home/presentation/views/widgets/bottom_nav_height.dart';
// import '../../data/models/cart_item_model/cart_item_model.dart';
//
// class CartView extends StatelessWidget {
//   const CartView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(S.of(context).cart),
//         actions: [
//           BlocBuilder<CartCubit, CartState>(
//             builder: (context, state) {
//               final itemCount = context.read<CartCubit>().cart.items.length;
//               if (itemCount == 0) return const SizedBox();
//
//               return IconButton(
//                 icon: Badge(
//                   badgeContent: Text('$itemCount'),
//                   child: const Icon(Icons.delete_sweep),
//                 ),
//                 onPressed: () => _showClearCartDialog(context),
//               );
//             },
//           ),
//         ],
//       ),
//       body: BlocBuilder<CartCubit, CartState>(
//         builder: (context, state) {
//           final cubit = context.read<CartCubit>();
//           final cart = cubit.cart;
//           final total = cart.items.fold(0.0, (sum, item) => sum + (item.quantity * item.product.price));
//
//           if (cart.items.isEmpty) {
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Lottie.asset(Assets.jsonSadEmptyBox,
//                       width: 250, height: 250),
//                   const SizedBox(height: 20),
//                   Text(
//                     S.of(context).cartEmpty,
//                     style: Theme.of(context).textTheme.titleLarge,
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     S.of(context).addItemsToCart,
//                     style: Theme.of(context).textTheme.bodyMedium,
//                   ),
//                 ],
//               ),
//             );
//           }
//
//           return ModalProgressHUD(
//             inAsyncCall: (state is CheckCartAvilableLoading ),
//                 dismissible: state is! CheckCartAvilableLoading ,
//             opacity: 0.4,
//             // يعطي ظل خفيف وشيك
//             progressIndicator: loadingWidget(context),
//
//             child: Column(
//               children: [
//                 Expanded(
//                   child: AnimatedList(
//                     key: cubit.listKey,
//                     initialItemCount: cart.items.length,
//                     itemBuilder: (context, index, animation) {
//                       final item = cart.items[index];
//                       return _buildCartItem(item, animation, context, index);
//                     },
//                   ),
//                 ),
//                 _buildBottomBar(context, total, cart.items.length,cart),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildCartItem(
//       CartItemModel item,
//       Animation<double> animation,
//       BuildContext context,
//       int index,
//       ) {
//     final product = item.product;
//     final locale =
//     LanguageHelper.isArabic() ? product.arabicName : product.englishName;
//     final price = item.quantity * product.price;
//
//     return SlideTransition(
//       position: Tween<Offset>(
//         begin: const Offset(-1, 0),
//         end: Offset.zero,
//       ).animate(CurvedAnimation(
//         parent: animation,
//         curve: Curves.easeOut,
//       )),
//       child: Card(
//         color: Theme.of(context).cardColor,
//         margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//         elevation: 2,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(12.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.network(
//                   product.productImages[0].imageUrl ?? '',
//                   width: 80,
//                   height: 80,
//                   fit: BoxFit.cover,
//                   errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       locale,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${product.price.toStringAsFixed(2)} ${S.of(context).currency}',
//                       style: TextStyle(
//                         color: Theme.of(context).colorScheme.secondary,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Row(
//                       children: [
//                         _buildQuantityButton(
//                           context,
//                           icon: Icons.remove,
//                           onPressed: () => context
//                               .read<CartCubit>()
//                               .decreaseQuantity(product.id, context),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 12),
//                           child: Text(
//                             '${item.quantity}',
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         _buildQuantityButton(
//                           context,
//                           icon: Icons.add,
//                           onPressed: () => context
//                               .read<CartCubit>()
//                               .increaseQuantity(product.id, context),
//                         ),
//
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${price.toStringAsFixed(2)} ${S.of(context).currency}',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               IconButton(
//                 icon: const Icon(Icons.delete_outline, color: Colors.red),
//                 onPressed: () => context
//                     .read<CartCubit>()
//                     .removeItem(product.id, context),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildQuantityButton(BuildContext context, {required IconData icon, required VoidCallback onPressed}) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: IconButton(
//         icon: Icon(icon, size: 18),
//         onPressed: onPressed,
//         splashRadius: 20,
//         padding: EdgeInsets.zero,
//         constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
//       ),
//     );
//   }
//
//   Widget _buildBottomBar(BuildContext context, double total, int itemCount,CartModel cart) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
//       decoration: BoxDecoration(
//         color: Theme.of(context).scaffoldBackgroundColor,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 10,
//             offset: const Offset(0, -5),
//           ),
//         ],
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(20),
//           topRight: Radius.circular(20),
//         ),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 S.of(context).totalItems,
//                 style: Theme.of(context).textTheme.bodyLarge,
//               ),
//               Text(
//                 '$itemCount',
//                 style: Theme.of(context).textTheme.titleMedium,
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 S.of(context).total,
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               Text(
//                 '${total.toStringAsFixed(2)} ${S.of(context).currency}',
//                 style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   color: Theme.of(context).colorScheme.secondary,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),
//           SizedBox(
//             width: double.infinity,
//             child: CustomButton(
//              onPressed: () async {
//   final isAvailable = await context.read<CartCubit>().checkProductsAvilable(cart,context);
//   if (isAvailable) {
//     // كل المنتجات موجودة، روح لصفحة الدفع مثلاً
//     Navigator.push(context, MaterialPageRoute(builder: (_) =>  PayingView(cart:cart)));
//   }
// }
// , text:  S.of(context).checkout.toUpperCase()),
//           ),
//           SizedBox(height: AppDimensions.bottomBarHeight+20),
//
//         ],
//       ),
//     );
//   }
//
//   void _showClearCartDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: Theme.of(context).cardColor,
//         title: Text(S.of(context).clearCart),
//         content: Text(S.of(context).clearCartConfirmation),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text(S.of(context).cancel),
//           ),
//           TextButton(
//             onPressed: () {
//               context.read<CartCubit>().clearCart(context);
//               Navigator.pop(context);
//             },
//             child: Text(
//               S.of(context).clear,
//               style: const TextStyle(color: Colors.red),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }