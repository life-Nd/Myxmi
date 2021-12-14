import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/recipes/list/widgets/recipes_search_field.dart';

class RecipesSuggestions extends StatelessWidget {
  const RecipesSuggestions({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Consumer(
        builder: (_, ref, child) {
          final _recipesSearch = ref.watch(recipesSearchProvider);
          final _suggestions = _recipesSearch.suggestions();
          return ListView.builder(
            shrinkWrap: true,
            itemCount: _suggestions.length,
            itemBuilder: (_, int index) {
              final _suggestion = _suggestions[index];
              final _name = _suggestion.title!;
              return Card(
                child: ListTile(
                  onTap: () {
                    if (!kIsWeb) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    }
                    FocusScope.of(context).unfocus();
                    _recipesSearch.selectRecipe(_suggestion);
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
                            color: _recipesSearch.searchText
                                    .toLowerCase()
                                    .contains(_name[index])
                                ? Colors.green
                                : Theme.of(context).textTheme.bodyText1!.color,
                            fontWeight: _recipesSearch.searchText
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
