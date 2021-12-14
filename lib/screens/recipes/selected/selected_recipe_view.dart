import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/screens/recipes/selected/widgets/creator_card.dart';
import 'package:myxmi/screens/recipes/selected/widgets/recipe_details.dart';
import 'package:myxmi/screens/recipes/selected/widgets/similar_recipes.dart';
import 'package:myxmi/streams/ingredients.dart';

final selectedRecipeView = ChangeNotifierProvider<_SelectedRecipeViewNotifier>(
  (ref) => _SelectedRecipeViewNotifier(),
);

class SelectedRecipe extends StatefulWidget {
  const SelectedRecipe({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SelectionRecipeState();
}

class _SelectionRecipeState extends State<SelectedRecipe> {
  final ScrollController _ctrl = ScrollController();
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final double _height = _size.height;

    return Consumer(
      builder: (_, ref, __) {
        final _recipe = ref.watch(recipeDetailsProvider);
        final _recipeDetails = _recipe.details;
        final _router = ref.watch(routerProvider);
        return Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: RawMaterialButton(
            onPressed: () {
              _router.pushPage(name: '/instructions');
            },
            fillColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'getInstructions'.tr(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: CustomScrollView(
              controller: _ctrl,
              slivers: [
                SliverAppBar(
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
                      '${_recipeDetails.title![0].toUpperCase()}${_recipeDetails.title!.substring(1, _recipeDetails.title!.length).toLowerCase()} ',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  flexibleSpace: Opacity(
                    opacity: 0.9,
                    child: _recipe.image,
                  ),
                  expandedHeight: _height / 1.5,
                ),
                SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      const CreatorCard(),
                      const StreamIngredientsBuilder(),
                      if (_recipe.suggestedRecipes.isNotEmpty) ...[
                        ListTile(
                          title: Text(
                            'similarRecipes'.tr(),
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                        SimilarRecipes(
                          suggestedRecipes: _recipe.suggestedRecipes,
                        ),
                      ],
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
