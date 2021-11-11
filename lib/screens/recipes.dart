import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'recipes_view.dart';

class Recipes extends StatelessWidget {
  final Stream<QuerySnapshot> path;
  final bool showAutoCompleteField;
  final String searchFieldLabel;
  const Recipes({
    Key key,
    @required this.path,
    @required this.showAutoCompleteField,
    @required this.searchFieldLabel,
  }) : super(key: key);

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

    return Consumer(builder: (_, watch, child) {
      return StreamBuilder<QuerySnapshot>(
        stream: path,
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Container(
              alignment: Alignment.center,
              child: Text(
                'somethingWentWrong'.tr(),
                style: const TextStyle(),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('--FIREBASE-- Reading: Recipes/$searchFieldLabel ');
            return Container(
              alignment: Alignment.center,
              child: Text(
                "${'loading'.tr()}...",
              ),
            );
          }
          if (snapshot.data != null) {
            return RecipesView(
              showAutoCompleteField: showAutoCompleteField,
              recipesList: _recipes(querySnapshot: snapshot.data),
            );
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 20.0, left: 40, right: 40.0),
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
    });
  }
}
