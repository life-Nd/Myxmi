import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:myxmi/screens/selected_recipe.dart';
import 'recipe_tile.dart';
import 'package:transparent_image/transparent_image.dart';

class RecipeList extends HookWidget {
  final QuerySnapshot snapshot;

  RecipeList({@required this.snapshot});

  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    Map _data;
    List _keys = [];
    final Size _size = MediaQuery.of(context).size;
    _data = snapshot.docs.asMap();
    _keys = _data.keys?.toList();

    return Container(
      height: _size.height / 1,
      width: _size.width / 1,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 0.6,
          crossAxisCount: 2,
        ),
        padding: EdgeInsets.all(1),
        itemCount: _keys.length,
        itemBuilder: (_, int index) {
          final RecipesModel _details = RecipesModel();
          Map _indexData = snapshot.docs[index].data();
          String _keyIndex = snapshot.docs[index].id;
          _details.fromSnapshot(snapshot: _indexData, keyIndex: _keyIndex);
          return GestureDetector(
            onTap: () {
              _recipe.details.fromSnapshot(
                keyIndex: _keyIndex,
                snapshot: _indexData,
              );
              _recipe.image = FadeInImage.memoryNetwork(
                image: '${_indexData['image_url']}',
                fit: BoxFit.fitWidth,
                imageCacheWidth: 1000,
                placeholder: kTransparentImage,
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => SelectedRecipe(),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
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
                    child: Container(
                      width: _size.width / 2,
                      child: Stack(
                        children: [
                          RecipeTileImage(
                            keyIndex: _keyIndex,
                            details: _details,
                          ),
                          AddToFavoriteButton(
                            details: _details,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0, right: 10.0),
                    child: RecipeTile(
                      type: 'All',
                      recipes: _details,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RecipeTileImage extends StatelessWidget {
  const RecipeTileImage({
    Key key,
    @required String keyIndex,
    @required this.details,
  })  : _keyIndex = keyIndex,
        super(key: key);

  final String _keyIndex;
  final RecipesModel details;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: Hero(
        tag: '$_keyIndex',
        child: details.imageUrl != null && details.imageUrl != ''
            ? FadeInImage.memoryNetwork(
                image: '${details.imageUrl}',
                fit: BoxFit.fitWidth,
                imageCacheWidth: 1000,
                placeholder: kTransparentImage,
              )
            : Image.asset(
                'assets/${details.subCategory}.jpg',
                fit: BoxFit.fitHeight,
                height: _size.height,
                cacheHeight: 1000,
                color: Colors.grey.shade500,
                colorBlendMode: BlendMode.color,
              ),
      ),
    );
  }
}
