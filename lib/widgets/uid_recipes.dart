import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/screens/recipes_stream.dart';

class UidRecipes extends StatelessWidget {
  final String uid;
  final String path;
  const UidRecipes({@required this.path, @required this.uid});

  Stream<QuerySnapshot> getPath({String userId}) {
    Stream<QuerySnapshot> _streamPath;
    switch (path) {
      case 'all':
        return _streamPath = FirebaseFirestore.instance
            .collection('Recipes')
            .where('uid', isEqualTo: userId)
            .snapshots();

      case 'liked':
        return _streamPath = FirebaseFirestore.instance
            .collection('Recipes')
            .where('likedBy.$userId', isEqualTo: true)
            .snapshots();
    }
    return _streamPath;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getPath(userId: uid),
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(
            'somethingWentWrong'.tr(),
            style: const TextStyle(color: Colors.white),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          debugPrint('----<<<<<Loading from db....>>>>>----');
          return Center(
            child: Text(
              "${'loading'.tr()}...",
            ),
          );
        }
        if (snapshot.data != null) {
          return RecipesView(
            showAutoCompleteField: true,
            myRecipes: _recipes(querySnapshot: snapshot.data),
          );
        } else {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 20.0, left: 40, right: 40.0),
                child: LinearProgressIndicator(
                  color: Colors.white,
                  backgroundColor: Colors.black,
                ),
              ),
              Text(
                'noRecipes'.tr(),
              ),
            ],
          );
        }
      },
    );
  }
}

List<RecipeModel> _recipes({QuerySnapshot querySnapshot}) {
  if (querySnapshot.docs.isNotEmpty) {
    return querySnapshot.docs.map((QueryDocumentSnapshot data) {
      return RecipeModel.fromSnapshot(
        snapshot: data.data() as Map<String, dynamic>,
        keyIndex: data.id,
      );
    }).toList();
  } else {
    return [];
  }
}
