import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/models/product.dart';
import 'package:easy_localization/easy_localization.dart';

class AutoCompleteProducts extends StatefulWidget {
  final List<ProductModel> suggestions;
  final TextEditingController controller;
  final Function onSubmit;
  const AutoCompleteProducts(
      {Key key,
      @required this.suggestions,
      @required this.controller,
      @required this.onSubmit})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _AutoCompleteProductsState();
}

class _AutoCompleteProductsState extends State<AutoCompleteProducts> {
  GlobalKey<AutoCompleteTextFieldState<ProductModel>> key = GlobalKey();
  AutoCompleteTextField _searchTextField;

  _AutoCompleteProductsState();
  @override
  Widget build(BuildContext context) {
    // ignore: join_return_with_assignment
    _searchTextField = AutoCompleteTextField<ProductModel>(
      clearOnSubmit: false,
      controller: widget.controller,
      key: key,
      itemBuilder: (context, item) {
        return Card(
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${item.name[0].toUpperCase()}${item.name.substring(1, item.name.length)}',
                  style: const TextStyle(fontSize: 20.0),
                ),
                const Padding(
                  padding: EdgeInsets.all(15.0),
                ),
                Text(
                  '${item.ingredientType[0].toUpperCase()}${item.ingredientType.substring(1, item.ingredientType.length)}',
                  style: const TextStyle(fontSize: 17.0),
                )
              ],
            ),
          ),
        );
      },
      itemFilter: (item, query) {
        return item.name.toLowerCase().startsWith(query.toLowerCase());
      },
      itemSorter: (a, b) {
        return a.name.compareTo(b.name);
      },
      itemSubmitted: (item) {
        _searchTextField.textField.controller.text = item.name;
        widget.onSubmit();
      },
      suggestions: widget.suggestions,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        filled: true,
        hintText: 'searchInMyProducts'.tr(),
      ),
    );
    return _searchTextField;
  }
}
