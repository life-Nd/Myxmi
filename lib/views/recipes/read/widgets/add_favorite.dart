import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/views/home/home_view.dart';
import '../../../../main.dart';

class AddFavoriteButton extends StatefulWidget {
  final RecipeModel recipe;

  const AddFavoriteButton({
    Key key,
    @required this.recipe,
  }) : super(key: key);

  @override
  State<AddFavoriteButton> createState() => _AddFavoriteButtonState();
}

// TODO Use notifyListeners() instead of setState()
class _AddFavoriteButtonState extends State<AddFavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, __) {
        final _user = watch(userProvider);
        final _view = watch(homeViewProvider);
        final _recipe = widget.recipe;
        if (_user?.account?.uid != null && _recipe?.likes != null) {
          final _uid = _user?.account?.uid;
          _recipe.isLiked =
              _recipe.likes.containsKey(_uid) && _recipe.likes[_uid] == true;
        }
        return StatefulBuilder(
          builder: (context, StateSetter stateSetter) {
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
                  (!_recipe.isLiked)
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
                            // Like recipe and save it to DB

                            FirebaseFirestore.instance
                                .collection('Recipes')
                                .doc(widget.recipe.recipeId)
                                .set(
                              {
                                'likes': {
                                  _user.account.uid: true,
                                }
                              },
                              SetOptions(
                                merge: true,
                              ),
                            );
                            debugPrint(
                                '--FIREBASE-- Writing: Recipes/${widget.recipe.recipeId}.likes: ${_user.account.uid}: false,  ');
                            if (widget.recipe.likes != {} ||
                                widget.recipe.likes.isEmpty) {
                              widget.recipe.likes = {};
                            }
                            widget.recipe.likes[_user.account.uid] = true;
                            setState(() {});
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
                            debugPrint('Unlike tapped');
                            FirebaseFirestore.instance
                                .collection('Recipes')
                                .doc(widget.recipe.recipeId)
                                .set(
                              {
                                'likes': {
                                  _user.account.uid: false,
                                },
                              },
                              SetOptions(
                                merge: true,
                              ),
                            );
                            debugPrint(
                                '--FIREBASE-- Writing: Recipes/${widget.recipe.recipeId}.likes: ${_user.account.uid}: false,  ');
                            widget.recipe.likes[_user.account.uid] = false;
                            setState(() {});
                          },
                        ),
                // IconButton(
                //   icon: Container(
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(20),
                //       color: Colors.white,
                //     ),
                //     padding: const EdgeInsets.all(4),
                //     child: Icon(
                //         Platform.isIOS
                //             ? Icons.ios_share_outlined
                //             : Icons.share_outlined,
                //         color: Colors.black),
                //   ),
                //   onPressed: () {},
                // ),
              ],
            );
          },
        );
      },
    );
  }
}
