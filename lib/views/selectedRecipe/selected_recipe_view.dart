import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/streams/instructions.dart';
import '../selectedRecipe/widgets/add_favorite.dart';
import '../selectedRecipe/widgets/creator_card.dart';
import '../selectedRecipe/widgets/recipe_details.dart';
import '../selectedRecipe/widgets/similar_recipes.dart';
import 'widgets/calendar_button.dart';
import 'widgets/share_button.dart';

final selectedRecipeView = ChangeNotifierProvider(
  (ref) => _SelectedRecipeViewNotifier(),
);

class SelectedRecipe extends StatefulWidget {
  const SelectedRecipe({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SelectionRecipeState();
}

class _SelectionRecipeState extends State<SelectedRecipe> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final Orientation _orientation = MediaQuery.of(context).orientation;
    final double _height = _size.height;
    final ScrollController _ctrl = ScrollController();
    return Consumer(
      builder: (_, watch, __) {
        final _recipe = watch(recipeDetailsProvider);
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              controller: _ctrl,
              slivers: [
                SliverAppBar(
                  actions: [
                    const CalendarButton(),
                    AddFavoriteButton(recipe: _recipe.recipe),
                    const ShareButton(),
                  ],
                  leadingWidth: 30,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  title: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      '${_recipe.recipe.title[0].toUpperCase()}${_recipe.recipe.title.substring(1, _recipe.recipe.title.length).toLowerCase()} ',
                      style: const TextStyle(
                          fontSize: 19, fontWeight: FontWeight.w700),
                    ),
                  ),
                  flexibleSpace: Opacity(
                    opacity: 0.9,
                    child: _recipe.image,
                  ),
                  expandedHeight:
                      kIsWeb || _orientation == Orientation.landscape
                          ? _height * 0.6
                          : _height * 0.5,
                ),
                SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      const CreatorCard(),
                      SizedBox(
                        height: _height * 0.90,
                        child: StreamInstructionsBuilder(),
                      ),
                      ListTile(
                        title: Text('similarRecipes'.tr(),
                            style: const TextStyle(fontSize: 20)),
                      ),
                      SimilarRecipes(
                        suggestedRecipes: _recipe.suggestedRecipes,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SelectedRecipeViewNotifier extends ChangeNotifier {
  int pageIndex = 0;
  void changeIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }
}
