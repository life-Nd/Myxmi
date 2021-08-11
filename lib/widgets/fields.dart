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
    final List _ingredientName =
        widget.recipe.composition[widget.product.name].toString().split(' ');
    textCtrl = _ingredientName[0] != 'null'
        ? TextEditingController(text: _ingredientName[0] as String)
        : TextEditingController();
// TODO change the first letter of the title to a capital letter
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
          labelText: widget.product.name,
          suffixText: widget.product.mesureType,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
