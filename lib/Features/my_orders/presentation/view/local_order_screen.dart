import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_vendor_e_commerce_app/Features/my_orders/presentation/manger/order_cubit/order_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/my_orders/presentation/view/widgets/local_order_card.dart';
import 'package:multi_vendor_e_commerce_app/Features/my_orders/presentation/view/widgets/order_card.dart';
import 'package:multi_vendor_e_commerce_app/core/models/order_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_button.dart';
import '../../../../core/utils/widgets/loading_widget.dart';
import '../../../../generated/l10n.dart';
import '../../data/repos/my_order_repo/my_order_repo_impl.dart';
import '../manger/local_order_cubit/local_order_cubit.dart';

class LocalLocalOrderScreen extends StatelessWidget {
  const LocalLocalOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider<LocalOrderCubit>(
      create: (context) =>
      LocalOrderCubit(MyOrderRepoImpl())
        ..getMyLocalOrders(),
      child: BlocBuilder<LocalOrderCubit, LocalOrderState>(
        builder: (context, state) {
          if (state is! LocalOrderLoaded) {
            return  Center(
              child: loadingWidget(context),
            );
          }
          if (state.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 80,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .secondary,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    S
                        .of(context)
                        .noOrders,
                    style: AppStyles.regular16(context).copyWith(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    S
                        .of(context)
                        .noOrdersSubtitle,
                    style: AppStyles.regular14(context).copyWith(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(0.5),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: state.orders.length,
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return LocalOrderCard(order: order);
            },
          );
        },
      ),
    );
  }
}





