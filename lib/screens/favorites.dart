import 'package:myxmi/models/recipes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/widgets/recipes_grid.dart';
import 'package:easy_localization/easy_localization.dart';
import '../app.dart';

class Favorites extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _fav = useProvider(favProvider);
    final _change = useState<bool>(false);
    final Map _data = _fav.showFiltered ? _fav.filtered : _fav.allRecipes;
    final List<RecipesModel> _recipes = _data.entries.map((MapEntry data) {
      return RecipesModel.fromSnapshot(
        snapshot: data.value as Map<String, dynamic>,
        keyIndex: data.key as String,
      );
    }).toList();

    return RefreshIndicator(
      onRefresh: () async {
        _fav.showFilter(value: false);
        _change.value = !_change.value;
      },
      child: _recipes.isNotEmpty
          ? RecipesGrid(
              recipes: _recipes,
              type: 'Favorites',
            )
          : Center(
              child: Text('noFavorites'.tr()),
            ),
    );
  }
}
