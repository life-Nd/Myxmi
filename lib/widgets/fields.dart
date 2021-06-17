import 'package:flutter/material.dart';
import 'package:myxmi/providers/recipe.dart';

FocusNode _componentNode = FocusNode();
List<TextEditingController> textEditingControllers = [];
var textFields = <TextField>[];

class Fields extends StatefulWidget {
  final Map data;
  final RecipeProvider recipe;
  Fields({@required this.data, @required this.recipe});
  createState() => FieldsState();
}

class FieldsState extends State<Fields> {
  List _keys = [];
  initState() {
    widget.data.keys.forEach((element) {
      var textEditingController =
          TextEditingController(text: widget.recipe.composition[element]);
      textEditingControllers.add(textEditingController);
    });
    _keys = widget.data.keys.toList();
    widget.recipe.hidden.forEach((element) {
      _keys.remove(element);
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _keys.length,
      shrinkWrap: true,
      itemBuilder: (_, int index) {
        print("KEYS: $_keys");
        print("DATA: -----${widget.data[_keys[index]]}");
        Map _data = widget.data[_keys[index]];
        // 1 ml oil = 0.947 gram oil;
        // 1 Drop oil = 0.05 ml
        // 0.05 ml oil = 0.0474 gram;
        return Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            widget.data.remove(_keys[index]);
            widget.recipe.hide(component: _keys[index]);
            print("REMOVED: ${_keys[index]}");
            print("DISMISSED $direction");
          },
          background: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Delete',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Icon(Icons.delete),
                ],
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              keyboardType: TextInputType.number,
              controller: textEditingControllers[index],
              onSubmitted: (submitted) {
                widget.recipe.changeEstimatedWeight();
                FocusScope.of(context).requestFocus(FocusNode());
              },
              onChanged: (value) {
                widget.recipe.changeComposition(
                    key: _keys[index],
                    value: '$value',
                    type: widget.data[_keys[index]]);
                print("VALUE: ${widget.data[_keys[index]]}");
                widget.recipe.changeQuantity(
                    key: _keys[index],
                    value: '$value',
                    type: widget.data[_keys[index]]);
              },
              onEditingComplete: () {},
              focusNode: _componentNode,
              decoration: InputDecoration(
                hintText: '${_data['Name']}',
                labelText: '${_data['MesureType']}',
                // suffix: Text('${widget.data[_keys[index]]}'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
