import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/utils/user_avatar.dart';
import 'package:myxmi/views/recipes/creator_recipes_view.dart';
import 'recipe_details.dart';

class CreatorCard extends StatefulWidget {
  const CreatorCard({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CreatorCardState();
}

class _CreatorCardState extends State<CreatorCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, __) {
      final _recipe = watch(recipeDetailsProvider).recipe;
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => CreatorRecipes(
                uid: _recipe.uid,
                name: _recipe?.username,
                avatar: _recipe?.userphoto,
              ),
            ),
          );
        },
        child: Card(
          elevation: 20,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(-20),
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
          ),
          child: Row(children: [
            if (_recipe?.userphoto != null)
              UserAvatar(
                photoUrl: _recipe?.userphoto,
                radius: 77,
              )
            else
              const Icon(Icons.person, size: 35),
            const SizedBox(
              width: 20,
            ),
            if (_recipe?.username != null)
              Text(_recipe?.username)
            else
              Text('noName'.tr()),
          ]),
        ),
      );
    });
  }
}
