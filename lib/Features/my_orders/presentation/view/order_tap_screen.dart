import 'package:flutter/material.dart';

import '../../../../core/utils/styles/app_styles.dart';
import '../../../../generated/l10n.dart';
import 'local_order_screen.dart';
import 'order_screen.dart';

class OrdersTabbedScreen extends StatelessWidget {
  const OrdersTabbedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // عدد التابات
      child: Scaffold(
        appBar: AppBar(
          title: Text(S
              .of(context)
              .myOrders,
            style: AppStyles.bold20(context).copyWith(
              color: Theme
                  .of(context)
                  .colorScheme
                  .onBackground,
            ),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,

        bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs:  [
              Tab(text: S.of(context).online),
              Tab(text: S.of(context).local),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OrderScreen(),           // الطلبات الأونلاين
            LocalLocalOrderScreen(), // الطلبات المحلية
          ],
        ),
      ),
    );
  }
}
