import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';

TextEditingController textCtrl = TextEditingController();

class ProductField extends StatelessWidget {
  final ProductModel product;
  const ProductField({@required this.product});

  @override
  Widget build(BuildContext context) {
    final String _name =
        '${product.name[0]?.toUpperCase()}${product.name?.substring(1, product.name?.length)}';
    return Consumer(builder: (_, watch, __) {
      final _recipe = watch(recipeProvider);
      textCtrl = TextEditingController(
          text: _recipe.composition[product.name] != null
              ? _recipe.composition[product.name]
                  .toString()
                  .split(' ')
                  .toList()[0]
              : '');

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: textCtrl,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],

          keyboardType: TextInputType.number,
          onSubmitted: (submitted) {
            _recipe.changeEstimatedWeight();
          },

          onChanged: (value) {
            _recipe.changeComposition(
                key: product.name, value: value, type: product.mesureType);
            _recipe.changeQuantity(
              key: product.name.toString(),
              value: value,
              type: product.mesureType,
            );
          },
          onEditingComplete: () {},
          decoration: InputDecoration(
            labelText: _name,
            suffixText: product.mesureType,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    });
  }
}
