import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/widgets/creator_card.dart';
import 'package:myxmi/widgets/recipe_details.dart';
import 'package:myxmi/widgets/similar_recipes.dart';
import 'package:myxmi/widgets/view_selector_text.dart';
import 'package:sizer/sizer.dart';

final InstructionsModel _instructions =
    InstructionsModel(ingredients: {}, steps: []);
final selectedRecipeView = ChangeNotifierProvider(
  (ref) => SelectedRecipeViewNotifier(),
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
    final ScrollController _ctrl = ScrollController();
    return Consumer(
      builder: (_, watch, __) {
        final _recipe = watch(recipeDetailsProvider);
        return Scaffold(
          body: CustomScrollView(
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
                expandedHeight:
                    kIsWeb ? 80.h : 60.h,
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    const CreatorCard(),
                    SizedBox(
                      height: 85.h,
                      child:
                          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: getPath(_recipe.recipe.recipeId),
                        builder: (context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            debugPrint(
                                '--FIREBASE-- READING: Instructions/${_recipe.recipe.recipeId}');
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('loading'.tr()),
                                const CircularProgressIndicator(),
                              ],
                            );
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
