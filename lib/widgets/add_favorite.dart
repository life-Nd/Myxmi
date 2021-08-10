import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:universal_io/io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/home.dart';
import '../main.dart';

class AddFavoriteButton extends StatefulWidget {
  final RecipesModel recipe;
  const AddFavoriteButton({this.recipe});
  @override
  State<AddFavoriteButton> createState() => _AddFavoriteButtonState();
}

class _AddFavoriteButtonState extends State<AddFavoriteButton> {
  @override
  Widget build(BuildContext context) {
    debugPrint('building addFavoriteButton');
    return Consumer(builder: (_, watch, __) {
      final _user = watch(userProvider);
      final _recipeProvider = watch(recipeProvider);
      final _view = watch(viewProvider);
      bool _liked = false;
      if (_user?.account?.uid != null &&
          _recipeProvider.recipesModel.likedBy != null) {
        final _uid = _user?.account?.uid;
        _liked = _recipeProvider.recipesModel.likedBy
                .containsKey(_user.account.uid) &&
            _recipeProvider.recipesModel.likedBy[_uid] == true;
      }
      return StatefulBuilder(builder: (context, StateSetter stateSetter) {
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
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {
                  // if the user not signed-in send him to sign-in page
                  _view.view = 4;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => Home(),
                    ),
                  );
                },
              )
            else
              (!_liked)
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
                        debugPrint('Like tapped');
                        debugPrint(
                            'RecipeID: ${_recipeProvider.recipesModel.recipeId}: ${_recipeProvider.recipesModel.liked}');
                        // Like recipe and save it to DB
                        _liked = true;
                        FirebaseFirestore.instance
                            .collection('Recipes')
                            .doc(_recipeProvider.recipesModel.recipeId)
                            .set(
                          {
                            'likedBy': {
                              _user.account.uid: true,
                            }
                          },
                          SetOptions(
                            merge: true,
                          ),
                        );
                        debugPrint(
                            'RecipeID: ${_recipeProvider.recipesModel.recipeId}: ${_recipeProvider.recipesModel.liked}');
                      },
                    )
                  // TODO tapping like/unlike on the selected recipe page doesnt update the icon
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
                        // Unlike this recipe and delete it from DB
                        debugPrint(
                            'RecipeID: ${_recipeProvider.recipesModel.recipeId}: ${_recipeProvider.recipesModel.liked}');
                        debugPrint('Unlike tapped');
                        _liked = false;
                        FirebaseFirestore.instance
                            .collection('Recipes')
                            .doc(_recipeProvider.recipesModel.recipeId)
                            .set(
                          {
                            'likedBy': {
                              _user.account.uid: false,
                            },
                          },
                          SetOptions(
                            merge: true,
                          ),
                        );
                        debugPrint(
                            'RecipeID: ${_recipeProvider.recipesModel.recipeId}: ${_recipeProvider.recipesModel.liked}');
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
      });
    });
  }
}
