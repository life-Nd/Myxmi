import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:myxmi/screens/home.dart';
import 'package:myxmi/screens/selected_recipe.dart';
import '../app.dart';
import '../main.dart';
import 'add_reviews.dart';

class AddToFavoriteButton extends HookWidget {
  final RecipeModel recipe;

  const AddToFavoriteButton({@required this.recipe});

  @override
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final _fav = useProvider(favProvider);
    final _view = useProvider(viewProvider);
    final _change = useState<bool>(false);
    debugPrint('recipe.stars: ${recipe.stars}');


    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (_user.account?.uid == null)
              IconButton(
                icon: const Icon(
                  Icons.favorite_border,
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
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.red,
                        size: 40,
                      ),
                      onPressed: () {
                        debugPrint('DETAILS ${recipe.recipeId}');
                        final Map<String, dynamic> _data = {};
                        debugPrint('DETAILS: ${recipe.recipeId}');
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
                        _fav.addFavorites(newFavorite: _data);
                        _change.value = !_change.value;
                      },
                    )
                  : IconButton(
                      icon: const Icon(
                        Icons.favorite_outlined,
                        size: 40,
                        color: Colors.red,
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
              icon: Icon(
                Platform.isIOS
                    ? Icons.ios_share_outlined
                    : Icons.share_outlined,
              ),
              onPressed: () {},
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => AddReviews(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: RatingStars(
              stars: recipe.stars ?? '0.0',
            ),
          ),
        ),
      ],
    );
  }
}
