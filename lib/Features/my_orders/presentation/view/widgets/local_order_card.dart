import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:multi_vendor_e_commerce_app/Features/my_orders/presentation/manger/order_cubit/order_cubit.dart';
import 'package:multi_vendor_e_commerce_app/Features/my_orders/presentation/view/widgets/status_config.dart';
import 'package:multi_vendor_e_commerce_app/core/models/order_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/custom_button.dart';

import '../../../../../core/models/local_order_model.dart';
import '../../../../../generated/l10n.dart';
import '../../manger/local_order_cubit/local_order_cubit.dart';
import 'local_order_item_tile.dart';
import 'order_item_tile.dart';

class LocalOrderCard extends StatefulWidget {
  final LocalOrderModel order;

  const LocalOrderCard({required this.order});

  @override
  State<LocalOrderCard> createState() => LocalOrderCardState();
}

class LocalOrderCardState extends State<LocalOrderCard> {
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
          color: Theme.of(context).cardColor,
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
                          style: AppStyles.bold16(context),
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
                                style: AppStyles.semiBold14(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (widget.order.status < 2) // Show progress only for pending and paid
                      _buildLocalOrderProgress(widget.order.status, context),
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
                              style: AppStyles.regular14(context),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${widget.order.totalPrice.toStringAsFixed(2)} ${locale.currency}',
                              style: AppStyles.semiBold16(context),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              locale.orderDate,
                              style: AppStyles.regular14(context),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dateFormat.format(widget.order.createdAt),
                              style: AppStyles.medium14(context),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Items title
                    Text(
                      '${locale.items} (${widget.order.localOrderItems.length})',
                      style: AppStyles.semiBold16(context),
                    ),
                    const SizedBox(height: 12),
                    // Items list
                    ...widget.order.localOrderItems
                        .map((item) => LocalOrderItemTile(
                      item: item,
                      status: widget.order.status,
                    ))
                        .toList(),
                    const SizedBox(height: 16),
                    // Action buttons
                    if (widget.order.status == 0) // Show cancel button only for pending
                      CustomButton(
                        onPressed: () async {
                          await context
                              .read<LocalOrderCubit>()
                              .cancelLocalOrder(
                              widget.order.id, S.of(context).orderOutForDelivery);
                        },
                        text: locale.cancelOrder,
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocalOrderProgress(int status, BuildContext context) {
    final double totalWidth = MediaQuery.of(context).size.width - 64;
    final double stepWidth = totalWidth; // Two steps for pending and paid

    return Column(
      children: [
        // Progress line
        Stack(
          alignment: LanguageHelper.isArabic() ? Alignment.centerRight : Alignment.centerLeft,
          children: [
            // Background line
            Container(
              height: 6,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(3),
              ),
              width: totalWidth,
            ),
            // Progress line
            AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              height: 6,
              width: status == 0 ? 0 : stepWidth,
              decoration: BoxDecoration(
                color: _getStatusColor(status),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Circles and labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildProgressStep(0, S.of(context).pending, status),
            _buildProgressStep(1, S.of(context).paid, status),
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
            color: isActive ? _getStatusColor(step) : Theme.of(context).cardColor,
            border: isCurrent
                ? Border.all(
              color: Theme.of(context).colorScheme.background,
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
          style: AppStyles.regular12(context),
        ),
      ],
    );
  }

  Color _getStatusColor(int status) {
    switch (status) {
      case 0: // Pending
        return Colors.orange;
      case 1: // Paid
        return Colors.green;
      case 2: // Canceled
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(int status) {
    switch (status) {
      case 0: // Pending
        return Icons.access_time;
      case 1: // Paid
        return Icons.check_circle;
      case 2: // Canceled
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  StatusConfig _getStatusConfig(int status, BuildContext context) {
    switch (status) {
      case 0: // Pending
        return StatusConfig(
          text: S.of(context).pending,
          icon: Icons.access_time,
          textColor: Theme.of(context).textTheme.bodyLarge!.color!,
          backgroundColor: Colors.orange,
        );
      case 1: // Paid
        return StatusConfig(
          text: S.of(context).paid,
          icon: Icons.check_circle,
          textColor: Theme.of(context).textTheme.bodyLarge!.color!,
          backgroundColor: Colors.green,
        );
      case 2: // Canceled
        return StatusConfig(
          text: S.of(context).canceled,
          icon: Icons.cancel,
          textColor: Theme.of(context).textTheme.bodyLarge!.color!,
          backgroundColor: Colors.red,
        );
      default:
        return StatusConfig(
          text: S.of(context).unknown,
          icon: Icons.help,
          textColor: Theme.of(context).textTheme.bodyLarge!.color!,
          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        );
    }
  }
}