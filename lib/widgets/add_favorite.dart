import 'package:universal_io/io.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/screens/home.dart';
import '../main.dart';

class AddFavoriteButton extends HookWidget {
  final RecipesModel recipe;
  const AddFavoriteButton({@required this.recipe});

  @override
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final _view = useProvider(viewProvider);
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
          (!recipe.liked)
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
                    // Like recipe and save it to DB
                    FirebaseFirestore.instance
                        .collection('Recipes')
                        .doc(recipe.recipeId)
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
                    // Unlike this recipe and delete it from DB
                    FirebaseFirestore.instance
                        .collection('Recipes')
                        .doc(recipe.recipeId)
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
