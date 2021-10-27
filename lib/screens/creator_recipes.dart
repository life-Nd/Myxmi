import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'recipes.dart';

class CreatorRecipes extends StatelessWidget {
  final String uid;
  final String name;
  final String avatar;
  final String followersCount;

  const CreatorRecipes(
      {Key key,
      @required this.uid,
      @required this.name,
      @required this.avatar,
      @required this.followersCount})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100.w, 114),
        child: SafeArea(
          child: Row(
            // minLeadingWidth: 1,
            // contentPadding: EdgeInsets.only(left: 1),
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
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (_) => const SelectedRecipe(),
                        //   ),
                        // );
                      },
                    ),
                    CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.amber,
                        foregroundImage: NetworkImage(avatar)),
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
