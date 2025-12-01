import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:multi_vendor_e_commerce_app/Features/my_orders/presentation/manger/order_cubit/order_cubit.dart';
import 'package:multi_vendor_e_commerce_app/core/models/order_model.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/functions/is_arabic.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/widgets/loading_widget.dart';
import 'package:multi_vendor_e_commerce_app/features/my_orders/data/repos/rate_repo/rate_repo_impl.dart';
import 'package:multi_vendor_e_commerce_app/features/my_orders/presentation/manger/rate_cubit/rate_cubit.dart';
import 'package:multi_vendor_e_commerce_app/generated/l10n.dart';

import '../../../../home/presentation/manger/product_cubit/product_cubit.dart';
import '../../manger/local_order_cubit/local_order_cubit.dart';

class AddReviewScreen extends StatefulWidget {
  final OrderItem item;

  const AddReviewScreen({super.key, required this.item});

  @override
  State<AddReviewScreen> createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _commentController;
  double? _rating;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    // Initialize with existing review data, if any
    final myRate = widget.item.product.myRate;
    _rating = myRate?.id.isNotEmpty == true ? myRate!.rate : null;
    _commentController = TextEditingController(
      text: myRate?.id.isNotEmpty == true ? myRate!.comment : null,
    );
    // Debug print to verify myRate
    print('myRate: id=${myRate?.id}, rate=${myRate?.rate}, comment=${myRate?.comment}');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  late ProductCubit productCubit;
  late OrderCubit orderCubit;
  late LocalOrderCubit localOrderCubit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    productCubit = context.read<ProductCubit>();
    orderCubit = context.read<OrderCubit>();
    localOrderCubit = context.read<LocalOrderCubit>();
  }

  Future<void> _submitReview(BuildContext context) async {
    if (_isSubmitting) return;
    if (_formKey.currentState!.validate() && _rating != null && _rating! > 0) {
      _isSubmitting = true;
      final rateCubit = context.read<RateCubit>();
      final myRate = widget.item.product.myRate;

      try {
        if (myRate?.id.isNotEmpty == true) {
          await rateCubit.updateRateProduct(
            context: context,
            rateId: myRate!.id,
            rate: _rating!.round(),
            comment: _commentController.text,
          );
        } else {
          await rateCubit.addRateProduct(
            context: context,
            productId: widget.item.product.id,
            rate: _rating!.round(),
            comment: _commentController.text,
          );
        }
      } finally {
        await Future.wait([
          productCubit.getProducts(),
          orderCubit.getMyOrders(),
          localOrderCubit.getMyLocalOrders(),
        ]);
        _isSubmitting = false;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider<RateCubit>(
      create: (context) => RateCubit(RateRepoImpl()),
      child: Builder(
        builder: (BuildContext providerContext) {
          return BlocListener<RateCubit, RateState>(
            listener: (context, state) {
              if (state is AddRateLoading || state is UpdateRateLoading) {
                setState(() {
                  _isSubmitting = true;
                });
              } else if (state is AddRateSuccess || state is UpdateRateSuccess) {
                setState(() {
                  _isSubmitting = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).reviewSubmitted),
                    backgroundColor: Colors.green,
                  ),
                );
                Navigator.pop(context);
              } else if (state is AddRateError || state is UpdateRateError) {
                setState(() {
                  _isSubmitting = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(S.of(context).error),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  LanguageHelper.isArabic()
                      ? S.of(context).add_review_ar
                      : S.of(context).add_review_en,
                ),
                centerTitle: true,
              ),
              body: _isSubmitting
                  ? Center(child: loadingWidget(context))
                  : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Info
                        Text(
                          LanguageHelper.isArabic()
                              ? widget.item.product.arabicName ??
                              S.of(context).product
                              : widget.item.product.englishName ??
                              S.of(context).product,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        // Rating Section
                        Text(
                          S.of(context).rating,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        RatingStars(
                          value: _rating ?? 0.0,
                          onValueChanged: (value) {
                            setState(() {
                              _rating = value;
                            });
                          },
                          starCount: 5,
                          starSize: 30,
                          valueLabelVisibility: false,
                          starColor: Colors.amber,
                          starOffColor: Colors.grey.shade400,
                          maxValue: 5.0,
                        ),
                        const SizedBox(height: 16),
                        // Comment Section
                        Text(
                          S.of(context).comment,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _commentController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: S.of(context).enter_comment,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return S.of(context).comment_required;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        // Submit Button
                        Center(
                          child: ElevatedButton(
                            onPressed: () => _submitReview(providerContext),
                            child: Text(
                              widget.item.product.myRate?.id.isNotEmpty ==
                                  true
                                  ? S.of(context).update_review
                                  : S.of(context).submit_review,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}