import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/providers/home_view.dart';
import 'package:myxmi/widgets/app_bottom_navigation.dart';
import 'package:myxmi/widgets/search.dart';
import 'package:myxmi/widgets/web_appbar.dart';
import 'package:sizer/sizer.dart';
import '../recipes_compiled.dart';
import 'add_product.dart';
import 'add_recipe_infos.dart';

// ADDRECIPE <a href="https://storyset.com/work">Work illustrations by Storyset</a>
// APPETIZERS https://unsplash.com/photos/n9xsu46NGaE?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// BASE
// BREAKFAST https://unsplash.com/photos/SQ20tWzxXO0?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// COCKTAIL https://unsplash.com/photos/J5wrhsSPN9o?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// DAIRY
// DATA_NOT_FOUND // <a href="https://storyset.com/work">Work illustrations by Storyset</a>
// DESSERT https://unsplash.com/photos/6iqpLKqeaE0?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// DINNER https://unsplash.com/photos/zzxqoEa64_0?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// ALL DIETS https://unsplash.com/photos/NPBnWE1o07I
// DRINKS https://unsplash.com/photos/LbUzPqxPUAs?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// ELIQUID
// FOODS ---
// FRUIT
// KETO https://unsplash.com/photos/auIbTAcSH6E?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// MEAT
// SALAD https://unsplash.com/photos/AiHJiRCwB3w?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// SAUCES&SPICES <a href='https://www.freepik.com/photos/background'>Background photo created by KamranAydinov - www.freepik.com</a>
// SEAFOOD
// SHAKE https://unsplash.com/photos/4FujjkcI40g?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// SHAKE2 https://unsplash.com/photos/KlVIYmGVRQ8?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// SMOOTHIE https://unsplash.com/photos/5HNB4MqxkIM?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// SOUP https://unsplash.com/photos/8mVLMZ0WW98?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// VEGAN https://unsplash.com/photos/zOlQ7lF-3vs?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// VEGAN2 https://unsplash.com/photos/-ftWfohtjNw?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// VEGETERIAN https://unsplash.com/photos/IGfIGP5ONV0?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink
// VEGETARIAN2 https://unsplash.com/photos/nou2DipA4uM?utm_source=unsplash&utm_medium=referral&utm_content=creditShareLink

final homeViewProvider = ChangeNotifierProvider<HomeViewProvider>(
  (ref) => HomeViewProvider(),
);
int _saved = 0;
int _total = 0;

class Home extends StatelessWidget {
  final String uid;
  final String photoUrl;
  const Home({Key key, @required this.uid, @required this.photoUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final RecipesCompiled _compiled = RecipesCompiled();
    final RecipeModel _recipe = RecipeModel();
    final InstructionsModel _instructions =
        InstructionsModel(ingredients: {}, steps: []);
    return Consumer(
      builder: (_, watch, __) {
        final _view = watch(homeViewProvider);
        // debugPrint('kIsWeb: $kIsWeb');
        // debugPrint('_size.width > 500: ${_size.width > 500}');
        // debugPrint(
        //     'kIsWeb && _size.width > 500: ${kIsWeb && _size.width > 500}');
        // debugPrint('_view.view == 0: ${_view.view == 0}');
        final int _viewIndex = _view.view;
        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: PreferredSize(
            preferredSize: kIsWeb && 100.w > 500
                ? _view.view == 0
                    ? Size(100.w, 10.h)
                    : Size(100.w, 6.h)
                : Size(100.w, 10.h),
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.only(top: 7, left: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (kIsWeb && 100.w > 500)
                      Expanded(child: WebAppBar(uid: uid)),
                    if (_view.view == 0) Expanded(child: SearchRecipes()),
                    if (_view.view == 4)
                      kIsWeb
                          ? Container()
                          : const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Myxmi',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w700),
                              ),
                            ),
                  ],
                ),
              ),
            ),
          ),
          // TODO fix error with INSTRUCTIONS > ingredients
          // bottomSheet: StatefulBuilder(builder: (_, StateSetter stateSetter) {
          //   return Column(
          //     children: [
          //       RawMaterialButton(
          //         onPressed: () async {
          //           String _key;
          //           for (final recipe in _compiled.recipes) {
          //             final List _steps = recipe['steps'] as List;
          //             final List _ingredients = recipe['ingredients'] as List;
          //             final int _stepsCount = _steps.length;
          //             final int _ingredientsCount = _ingredients.length;
          //             final String _imageUrl = recipe['image'] != null
          //                 ? recipe['image'] as String
          //                 : null;
          //             final String _difficulty = _stepsCount > 10
          //                 ? 'difficult'
          //                 : _stepsCount > 4
          //                     ? 'medium'
          //                     : 'easy';
          //             final int _duration = _stepsCount > 10
          //                 ? 60
          //                 : _stepsCount > 4
          //                     ? 40
          //                     : 15;
          //             debugPrint('uid: $uid');

          //             _recipe.access = 'public';
          //             _recipe.category = 'food';
          //             _recipe.difficulty = _difficulty;
          //             _recipe.duration = '$_duration';
          //             _recipe.imageUrl = _imageUrl;
          //             _recipe.ingredientsCount = '$_ingredientsCount';
          //             _recipe.likedBy = {};
          //             _recipe.made = '';
          //             _recipe.photoUrl = photoUrl;
          //             _recipe.portions = '';
          //             _recipe.reviewsCount = null;
          //             _recipe.stars = null;
          //             _recipe.stepsCount = '$_stepsCount';
          //             _recipe.subCategory = '';
          //             _recipe.title = recipe['title'] as String;
          //             _recipe.uid = uid;
          //             _recipe.reference = recipe['url'] as String;
          //             _recipe.usedCount = '1';
          //             _recipe.username = 'Lifen';
          //             _recipe.tags = recipe['tags'] != null
          //                 ? recipe['tags'] as List
          //                 : null;
          //             for (final element in _ingredients) {
          //               _instructions.ingredients[
          //                   '${_ingredients.indexOf(element)}'] = '$element';
          //             }
          //             _instructions.steps = _steps;
          //             _instructions.uid = uid;
          //             _recipe.made = '${DateTime.now().millisecondsSinceEpoch}';
          //             final DocumentReference _db = await FirebaseFirestore
          //                 .instance
          //                 .collection('Recipes')
          //                 .add(_recipe.toMap());
          //             _key = _db.id;
          //             debugPrint(
          //                 'Instructions: ${_instructions.ingredients} \n ${_instructions.steps} ');
          //             await FirebaseFirestore.instance
          //                 .collection('Instructions')
          //                 .doc(_key)
          //                 .set(_instructions.toMap());
          //             stateSetter(() {
          //               _saved++;
          //             });
          //           }
          //         },
          //         fillColor: Colors.green,
          //         child: const Text('Save to Firestore'),
          //       ),
          //       ListTile(
          //         title: Text('$_saved/$_total saved'),
          //       )
          //     ],
          //   );
          // }),
          floatingActionButton: _viewIndex == 0 ||
                  _viewIndex == 1 && uid != null ||
                  _viewIndex == 3 && uid != null
              ? uid != null
                  ? FloatingActionButton(
                      backgroundColor: Colors.green.shade400,
                      onPressed: () {
                        _viewIndex != 3
                            ? Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AddRecipeInfos(),
                                ),
                              )
                            : Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => AddProduct(),
                                ),
                              );
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    )
                  : FloatingActionButton(
                      backgroundColor: Colors.red,
                      onPressed: () {
                        _view.changeViewIndex(index: 4, uid: uid);
                      },
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    )
              : null,
          body: _view.viewBuilder(uid: uid),
          extendBody: true,
          // ignore: avoid_redundant_argument_values
          bottomNavigationBar:
              kIsWeb && 100.w > 500 ? null : AppBottomNavigation(),
        );
      },
    );
  }
}
