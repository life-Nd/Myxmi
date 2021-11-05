import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import 'package:myxmi/screens/add_infos_to_recipe.dart';

TextEditingController textCtrl = TextEditingController();

class ProductField extends StatelessWidget {
  final ProductModel product;
  const ProductField({@required this.product});

  @override
  Widget build(BuildContext context) {
    final String _name =
        '${product.name[0]?.toUpperCase()}${product.name?.substring(1, product.name?.length)}';
    return Consumer(
      builder: (_, watch, __) {
        final _recipe = watch(recipeProvider);
        textCtrl = TextEditingController(
            text: _recipe.composition[product.name] != null
                ? _recipe.composition[product.name]
                    .toString()
                    .split(' ')
                    .toList()[0]
                : '');
        // if (textCtrl.text.isEmpty) {
        // _remainder = '${int.parse(product?.total) - int.parse(textCtrl?.text)}';
        // }
        if (product?.total == null) {
          product.total = '0';
        }

        // _remainder = '${int.parse(product?.total) - int.parse(textCtrl?.text)}';

        return Column(
          children: [
            ListTile(
              // visualDensity: VisualDensity.compact,
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
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  keyboardType: TextInputType.number,
                  onSubmitted: (submitted) {
                    _recipe.changeEstimatedWeight();
                    FocusScope.of(context).unfocus();
                  },
                  onChanged: (value) {
                    _recipe.changeComposition(
                        key: product.name,
                        value: value,
                        type: product.mesureType);
                    _recipe.changeQuantity(
                      key: product.name.toString(),
                      value: value,
                      type: product.mesureType,
                    );
                  },
                  onEditingComplete: () {},
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorText:
                        '${product.total} ${product.mesureType} ${'left'.tr()}',
                    errorStyle: TextStyle(
                      fontSize: 12,
                      color: int.parse(product.total.toString()) < 1
                          ? Colors.red
                          : Colors.grey.shade700,
                    ),
                    filled: false,
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: int.parse(product.total.toString()) < 1
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
                  product.mesureType,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              // subtitle: Text(
              //   '${product.total} ${'left'.tr()}',
              //   style: const TextStyle(fontWeight: FontWeight.bold),
              // ),
            ),
            Divider(color: Colors.grey.shade700)
          ],
        );
      },
    );
  }
}
