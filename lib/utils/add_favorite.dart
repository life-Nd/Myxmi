import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:myxmi/providers/home_screen.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/providers/user.dart';

class AddFavoriteButton extends StatefulWidget {
  final RecipeModel recipe;

  const AddFavoriteButton({
    Key? key,
    required this.recipe,
  }) : super(key: key);

  @override
  State<AddFavoriteButton> createState() => _AddFavoriteButtonState();
}

class _AddFavoriteButtonState extends State<AddFavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        final _user = ref.watch(userProvider);
        final _view = ref.watch(homeScreenProvider);
        final _router = ref.watch(routerProvider);
        final _recipe = widget.recipe;
        if (_user.account?.uid != null && _recipe.likes != null) {
          final _uid = _user.account?.uid;
          _recipe.isLiked =
              _recipe.likes!.containsKey(_uid) && _recipe.likes![_uid] == true;
        }
        final bool _isLiked = _recipe.isLiked ?? false;
        return StatefulBuilder(
          builder: (context, StateSetter stateSetter) {
            if (_user.account?.uid == null) {
              return InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.black,
                    size: 25,
                  ),
                ),
                onTap: () {
                  // if the user not signed-in send him to sign-in page
                  _view.changeView(index: 5);
                  _router.pushPage(name: '/home');
                },
              );
            } else if (!_isLiked) {
              return IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.favorite_border,
                    color: Colors.red,
                    size: 25,
                  ),
                ),
                onPressed: () {
                  debugPrint('Like tapped');
                  // Like recipe and save it to DB

                  FirebaseFirestore.instance
                      .collection('Recipes')
                      .doc(widget.recipe.recipeId)
                      .set(
                    {
                      'likes': {
                        _user.account!.uid: true,
                      }
                    },
                    SetOptions(
                      merge: true,
                    ),
                  );
                  debugPrint(
                    '--FIREBASE-- Writing: Recipes/${widget.recipe.recipeId}.likes: ${_user.account!.uid}: false,  ',
                  );
                  if (widget.recipe.likes != {} ||
                      widget.recipe.likes!.isEmpty) {
                    widget.recipe.likes = {};
                  }
                  widget.recipe.likes![_user.account!.uid] = true;
                  setState(
                    () {},
                  );
                },
              );
            } else {
              return IconButton(
                icon: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.favorite_outlined,
                    color: Colors.red,
                    size: 25,
                  ),
                ),
                onPressed: () {
                  // Unlike this recipe and delete it from DB
                  debugPrint('Unlike tapped');
                  FirebaseFirestore.instance
                      .collection('Recipes')
                      .doc(widget.recipe.recipeId)
                      .set(
                    {
                      'likes': {
                        _user.account!.uid: false,
                      },
                    },
                    SetOptions(
                      merge: true,
                    ),
                  );
                  debugPrint(
                    '--FIREBASE-- Writing: Recipes/${widget.recipe.recipeId}.likes: ${_user.account!.uid}: false,  ',
                  );
                  widget.recipe.likes![_user.account!.uid] = false;
                  setState(
                    () {},
                  );
                },
              );
            }
          },
        );
      },
    );
  }
}
