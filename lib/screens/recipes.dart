import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/screens/home.dart';
import 'package:myxmi/widgets/recipes_grid.dart';

class RecipesStream extends StatefulWidget {
  final Stream<QuerySnapshot> path;
  const RecipesStream({Key key, this.path}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecipesState();
}

class _RecipesState extends State<RecipesStream> {
  @override
  void initState() {
    // _path = widget.path;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, __) {
        final _view = watch(viewProvider);
        final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
            .collection('Recipes')
            .where('title', isEqualTo: _view.searchText())
            .snapshots();
        return StreamBuilder<QuerySnapshot>(
          stream: _view.isSearchingInDb ? _stream : widget.path,
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text(
                'somethingWentWrong'.tr(),
                style: const TextStyle(color: Colors.white),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              debugPrint('Loading from db....');
              return Center(
                child: Text(
                  "${'loading'.tr()}...",
                ),
              );
            }
            return snapshot.data != null
                ? RecipesGrid(
                    recipes: _recipes(querySnapshot: snapshot.data),
                    type: 'Category',
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(
                            bottom: 20.0, left: 40, right: 40.0),
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
          },
        );
      },
    );
  }
}

List<RecipesModel> _recipes({QuerySnapshot querySnapshot}) {
  return querySnapshot.docs.map((QueryDocumentSnapshot data) {
    return RecipesModel.fromSnapshot(
      snapshot: data.data() as Map<String, dynamic>,
      keyIndex: data.id,
    );
  }).toList();
}
