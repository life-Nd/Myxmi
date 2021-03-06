import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import 'package:myxmi/providers/recipe_entries.dart';

TextEditingController textCtrl = TextEditingController();

class ProductField extends StatelessWidget {
  final ProductModel? product;
  const ProductField({required this.product});

  @override
  Widget build(BuildContext context) {
    final String _name = product!.name != null
        ? '${product!.name![0].toUpperCase()}${product!.name?.substring(1, product!.name?.length)}'
        : '';
    return Consumer(
      builder: (_, ref, __) {
        final _recipe = ref.watch(recipeEntriesProvider);
        bool _isNotEmpty;
        if (_recipe.ingredients.isNotEmpty &&
            product!.productId!.isNotEmpty &&
            _recipe.ingredients[product!.productId] != null) {
          _isNotEmpty = true;
        } else {
          _isNotEmpty = false;
        }
        final Map? _composition =
            _recipe.ingredients[product!.productId] as Map?;
        textCtrl = TextEditingController(
          text: _isNotEmpty
              ? _composition!['value'].toString().split(' ').toList()[0]
              : '',
        );
        if (product?.left == null || product?.left == '') {
          product!.left = '0';
        }
        return Column(
          children: [
            ListTile(
              leading: Text(
                _name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              title: Container(
                constraints: const BoxConstraints(maxWidth: 100),
                width: 100,
                child: TextField(
                  controller: textCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    signed: true,
                    decimal: true,
                  ),
                  onSubmitted: (submitted) {
                    _recipe.setEstimatedWeight();
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (value) {
                    _recipe.addIngredient(
                      name: product!.name,
                      key: product!.productId,
                      value: value,
                      type: product!.mesureType,
                    );
                    _recipe.setQuantity(
                      key: product!.name,
                      value: value,
                      type: product!.mesureType,
                    );
                  },
                  onEditingComplete: () {},
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorText:
                        '${product!.left} ${product!.mesureType} ${'left'.tr()}',
                    errorStyle: TextStyle(
                      fontSize: 12,
                      color: double.parse(product!.left!) < 1
                          ? Colors.red
                          : Colors.grey.shade700,
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: double.parse(product!.left!) < 1
                            ? Colors.red
                            : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(left: 1),
                child: Text(
                  product!.mesureType!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Divider(color: Colors.grey.shade700)
          ],
        );
      },
    );
  }
}
