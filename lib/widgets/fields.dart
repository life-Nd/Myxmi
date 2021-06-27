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

  Widget build(BuildContext context) {
    List _ingredientName =
        widget.recipe.composition[widget.data['Name']].toString().split(' ');
    textCtrl = _ingredientName[0] != 'null'
        ? TextEditingController(text: _ingredientName[0])
        : TextEditingController();
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
          widget.recipe.changeEstimatedWeight();
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
