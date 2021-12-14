import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/recipes/selected/widgets/recipe_details.dart';
import 'package:myxmi/utils/loading_column.dart';

class StreamIngredientsBuilder extends StatelessWidget {
  const StreamIngredientsBuilder({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _recipe = ref.watch(recipeDetailsProvider);
        final _recipeDetails = _recipe.details;
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Instructions')
              .doc(_recipeDetails.recipeId)
              .snapshots(),
          builder: (
            context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              debugPrint(
                '--FIREBASE-- READING: Instructions/${_recipeDetails.recipeId}',
              );
              return const SizedBox(
                height: 300,
                child: LoadingColumn(),
              );
            }
            if (snapshot.hasData && snapshot.data!.data() != null) {
              Map<String, dynamic>? _data = {};
              final DocumentSnapshot<Map<String, dynamic>> _snapshot =
                  snapshot.data!;
              _data = _snapshot.data();
              return RecipeDetails(
                ingredients: _data!['ingredients'] as Map<String, dynamic>,
                comments: _data['comments'] as Map<String, dynamic>,
              );
            }
            return const SizedBox(
              height: double.infinity,
              child: LoadingColumn(),
            );
          },
        );
      },
    );
  }
}
