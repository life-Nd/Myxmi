import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/providers/recipe.dart';
import 'package:myxmi/widgets/creator_card.dart';
import 'package:myxmi/widgets/recipe_details.dart';
import 'package:myxmi/widgets/recipe_image.dart';
import 'package:myxmi/widgets/similar_recipes.dart';
import 'add_recipe_infos.dart';

final InstructionsModel _instructions =
    InstructionsModel(ingredients: {}, steps: []);
final selectedRecipeView = ChangeNotifierProvider(
  (ref) => SelectedRecipeViewNotifier(),
);

class SelectedRecipe extends StatefulWidget {
  static const String route = '/recipe';
  const SelectedRecipe({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SelectionRecipeState();
}

class _SelectionRecipeState extends State<SelectedRecipe> {
  Map<String, dynamic> _data = {};
  @override
  Widget build(BuildContext context) {
    final ScrollController _ctrl = ScrollController();
    final Size _size = MediaQuery.of(context).size;
    return Consumer(
      builder: (_, watch, __) {
        final _recipe = watch(recipeProvider);
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
                  child: RecipeImage(
                    height: kIsWeb ? _size.height : _size.height / 2.5,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                ),
                expandedHeight:
                    kIsWeb ? _size.height / 1.3 : _size.height / 2.5,
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    const CreatorCard(),
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection('Instructions')
                          .doc(_recipe.recipe.recipeId)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                              snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          debugPrint('Loading');
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('loading'.tr()),
                              const CircularProgressIndicator(),
                            ],
                          );
                        }
                        if (snapshot.hasData && snapshot.data.data() != null) {
                          final DocumentSnapshot<Map<String, dynamic>>
                              _snapshot = snapshot.data;
                          _data = _snapshot.data();
                          _instructions.fromSnapshot(snapshot: _data);
                        }
                        return RecipeDetails(instructions: _instructions);
                      },
                    ),
                    // AdLoader(),
                    ListTile(
                      title: Text('similarRecipes'.tr(),
                          style: const TextStyle(fontSize: 20)),
                    ),
                    SimilarRecipes(suggestedRecipes: _recipe.suggestedRecipes)
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
