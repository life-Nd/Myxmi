import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/models/product.dart';

class AutoCompleteProducts extends StatefulWidget {
  final List<ProductModel> suggestions;
  final TextEditingController controller;
  final Function onSubmit;
  final Function onClear;
  const AutoCompleteProducts(
      {Key key,
      @required this.suggestions,
      @required this.controller,
      @required this.onSubmit,
      @required this.onClear})
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
      textSubmitted: (submitted) {
        _searchTextField.textField.controller.text = submitted;
        widget.onSubmit();
      },
      
      itemBuilder: (context, item) {
        return Card(
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    '${item.name[0].toUpperCase()}${item.name.substring(1, item.name.length)}',
                    style: const TextStyle(fontSize: 20.0),
                  ),
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
        _searchTextField.textField.controller.text =
            '${item.name[0].toUpperCase()}${item.name.substring(1, item.name.length)}';
        widget.onSubmit();
      },
      suggestions: widget.suggestions,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
        filled: true,
        hintText: 'searchInMyProducts'.tr(),
        prefixIcon: IconButton(
            icon: const Icon(
              Icons.clear,
              color: Colors.red,
            ),
            onPressed: () {
              widget.onClear();
              _searchTextField.clear();
            }),
      ),
    );
    return _searchTextField;
  }
}

// class ProductSuggestionsProvider extends ChangeNotifier {
//   String text;
//   bool doSearch;
//   List<ProductModel> suggestions;

//   void searchText(String _text) {
//     text = _text;
//     doSearch = true;
//     notifyListeners();
//   }

//   void stopSearch() {
//     doSearch = false;
//     notifyListeners();
//   }
// }
