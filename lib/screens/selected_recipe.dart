import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:myxmi/widgets/recipe_details.dart';
import 'package:myxmi/widgets/recipe_image.dart';
import 'package:myxmi/widgets/view_selector_text.dart';

class SelectedRecipe extends StatefulWidget {
  final String recipeId;
  const SelectedRecipe({Key key, this.recipeId}) : super(key: key);
  @override
  State createState() => SelectedRecipeState();
}

class SelectedRecipeState extends State<SelectedRecipe> {
  final InstructionsModel _instructions = InstructionsModel();
  DocumentSnapshot _snapshot;
  @override
  void initState() {
    final _db = FirebaseFirestore.instance
        .collection('Instructions')
        .doc(widget.recipeId);
    _db.get().then((value) => _snapshot = value);
    if (_snapshot?.data() != null) {
      _instructions.fromSnapshot(
          snapshot: _snapshot.data() as Map<String, dynamic>);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    debugPrint('SelectedRecipe building');
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, watch, child) {
          final _recipe = watch(recipeProvider);
          return Text(_recipe.recipeModel.title);
        }),
      ),
      body: Container(
        height: _size.height,
        width: _size.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).cardColor,
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RecipeImage(_size.height / 2),
            Column(
              children: [
                _ViewsSelector(),
                SizedBox(
                  height: _size.height / 1.9,
                  child: RecipeDetails(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewsSelector extends StatelessWidget {
  final InstructionsModel _instructions = InstructionsModel();
  @override
  Widget build(BuildContext context) {
    debugPrint('View selector building');
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ViewSelectorText(
          length: _instructions?.ingredients?.length ?? 0,
          viewIndex: 0,
          text: 'ingredients',
        ),
        ViewSelectorText(
          length: _instructions?.steps?.length ?? 0,
          viewIndex: 1,
          text: 'steps',
        ),
        ViewSelectorText(
          length: _instructions?.reviews?.length ?? 0,
          text: 'reviews',
          viewIndex: 2,
        ),
      ],
    );
  }
}
