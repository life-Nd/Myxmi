import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'recipes_view.dart';

class RecipesBySearch extends StatelessWidget {
  final Stream<QuerySnapshot> path;
  final bool autoCompleteField;
  const RecipesBySearch(
      {Key key, @required this.path, @required this.autoCompleteField})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<RecipeModel> _recipes({QuerySnapshot querySnapshot}) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.map((QueryDocumentSnapshot data) {
          return RecipeModel.fromSnapshot(
            snapshot: data.data() as Map<String, dynamic>,
            keyIndex: data.id,
          );
        }).toList();
      } else {
        return [];
      }
    }

    return Consumer(
      builder: (_, watch, __) {
        final _recipe = watch(recipeProvider);
        return StreamBuilder<QuerySnapshot>(
          stream: path,
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text(
                'somethingWentWrong'.tr(),
                style: const TextStyle(color: Colors.white),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text(
                  "${'loading'.tr()}...",
                ),
              );
            }
            if (snapshot.data != null) {
              _recipe.recipesList = _recipes(querySnapshot: snapshot.data);
              return RecipesView(
                showAutoCompleteField: autoCompleteField,
                myRecipes: _recipes(querySnapshot: snapshot.data),
              );
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