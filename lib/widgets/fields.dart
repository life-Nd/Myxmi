import 'package:flutter/material.dart';
import 'package:myxmi/providers/recipe.dart';

TextEditingController textCtrl = TextEditingController();

class Fields extends StatefulWidget {
  final Map data;
  final RecipeProvider recipe;
  Fields({@required this.data, @required this.recipe});
  createState() => FieldsState();
}

class FieldsState extends State<Fields> {
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    print('---WIDGET.data: ${widget.data}');
    print('---WIDGET.data.values: ${widget.data.values}');
    print('---WIDGET.recipe.composition ${widget.recipe.composition}');
    List _ingredientName =
        widget.recipe.composition[widget.data['Name']].toString().split(' ');
    print('Ingredient: $_ingredientName');
    textCtrl = TextEditingController(text: _ingredientName[0]);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: textCtrl,
        keyboardType: TextInputType.number,
        onSubmitted: (submitted) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        onChanged: (value) {
          widget.recipe.changeComposition(
              key: widget.data['Name'],
              value: '$value',
              type: widget.data['MesureType']);
          widget.recipe.changeQuantity(
            key: widget.data.keys.toString(),
            value: '$value',
            type: widget.data['MesureType'],
          );
        },
        onEditingComplete: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        decoration: InputDecoration(
          labelText: '${widget.data['Name']}',
          suffixText: '${widget.data['MesureType']}',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
