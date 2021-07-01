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

  // initState() {
  //   _data = widget.snapshot.docChanges.asMap();
  //   _keys = _data.keys?.toList();
  //   super.initState();
  // }

  // Widget _image(String type) {
  //   switch (type) {
  //     case 'Fruit':
  //       return Image.asset(
  //         'assets/fruits.png',
  //       );
  //     case 'Vegetable':
  //       return Image.asset('assets/vegetables.png');
  //     case 'Meat':
  //       return Image.asset('assets/meat.png');
  //     case 'Seafood':
  //       return Image.asset('assets/seafood.png');
  //     case 'Dairy':
  //       return Image.asset('assets/dairy.png');
  //     case 'Eliquid':
  //       return Image.asset('assets/eliquid.png');
  //     default:
  //       return Image.network(
  //         'assets/$type.png',
  //         fit: BoxFit.fitWidth,
  //       );
  //   }
  // }

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

          print('---INDEXDATA:--${DateTime.now()}- $index $_indexData');
          String _keyIndex = snapshot.docs[index].id;
          _details.fromSnapshot(snapshot: _indexData, keyIndex: _keyIndex);
          return GestureDetector(
            onTap: () {
              print('-----${DateTime.now()}- $index $_indexData');
              print('+++++${DateTime.now()}+ $index $_details');

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
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Hero(
                          tag: '${_indexData['image_url']}',
                          child: FadeInImage.memoryNetwork(
                            image: '${_indexData['image_url']}',
                            fit: BoxFit.fitWidth,
                            imageCacheWidth: 1000,
                            placeholder: kTransparentImage,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7.0, right: 10.0),
                    child: RecipeTile(
                      recipes: _details,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
