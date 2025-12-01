import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_vendor_e_commerce_app/Features/cart/data/models/cart_model/cart_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';

class ChickOutWidget extends StatelessWidget {
  final CartModel cart;
  final String name;
  final String phone;
  final String address;
  final double deliveryPrice;
  final int payWay;
  const ChickOutWidget({
    super.key,
    required this.cart,
    required this.name,
    required this.phone,
    required this.address,
    required this.deliveryPrice,
    required this.payWay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                S.of(context).order_summary,
                style: AppStyles.bold24(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Card(
            color: Theme.of(context).cardColor,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          FontAwesomeIcons.edit,
                          size: 14,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          S.of(context).edit,
                          style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Name field
                  _buildInfoTile(
                    icon: Icons.person,
                    title: S.of(context).name,
                    value: name,
                  ),
                  const SizedBox(height: 12),
                  // Phone field
                  _buildInfoTile(
                    icon: Icons.phone,
                    title: S.of(context).phone_number,
                    value: phone,
                  ),
                  const SizedBox(height: 12),
                  // Address field
                  _buildInfoTile(
                    icon: FontAwesomeIcons.locationDot,
                    title: S.of(context).address,
                    value: address,
                  ),
                  const SizedBox(height: 12),
                  // Subtotal
                  _buildInfoTile(
                    icon: FontAwesomeIcons.dollarSign,
                    title: S.of(context).subtotal,
                    value: '${cart.total.toStringAsFixed(2)} ${S.of(context).currency}',
                  ),
                  const SizedBox(height: 12),
                  // Delivery
                  _buildInfoTile(
                    icon: Icons.delivery_dining,
                    title: S.of(context).delivery,
                    value: '${deliveryPrice.toStringAsFixed(2)} ${S.of(context).currency}',
                  ),
                  const SizedBox(height: 12),
                  // Payment Method
                  _buildInfoTile(
                    icon: Icons.payment,
                    title: S.of(context).payment_method,
                    value: payWay == 1
                        ? S.of(context).payOnline
                        :payWay == 2?S.of(context).payLocally: S.of(context).cashOnDelivery,
                  ),
                  const Divider(height: 32, thickness: 1.2),
                  // Total - Highlighted
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        FontAwesomeIcons.coins,
                        color: Colors.amber.shade800,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      S.of(context).total,
                      style: AppStyles.bold16(context),
                    ),
                    trailing: Text(
                      '${(deliveryPrice + cart.total).toStringAsFixed(2)} ${S.of(context).currency}',
                      style:  TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color:  Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable tile widget
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(icon, color: Colors.grey.shade600),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            value,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}