import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'recipes_view.dart';

// enum RECIPESBY {
//   like,
//   creatorUid,
//   searchText,
//   category,
//   subCategory,
//   timeStamp
// }

class Recipes extends StatelessWidget {
  final Stream<QuerySnapshot> path;
  final bool showAutoCompleteField;
  // final RECIPESBY recipesPath;
  const Recipes({
    Key key,
    @required this.path,
    @required this.showAutoCompleteField,
  }) : super(key: key);

  // Stream<QuerySnapshot> _path(String _uid, String searchText) {
  //   Stream<QuerySnapshot> _recipesPath;
  //   switch (recipesPath) {
  //     case RECIPESBY.like:
  //       return _recipesPath = FirebaseFirestore.instance
  //           .collection('Recipes')
  //           .where('likedBy.$_uid', isEqualTo: true)
  //           .snapshots();
  //     case RECIPESBY.creatorUid:
  //       return _recipesPath = FirebaseFirestore.instance
  //           .collection('Recipes')
  //           .where('uid', isEqualTo: _uid)
  //           .snapshots();
  //     case RECIPESBY.searchText:
  //       return _recipesPath = FirebaseFirestore.instance
  //           .collection('Recipes')
  //           .where('title', isEqualTo: searchText)
  //           .snapshots();

  //     case RECIPESBY.timeStamp:
  //       return _recipesPath = FirebaseFirestore.instance
  //           .collection('Recipes')
  //           .orderBy('made')
  //           .snapshots();
  //     case RECIPESBY.category:
  //       return _recipesPath = FirebaseFirestore.instance
  //           .collection('Recipes')
  //           .where('category', isEqualTo: searchText)
  //           .snapshots();
  //     case RECIPESBY.subCategory:
  //       return _recipesPath = FirebaseFirestore.instance
  //           .collection('Recipes')
  //           .where('subcategory', isEqualTo: searchText)
  //           .snapshots();
  //     default:
  //       return _recipesPath;
  //   }
  // }

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
            return Text(
              'somethingWentWrong'.tr(),
              style: const TextStyle(),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
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
