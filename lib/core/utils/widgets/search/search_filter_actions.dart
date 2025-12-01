import 'package:flutter/material.dart';
import 'package:multi_vendor_e_commerce_app/core/utils/styles/app_styles.dart';
import '../../../../generated/l10n.dart';
import '../../../models/product_model.dart';
import '../custom_button.dart';
import 'search_filter_helper.dart';

class ProductFilterActions {
  static void showSortSheet({
    required BuildContext context,
    required String selectedSort,
    required List<ProductModel> currentProducts,
    required Function(String newSort, List<ProductModel> sortedList) onApply,
  }) {
    String tempSelectedSort = selectedSort;

    showModalBottomSheet(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    S.of(context).sortBy,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  RadioListTile<String>(

                    title: Text(S.of(context).priceLowToHigh,style: AppStyles.semiBold16(context),),
                    value: 'price_low_to_high',
                    groupValue: tempSelectedSort,
                    onChanged:
                        (value) =>
                            setModalState(() => tempSelectedSort = value!),
                  ),
                  RadioListTile<String>(
                    title: Text(S.of(context).priceHighToLow,style: AppStyles.semiBold16(context),),
                    value: 'price_high_to_low',
                    groupValue: tempSelectedSort,
                    onChanged:
                        (value) =>
                            setModalState(() => tempSelectedSort = value!),
                  ),
                  RadioListTile<String>(
                    title: Text(S.of(context).alphabetical,style: AppStyles.semiBold16(context),),
                    value: 'alphabetical',
                    groupValue: tempSelectedSort,
                    onChanged:
                        (value) =>
                            setModalState(() => tempSelectedSort = value!),
                  ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: S.of(context).apply,
                    onPressed: () {
                      List<ProductModel> sorted;
                      if (tempSelectedSort == 'price_low_to_high') {
                        sorted = ProductFilterHelper.sortByPriceLowToHigh(
                          currentProducts,
                        );
                      } else if (tempSelectedSort == 'price_high_to_low') {
                        sorted = ProductFilterHelper.sortByPriceHighToLow(
                          currentProducts,
                        );
                      } else {
                        sorted = ProductFilterHelper.sortByAlphabetical(
                          currentProducts,
                        );
                      }
                      onApply(tempSelectedSort, sorted);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static void showPriceFilterSheet({
    required BuildContext context,
    required List<ProductModel> products,
    required TextEditingController fromController,
    required TextEditingController toController,
    required GlobalKey<FormState> formKey,
    required Function(List<ProductModel> filteredList) onApply,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    S.of(context).filterByPrice,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: fromController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: S.of(context).availableFrom,
                          ),
                          validator: (value) {
                            final from = double.tryParse(value ?? '');
                            final to = double.tryParse(toController.text);
                            if (from == null) {
                              return S.of(context).enterStartPrice;
                            }
                            if (to != null && from > to) {
                              return S.of(context).enterValidPrice;
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(S.of(context).to),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          controller: toController,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(
                            hintText: S.of(context).to,
                          ),
                          validator: (value) {
                            final to = double.tryParse(value ?? '');
                            final from = double.tryParse(fromController.text);
                            if (to == null) return S.of(context).enterEndPrice;
                            if (from != null && from > to) {
                              return S.of(context).enterValidPrice;
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        final from = double.parse(fromController.text);
                        final to = double.parse(toController.text);
                        final result = ProductFilterHelper.filterByPriceRange(
                          products,
                          from,
                          to,
                        );
                        onApply(result);
                        Navigator.pop(context);
                      }
                    },
                    text: S.of(context).apply,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
