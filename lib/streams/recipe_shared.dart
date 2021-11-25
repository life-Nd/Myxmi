import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'recipes.dart';

class RecipeSharedPage extends Page {
  final String recipeId;

  RecipeSharedPage({
    this.recipeId,
  }) : super(key: ValueKey(recipeId));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
        settings: this, builder: (_) => const RecipeSharedBuilder());
  }
}

class RecipeSharedBuilder extends StatelessWidget {
  final String recipeId;

  const RecipeSharedBuilder({Key key, this.recipeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('recipeShared'.tr()),
      ),
      body: RecipesStreamBuilder(
        searchFieldLabel: 'recipeId',
        showAutoCompleteField: true,
        snapshots: FirebaseFirestore.instance
            .collection('Recipes')
            .where('reference', isEqualTo: '52794')
            .snapshots(),
      ),
    );
  }
}
