import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe.dart';
import 'package:myxmi/screens/selected_recipe.dart';
import 'recipe_tile.dart';

class RecipeList extends StatefulWidget {
  final QuerySnapshot snapshot;
  const RecipeList({@required this.snapshot});
  createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  Map _data;
  List _keys = [];
  initState() {
    _data = widget.snapshot.docChanges.asMap();
    _keys = _data.keys?.toList();
    super.initState();
  }

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
    final Size _size = MediaQuery.of(context).size;
    return Consumer(builder: (context, watch, child) {
      final _recipe = watch(recipeProvider);
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
            Map _indexData = widget.snapshot.docs[index].data();
            _recipe.details.fromSnapshot(
                snapshot: _indexData, keyIndex: widget.snapshot.docs[index].id);
            print("$index: $_indexData");
            return GestureDetector(
              onTap: () {
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
                      Colors.grey.shade100,
                    ],
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: _size.height / 3,
                      width: _size.width / 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        child: Image.network(
                          '${_indexData['image_url']}',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    RecipeTile(
                      indexData: _indexData,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
