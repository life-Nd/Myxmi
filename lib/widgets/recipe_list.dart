import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:flutter/foundation.dart';
import 'add_favorite.dart';
import 'recipe_tile.dart';
import 'recipe_tile_image.dart';

class RecipeList extends StatefulWidget {
  final QuerySnapshot snapshot;
  const RecipeList({@required this.snapshot});
  @override
  State<StatefulWidget> createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  @override
  void initState() {
    _recipes();
    super.initState();
  }

  List<RecipeModel> _recipes() {
    return widget.snapshot.docs.map((QueryDocumentSnapshot data) {
      return RecipeModel.fromSnapshot(
        snapshot: data.data() as Map<String, dynamic>,
        keyIndex: data.id,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return SizedBox(
      height: _size.height / 1,
      width: _size.width / 1,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.6,
          crossAxisCount: kIsWeb ? 4 : 2,
        ),
        padding: const EdgeInsets.all(1),
        itemCount: _recipes().length,
        itemBuilder: (_, int index) {
          final RecipeModel _recipe = _recipes()[index];
          return Consumer(builder: (context, watch, child) {
            return Container(
              margin: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).cardColor,
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: _size.width / 2,
                      child: Stack(
                        children: [
                          Hero(
                            tag: _recipe.recipeId,
                            child: RecipeTileImage(
                              recipe: _recipe,
                            ),
                          ),
                          AddFavoriteButton(
                            recipe: _recipe,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 7.0,
                      right: 10.0,
                    ),
                    child: RecipeTile(
                      type: 'All',
                      recipe: _recipe,
                    ),
                  )
                ],
              ),
            );
          });
        },
      ),
    );
  }
}
