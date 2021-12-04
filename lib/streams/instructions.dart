import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/utils/loading_column.dart';
import 'package:myxmi/views/selectedRecipe/widgets/recipe_details.dart';

class StreamInstructionsBuilder extends StatelessWidget {
  const StreamInstructionsBuilder({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, child) {
        final _recipe = watch(recipeDetailsProvider);
        final _recipeDetails = _recipe.details;
        return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection('Instructions')
              .doc(_recipeDetails.recipeId)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              debugPrint(
                  '--FIREBASE-- READING: Instructions/${_recipeDetails.recipeId}');
              return const LoadingColumn();
            }
            if (snapshot.hasData && snapshot.data.data() != null) {
              Map<String, dynamic> _data = {};
              final DocumentSnapshot<Map<String, dynamic>> _snapshot =
                  snapshot.data;
              _data = _snapshot.data();
              debugPrint('_data12:$_data');
              final InstructionsModel _instructions =
                  InstructionsModel.fromSnapshot(snapshot: _data);
              return RecipeDetails(instructions: _instructions);
            }
            return const LoadingColumn();
          },
        );
      },
    );
  }
}
