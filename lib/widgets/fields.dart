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
    widget.data.keys.forEach((element) {
      textCtrl =
          TextEditingController(text: widget.recipe.composition[element]);
    });

    super.initState();
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: textCtrl,
        keyboardType: TextInputType.number,
        onSubmitted: (submitted) {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        onChanged: (value) {
          
          print('KEY: $value');
          print('VALUE: ${widget.data['MesureType']}');
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
          hintText: '${widget.data['MesureType']}',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
