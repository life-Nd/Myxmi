import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:easy_localization/easy_localization.dart';

class AutoCompleteRecipes extends StatefulWidget {
  final List<RecipeModel> suggestions;
  final TextEditingController controller;
  final Function onSubmit;
  const AutoCompleteRecipes(
      {Key key,
      @required this.suggestions,
      @required this.controller,
      @required this.onSubmit})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoCompleteRecipes> {
  GlobalKey<AutoCompleteTextFieldState<RecipeModel>> key = GlobalKey();
  AutoCompleteTextField _searchTextField;

  _AutoCompleteState();
  @override
  Widget build(BuildContext context) {
    // ignore: join_return_with_assignment
    _searchTextField = AutoCompleteTextField<RecipeModel>(
      clearOnSubmit: false,
      controller: widget.controller,
      key: key,
      textSubmitted: (submitted) {
        _searchTextField.textField.controller.text = submitted;
        widget.onSubmit();
      },
      itemBuilder: (context, item) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${item.title[0].toUpperCase()}${item.title.substring(1, item.title.length)}',
                style: const TextStyle(fontSize: 20.0),
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
              ),
              Text(
                '${item.category[0].toUpperCase()}${item.category.substring(1, item.category.length)}',
                style: const TextStyle(fontSize: 17.0),
              )
            ],
          ),
        );
      },
      itemFilter: (item, query) {
        return item.title.toLowerCase().startsWith(query.toLowerCase());
      },
      itemSorter: (a, b) {
        return a.title.compareTo(b.title);
      },
      itemSubmitted: (item) {
        _searchTextField.textField.controller.text = item.title;
        widget.onSubmit();
      },
      suggestions: widget.suggestions,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        filled: true,
        hintText: 'searchRecipe'.tr(),
      ),
    );
    return _searchTextField;
  }
}
