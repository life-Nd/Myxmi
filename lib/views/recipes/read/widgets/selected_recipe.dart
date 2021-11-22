import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/utils/loading_column.dart';

import 'add_favorite.dart';
import 'creator_card.dart';
import 'recipe_details.dart';
import 'similar_recipes.dart';

final InstructionsModel _instructions =
    InstructionsModel(ingredients: {}, steps: []);
final selectedRecipeView = ChangeNotifierProvider(
  (ref) => _SelectedRecipeViewNotifier(),
);

class SelectedRecipe extends StatefulWidget {
  const SelectedRecipe({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SelectionRecipeState();
}

class _SelectionRecipeState extends State<SelectedRecipe> {
  Map<String, dynamic> _data = {};
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
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
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            padding: const EdgeInsets.all(0),
                            duration: const Duration(seconds: 100),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)),
                            ),
                            content: Container(
                              width: _size.width,
                              height: 100,
                              color: Colors.red,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: const [
                                      Text('Add it to your calendar'),
                                    ],
                                  ),
                                  IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .hideCurrentSnackBar();
                                      })
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    AddFavoriteButton(recipe: _recipe.recipe),
                    IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {},
                    ),
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
                  title: Consumer(
                    builder: (context, watch, child) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          '${_recipe.recipe.title[0].toUpperCase()}${_recipe.recipe.title.substring(1, _recipe.recipe.title.length).toLowerCase()} ',
                          style: const TextStyle(
                              fontSize: 19, fontWeight: FontWeight.w700),
                        ),
                      );
                    },
                  ),
                  flexibleSpace: Opacity(
                    opacity: 0.9,
                    child: _recipe.image,
                  ),
                  expandedHeight: kIsWeb ? _height * 0.6 : _height * 0.5,
                ),
                SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      const CreatorCard(),
                      SizedBox(
                        height: _height * 0.80,
                        child: StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: getPath(_recipe.recipe.recipeId),
                          builder: (context,
                              AsyncSnapshot<
                                      DocumentSnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              debugPrint(
                                  '--FIREBASE-- READING: Instructions/${_recipe.recipe.recipeId}');
                              return const LoadingColumn();
                            }
                            if (snapshot.hasData &&
                                snapshot.data.data() != null) {
                              final DocumentSnapshot<Map<String, dynamic>>
                                  _snapshot = snapshot.data;
                              _data = _snapshot.data();
                              _instructions.fromSnapshot(snapshot: _data);
                            }
                            return RecipeDetails(instructions: _instructions);
                          },
                        ),
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

  Stream<DocumentSnapshot<Map<String, dynamic>>> getPath(String recipeId) {
    return FirebaseFirestore.instance
        .collection('Instructions')
        .doc(recipeId)
        .snapshots();
  }
}

class _SelectedRecipeViewNotifier extends ChangeNotifier {
  int pageIndex = 0;
  void changeIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }
}
