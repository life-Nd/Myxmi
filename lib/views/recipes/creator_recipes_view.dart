import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/streams/recipes.dart';
import 'package:myxmi/utils/user_avatar.dart';

class CreatorRecipes extends StatefulWidget {
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
  State<CreatorRecipes> createState() => _CreatorRecipesState();
}

class _CreatorRecipesState extends State<CreatorRecipes> {
  @override
  Widget build(BuildContext context) {
    // final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 114),
        child: SafeArea(
          child: Row(
            children: [
              if (widget.avatar != null)
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
                      photoUrl: widget.avatar,
                    ),
                  ],
                )
              else
                const Icon(Icons.person),
              const SizedBox(
                width: 20,
              ),
              if (widget.name != null)
                Text('${widget.name} recipes')
              else
                Text('${'noName'.tr()} recipes'),
              // subtitle: Text('$followersCount ${'followers'.tr()}'),
            ],
          ),
        ),
      ),
      body: RecipesUidStream(uid: widget.uid),
    );
  }
}
