import 'package:flutter/material.dart';
import 'package:myxmi/models/product.dart';
import 'package:myxmi/providers/recipe.dart';

TextEditingController textCtrl = TextEditingController();

class Fields extends StatefulWidget {
  final ProductModel product;
  final RecipeProvider recipe;
  const Fields({@required this.product, @required this.recipe});
  @override
  State<StatefulWidget> createState() => FieldsState();
}

class FieldsState extends State<Fields> {
  @override
  Widget build(BuildContext context) {
    final String _name =
        '${widget.product.name[0]?.toUpperCase()}${widget.product.name?.substring(1, widget.product.name?.length)}';
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: textCtrl,
        keyboardType: TextInputType.number,
        onSubmitted: (submitted) {
          widget.recipe.changeEstimatedWeight();
        },
        onChanged: (value) {
          widget.recipe.changeComposition(
              key: widget.product.name,
              value: value,
              type: widget.product.mesureType);
          widget.recipe.changeQuantity(
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
  }
}
