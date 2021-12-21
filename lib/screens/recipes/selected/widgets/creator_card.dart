import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/recipes/list/creator_recipes_view.dart';
import 'package:myxmi/screens/recipes/selected/widgets/recipe_details.dart';
import 'package:myxmi/utils/user_avatar.dart';

final creatorProvider = Provider((ref) => CreatorInfosProvider());

class CreatorCard extends StatefulWidget {
  const CreatorCard({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _CreatorCardState();
}

class _CreatorCardState extends State<CreatorCard> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, __) {
        final _recipeDetails = ref.watch(recipeDetailsProvider).details;
        return InkWell(
          onTap: () {
            debugPrint(_recipeDetails.uid);
            debugPrint(_recipeDetails.username);
            debugPrint(_recipeDetails.userphoto);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CreatorRecipes(
                  uid: _recipeDetails.uid,
                  name: _recipeDetails.username,
                  avatar: _recipeDetails.userphoto,
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
            child: Row(
              children: [
                if (_recipeDetails.userphoto != null)
                  UserAvatar(
                    photoUrl: _recipeDetails.userphoto,
                    radius: 77,
                  )
                else
                  const CircleAvatar(
                    backgroundColor: Colors.red,
                    child: Icon(
                      Icons.person,
                      size: 77,
                    ),
                  ),
                const SizedBox(
                  width: 20,
                ),
                if (_recipeDetails.username != null)
                  Text(_recipeDetails.username!)
                else
                  Text('noName'.tr()),
              ],
            ),
          ),
        );
      },
    );
  }
}

class CreatorInfosProvider {
  String? uid;
  String? name;
  String? avatar;
  CreatorInfosProvider({
    this.uid,
    this.name,
    this.avatar,
  });
}
