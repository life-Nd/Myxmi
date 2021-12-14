import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/products/read/widgets/search_products.dart';

class ProductsSuggestions extends StatelessWidget {
  const ProductsSuggestions({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Consumer(
        builder: (_, ref, child) {
          final _productsSearch = ref.watch(productsSearchProvider);
          final _suggestions = _productsSearch.suggestions();
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _suggestions.length,
            itemBuilder: (_, int index) {
              final _suggestion = _suggestions[index];
              final _name = _suggestion.name!;
              return Card(
                child: ListTile(
                  onTap: () {
                    if (!kIsWeb) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                    FocusScope.of(context).unfocus();
                    _productsSearch.selectProduct(_suggestion);
                  },
                  dense: true,
                  leading: const Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  title: SizedBox(
                    height: 33,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _name.length,
                      itemBuilder: (_, int index) {
                        return Text(
                          index == 0
                              ? _name[index].toUpperCase()
                              : _name[index],
                          style: TextStyle(
                            fontSize: 23,
                            color: _productsSearch.searchText
                                    .toLowerCase()
                                    .contains(_name[index])
                                ? Colors.green
                                : Theme.of(context)
                                    .appBarTheme
                                    .titleTextStyle!
                                    .color,
                            fontWeight: _productsSearch.searchText
                                    .toLowerCase()
                                    .contains(_name[index])
                                ? FontWeight.bold
                                : FontWeight.w500,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
