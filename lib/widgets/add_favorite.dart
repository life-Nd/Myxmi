import 'package:universal_io/io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:myxmi/screens/home.dart';
import '../app.dart';
import '../main.dart';

class AddFavoriteButton extends HookWidget {
  final RecipeModel recipe;
  const AddFavoriteButton({@required this.recipe});

  @override
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final _fav = useProvider(favProvider);
    final _view = useProvider(viewProvider);
    final _change = useState<bool>(false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (_user.account?.uid == null)
          IconButton(
            icon: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(4),
              child: const Icon(Icons.favorite_border, color: Colors.black),
            ),
            onPressed: () {
              _view.view = 2;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => Home(),
                ),
              );
            },
          )
        else
          !_fav.allRecipes.keys.contains(recipe.recipeId)
              ? IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    final Map<String, dynamic> _data = {};
                    _data[recipe.recipeId] = {
                      'title': recipe.title,
                      'image_url': recipe.imageUrl,
                      'joined': 'false',
                      'steps_count': recipe.stepsCount,
                      'ingredients_count': recipe.ingredientsCount
                    };
                    FirebaseFirestore.instance
                        .collection('Favorites')
                        .doc(_user.account.uid)
                        .set(_data, SetOptions(merge: true));
                    _fav.addFavorite(newFavorite: _data);
                    _change.value = !_change.value;
                  },
                )
              : IconButton(
                  icon: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.favorite_outlined,
                      color: Colors.red,
                    ),
                  ),
                  onPressed: () {
                    FirebaseFirestore.instance
                        .collection('Favorites')
                        .doc(_user.account.uid)
                        .update({recipe.recipeId: FieldValue.delete()});
                    _fav.removeFavorite(newFavorite: recipe.recipeId);
                    _change.value = !_change.value;
                  },
                ),
        IconButton(
          icon: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(4),
            child: Icon(
                Platform.isIOS
                    ? Icons.ios_share_outlined
                    : Icons.share_outlined,
                color: Colors.black),
          ),
          onPressed: () {},
        ),
      ],
    );
  }
}
