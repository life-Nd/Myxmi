import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/widgets/recipes_by_uid.dart';

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
      appBar: AppBar(
        leadingWidth: 20,
        title: ListTile(
           leading: avatar != null
              ? CircleAvatar(
                  backgroundColor: Colors.amber,
                  foregroundImage: NetworkImage(avatar))
              : const Icon(Icons.person),
          title: name != null ? Text(name) : Text('noName'.tr()),
          // subtitle: Text('$followersCount ${'followers'.tr()}'),
        ),
      ),
      body: RecipesByUid(
        path: 'all',
        uid: uid,
      ),
    );
  }
}
