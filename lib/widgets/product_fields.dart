import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/product.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';

TextEditingController textCtrl = TextEditingController();

class ProductField extends StatefulWidget {
  final ProductModel product;
  const ProductField({@required this.product});
  @override
  State<StatefulWidget> createState() => ProductFieldState();
}

class ProductFieldState extends State<ProductField> {
  @override
  Widget build(BuildContext context) {
    final String _name =
        '${widget.product.name[0]?.toUpperCase()}${widget.product.name?.substring(1, widget.product.name?.length)}';
    return Consumer(builder: (_, watch, __) {
      final _recipe = watch(recipeProvider);
      debugPrint('Composition ${_recipe.composition[widget.product.name]}');
      textCtrl = TextEditingController(
          text: _recipe.composition[widget.product.name] != null
              ? _recipe.composition[widget.product.name]
                  .toString()
                  .split(' ')
                  .toList()[0]
              : '');

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: textCtrl,
          keyboardType: TextInputType.number,
          onSubmitted: (submitted) {
            _recipe.changeEstimatedWeight();
          },
          onChanged: (value) {
            _recipe.changeComposition(
                key: widget.product.name,
                value: value,
                type: widget.product.mesureType);
            _recipe.changeQuantity(
              key: widget.product.name.toString(),
              value: value,
              type: widget.product.mesureType,
            );
          },
          onEditingComplete: () {},
          decoration: InputDecoration(
            labelText: _name,
            suffixText: widget.product.mesureType,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      );
    });
  }
}
