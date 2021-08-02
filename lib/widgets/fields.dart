import 'package:flutter/material.dart';
import 'package:myxmi/providers/recipe.dart';

TextEditingController textCtrl = TextEditingController();

class Fields extends StatefulWidget {
  final Map data;
  final RecipeProvider recipe;
  const Fields({@required this.data, @required this.recipe});
  @override
  State<StatefulWidget> createState() => FieldsState();
}

class FieldsState extends State<Fields> {
  @override
  Widget build(BuildContext context) {
    final List _ingredientName =
        widget.recipe.composition[widget.data['Name']].toString().split(' ');
    textCtrl = _ingredientName[0] != 'null'
        ? TextEditingController(text: _ingredientName[0] as String)
        : TextEditingController();
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
              key: widget.data['Name'] as String,
              value: value,
              type: widget.data['MesureType'] as String);
          widget.recipe.changeQuantity(
            key: widget.data.keys.toString(),
            value: value,
            type: widget.data['MesureType'] as String,
          );
        },
        onEditingComplete: () {},
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
