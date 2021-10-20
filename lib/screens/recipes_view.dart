import 'package:flutter/material.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/widgets/auto_complete_recipes.dart';
import 'package:myxmi/widgets/recipes_grid.dart';

TextEditingController _searchMyRecipesCtrl = TextEditingController();

class RecipesView extends StatefulWidget {
  final List<RecipeModel> recipesList;
  final bool showAutoCompleteField;

  const RecipesView(
      {Key key,
      @required this.recipesList,
      @required this.showAutoCompleteField})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  @override
  void initState() {
    _searchMyRecipesCtrl = TextEditingController();
    super.initState();
  }

  List<RecipeModel> _filterRecipes() {
    final List<RecipeModel> _filteredRecipes = [];
    final Iterable _filter = widget.recipesList.asMap().entries.where((entry) {
      return entry.value.toMap().containsValue(
            _searchMyRecipesCtrl.text.trim().toLowerCase(),
          );
    });
    final _filtered = Map.fromEntries(_filter as Iterable<MapEntry>);
    _filtered.forEach((key, value) {
      _filteredRecipes.add(value as RecipeModel);
    });
    return _filteredRecipes;
  }

  @override
  Widget build(BuildContext context) {
    final double _bottomPadding = MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: _bottomPadding),
      child: StatefulBuilder(
        builder: (context, StateSetter stateSetter) {
          return RefreshIndicator(
            onRefresh: () async {
              _filterRecipes().clear();
              _searchMyRecipesCtrl.clear();
              stateSetter(() {});
            },
            child: Column(
              children: [
                if (widget.showAutoCompleteField)
                  Row(
                    children: [
                      Expanded(
                        child: AutoCompleteRecipes(
                          suggestions: widget.recipesList,
                          controller: _searchMyRecipesCtrl,
                          onSubmit: () {
                            _filterRecipes().clear();
                            stateSetter(() {});
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.clear,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          _filterRecipes().clear();
                          _searchMyRecipesCtrl.clear();
                          stateSetter(() {});
                        },
                      ),
                    ],
                  ),
                const SizedBox(height: 4),
                // Put snapshot data in a gridview
                Expanded(
                  child: RecipesGrid(
                    recipes: _searchMyRecipesCtrl.text.isEmpty
                        ? widget.recipesList
                        : _filterRecipes(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
