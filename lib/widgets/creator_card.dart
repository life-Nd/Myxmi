import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:myxmi/screens/creator_recipes.dart';
import 'package:myxmi/widgets/user_avatar.dart';

class CreatorCard extends StatefulWidget {
  const CreatorCard({Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CreatorCardState();
}

class _CreatorCardState extends State<CreatorCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, __) {
      final _recipe = watch(recipeProvider).recipe;
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
              const Icon(Icons.person),
            const SizedBox(
              width: 20,
            ),
            if (_recipe?.username != null)
              Text(_recipe?.username)
            else
              Text('noName'.tr()),
            // subtitle: Row(
            //   children: [
            //     const Text(
            //       '0 ',
            //       style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            //     ),
            //     Text(
            //       'followers'.tr(),
            //     ),
            //   ],
            // ),
          ]

              // trailing: 'a' == 'a'
              //     ? InkWell(
              //         onTap: () {},
              //         child: Text(
              //           'follow'.tr(),
              //           style: TextStyle(
              //               color: Theme.of(context).scaffoldBackgroundColor,
              //               fontSize: 19,
              //               fontWeight: FontWeight.w400),
              //         ),
              //       )
              //     : InkWell(
              //         onTap: () {},
              //         child: Text(
              //           'following'.tr(),
              //           style: const TextStyle(color: Colors.green),
              //         ),
              //       ),
              ),
        ),
      );
    });
  }
}
