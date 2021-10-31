import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/widgets/user_avatar.dart';
import 'package:sizer/sizer.dart';
import 'recipes.dart';

class CreatorRecipes extends StatelessWidget {
  final String uid;
  final String name;
  final String avatar;

  const CreatorRecipes({
    Key key,
    @required this.uid,
    @required this.name,
    @required this.avatar,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100.w, 114),
        child: SafeArea(
          child: Row(
            children: [
              if (avatar != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    UserAvatar(
                      radius: 77,
                      photoUrl: avatar,
                    ),
                  ],
                )
              else
                const Icon(Icons.person),
              const SizedBox(
                width: 20,
              ),
              if (name != null)
                Text('$name recipes')
              else
                Text('${'noName'.tr()} recipes'),
              // subtitle: Text('$followersCount ${'followers'.tr()}'),
            ],
          ),
        ),
      ),
      body: Recipes(
        showAutoCompleteField: true,
        // recipesPath: RECIPESBY.creatorUid,
        path: FirebaseFirestore.instance
            .collection('Recipes')
            .where('uid', isEqualTo: uid)
            .snapshots(),
      ),
    );
  }
}
