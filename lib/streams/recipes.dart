import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/screens/recipes/list/widgets/recipes_view.dart';
import 'package:myxmi/utils/loading_column.dart';

class RecipesStreamBuilder extends StatelessWidget {
  const RecipesStreamBuilder({
    Key? key,
    required this.snapshots,
    required this.showAutoCompleteField,
  }) : super(key: key);

  final Stream<QuerySnapshot<Object?>> snapshots;
  final bool showAutoCompleteField;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: snapshots,
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              'somethingWentWrong'.tr(),
              style: const TextStyle(),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          debugPrint('--FIREBASE-- Reading: Recipes/ ');
          return const LoadingColumn();
        }
        if (snapshot.data != null) {
          final _data = snapshot.data;

          return RecipesView(
            showAutoCompleteField: showAutoCompleteField,
            querySnapshot: _data,
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

class RecipesLikesStream extends StatelessWidget {
  const RecipesLikesStream({
    Key? key,
    required this.uid,
  }) : super(key: key);
  final String uid;
  @override
  Widget build(BuildContext context) {
    return RecipesStreamBuilder(
      showAutoCompleteField: true,
      snapshots: FirebaseFirestore.instance
          .collection('Recipes')
          .where('likes.$uid', isEqualTo: true)
          .snapshots(),
    );
  }
}

class RecipesUidStream extends StatelessWidget {
  const RecipesUidStream({
    Key? key,
    required this.uid,
  }) : super(key: key);
  final String? uid;
  @override
  Widget build(BuildContext context) {
    return RecipesStreamBuilder(
      showAutoCompleteField: true,
      snapshots: FirebaseFirestore.instance
          .collection('Recipes')
          .where('uid', isEqualTo: uid)
          .snapshots(),
    );
  }
}
