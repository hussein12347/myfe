import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_vendor_e_commerce_app/Features/my_orders/presentation/manger/order_cubit/order_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/my_orders/presentation/view/widgets/status_config.dart';
import 'package:multi_vendor_e_commerce_app/core/models/order_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_button.dart';

import '../../../../../generated/l10n.dart';
import 'order_item_tile.dart';
class OrderCard extends StatefulWidget {
  final OrderModel order;

  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => OrderCardState();
}

class OrderCardState extends State<OrderCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final locale = S.of(context);
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    // Status configuration
    final statusConfig = _getStatusConfig(widget.order.status, context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          children: [
            // Header section
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Order number
                        Text(
                          '${locale.order} #${widget.order.number}',
                          style:AppStyles.bold16(context),
                        ),

                        // Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: statusConfig.backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                statusConfig.icon,
                                size: 14,
                                color: statusConfig.textColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                statusConfig.text,
                                style:AppStyles.semiBold14(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    if(widget.order.status <3)
                    // Progress indicator
                      _buildOrderProgress(widget.order.status,context),

                    const SizedBox(height: 16),

                    // Order summary
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              locale.total,
                              style: AppStyles.regular14(context).copyWith(

                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.order.totalPrice.toStringAsFixed(
                                  2)} ${locale.currency}',
                              style: AppStyles.semiBold16(context).copyWith(

                              ),
                            ),
                          ],
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              locale.orderDate,
                              style: AppStyles.regular14(context).copyWith(

                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dateFormat.format(widget.order.createdAt),
                              style: AppStyles.medium14(context).copyWith(

                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Expandable content
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: Container(),
              secondChild: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Items title
                    Text(
                      '${locale.items} (${widget.order.orderItems.length})',
                      style: AppStyles.semiBold16(context).copyWith(

                      ),
                    ),
                    const SizedBox(height: 12),

                    // Items list
                    ...widget.order.orderItems.map((item) =>
                        OrderItemTile(item: item, status: widget.order.status,)
                    ),

                    const SizedBox(height: 16),

                    // Action buttons

                    if(widget.order.status == 0)
                      CustomButton(onPressed: () async {
                        await context.read<OrderCubit>().cancelOrder(widget.order.id, S.of(context).orderOutForDelivery);
                      }, text: locale.cancelOrder)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderProgress(int status, BuildContext context) {
    final double totalWidth = MediaQuery.of(context).size.width - 64;
    final double stepWidth = totalWidth / 2; // عندك 3 مراحل = 2 مسافات

    return Column(
      children: [
        // الخط الأساسي
        Stack(
          alignment: LanguageHelper.isArabic()? Alignment.centerRight : Alignment.centerLeft,
          children: [
            // خلفية الخط
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(3),
              ),
              width: totalWidth,
            ),

            // الخط اللي بيكبر حسب المرحلة
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              height: 6,
              width: status == 0
                  ? 0
                  : status == 1
                  ? stepWidth
                  : totalWidth,
              decoration: BoxDecoration(
                color: _getStatusColor(status),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // الدوائر والتسميات
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildProgressStep(0, S
                .of(context)
                .pending, status),
            _buildProgressStep(1, S
                .of(context)
                .confirmed, status),
            _buildProgressStep(2, S
                .of(context)
                .shipped, status),
          ],
        ),
      ],
    );
  }


  Widget _buildProgressStep(int step, String label, int currentStatus) {
    final isActive = step <= currentStatus;
    final isCurrent = step == currentStatus;

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? _getStatusColor(step)
                : Theme
                .of(context)
                .cardColor,
            border: isCurrent
                ? Border.all(
              color: Theme
                  .of(context)
                  .colorScheme
                  .surface,
              width: 3,
            )
                : null,
          ),
          child: isActive
              ? Icon(
            _getStatusIcon(step),
            size: 12,
            color: Colors.white,
          )
              : null,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppStyles.regular12(context).copyWith(

          ),
        ),
      ],
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.purple;
      case 3:
        return Colors.green;
      case 4:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(int status) {
    switch (status) {
      case 0:
        return Icons.access_time;
      case 1:
        return Icons.check_circle;
      case 2:
        return Icons.local_shipping;
      case 3:
        return Icons.done_all;
      case 4:
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  StatusConfig _getStatusConfig(int status, BuildContext context) {
    switch (status) {
      case 0:
        return StatusConfig(
          text: S
              .of(context)
              .pending,
          icon: Icons.access_time,
          textColor: Theme.of(context).textTheme.bodyLarge!.color!,
          backgroundColor: Colors.orange,
        );
      case 1:
        return StatusConfig(
          text: S
              .of(context)
              .confirmed,
          icon: Icons.check_circle,
          textColor: Theme.of(context).textTheme.bodyLarge!.color!,
          backgroundColor: Colors.blue,
        );
      case 2:
        return StatusConfig(
          text: S
              .of(context)
              .shipped,
          icon: Icons.local_shipping,
          textColor: Theme.of(context).textTheme.bodyLarge!.color!,
          backgroundColor: Colors.purple,
        );


      case 3:
        return StatusConfig(
          text: S
              .of(context)
              .canceled,
          icon: Icons.cancel,
          textColor: Theme.of(context).textTheme.bodyLarge!.color!,
          backgroundColor: Colors.red,
        );
      default:
        return StatusConfig(
          text: S
              .of(context)
              .unknown,
          icon: Icons.help,
          textColor: Theme.of(context).textTheme.bodyLarge!.color!,
          backgroundColor: Theme
              .of(context)
              .colorScheme
              .surfaceContainerHighest,
        );
    }
  }
}