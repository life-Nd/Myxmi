import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:myxmi/screens/home.dart';
import 'package:myxmi/widgets/recipes_grid.dart';

class RecipesStream extends StatefulWidget {
  final Stream<QuerySnapshot> path;
  const RecipesStream({Key key, this.path}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecipesState();
}

class _RecipesState extends State<RecipesStream> {
  @override
  void initState() {
    super.initState();
  }

  Stream<QuerySnapshot> streamSnap() {
    return FirebaseFirestore.instance
        .collection('Recipes')
        .where('title', isEqualTo: context.read(viewProvider).searchText())
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('building recipe');
    return Consumer(
      builder: (_, watch, __) {
        final _view = watch(viewProvider);
        final _recipe = watch(recipeProvider);
        return StreamBuilder<QuerySnapshot>(
          stream: _view.searchRecipesInDb ? streamSnap() : widget.path,
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text(
                'somethingWentWrong'.tr(),
                style: const TextStyle(color: Colors.white),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              debugPrint('----<<<<<Loading ${_view.view} from db....>>>>>----');
              return Center(
                child: Text(
                  "${'loading'.tr()}...",
                ),
              );
            }
            if (snapshot.data != null) {
              _recipe.recipesList = _recipes(querySnapshot: snapshot.data);
              return RecipesGrid(recipes: _recipe.recipesList);
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.only(bottom: 20.0, left: 40, right: 40.0),
                    child: LinearProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                  ),
                  Text(
                    'noRecipes'.tr(),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}

List<RecipeModel> _recipes({QuerySnapshot querySnapshot}) {
  return querySnapshot.docs.map((QueryDocumentSnapshot data) {
    return RecipeModel.fromSnapshot(
      snapshot: data.data() as Map<String, dynamic>,
      keyIndex: data.id,
    );
  }).toList();
}
