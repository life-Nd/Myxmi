import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/utils/loading_column.dart';
import 'widgets/auto_complete_recipes.dart';
import 'widgets/recipes_grid.dart';

TextEditingController _searchMyRecipesCtrl = TextEditingController();

class Recipes extends StatelessWidget {
  final Stream<QuerySnapshot> snapshots;
  final bool showAutoCompleteField;
  final String searchFieldLabel;
  const Recipes({
    Key key,
    @required this.snapshots,
    @required this.showAutoCompleteField,
    @required this.searchFieldLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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

    return Consumer(builder: (_, watch, child) {
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
            debugPrint('--FIREBASE-- Reading: Recipes/$searchFieldLabel ');
            return const LoadingColumn();
          }
          if (snapshot.data != null) {
            return RecipesList(
              showAutoCompleteField: showAutoCompleteField,
              list: _recipes(querySnapshot: snapshot.data),
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
    });
  }
}

class RecipesList extends StatefulWidget {
  final List<RecipeModel> list;
  final bool showAutoCompleteField;

  const RecipesList(
      {Key key, @required this.list, @required this.showAutoCompleteField})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecipesListState();
}

class _RecipesListState extends State<RecipesList> {
  @override
  void initState() {
    _searchMyRecipesCtrl = TextEditingController();
    super.initState();
  }

  List<RecipeModel> _filterRecipes() {
    final List<RecipeModel> _filteredRecipes = [];
    final Iterable _filter = widget.list.asMap().entries.where((entry) {
      return entry.value.toMap().containsValue(
            _searchMyRecipesCtrl.text.trim().toLowerCase(),
          );
    });
    final _filtered = Map.fromEntries(_filter as Iterable<MapEntry>);
    _filtered.forEach((key, value) {
      _filteredRecipes.add(value as RecipeModel);
    });
    return _filteredRecipes;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, StateSetter stateSetter) {
        return Column(
          children: [
            if (widget.showAutoCompleteField)
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 4, bottom: 8),
                      child: AutoCompleteRecipes(
                          suggestions: widget.list,
                          controller: _searchMyRecipesCtrl,
                          onSubmit: () {
                            _filterRecipes().clear();
                            stateSetter(() {});
                          },
                          onClear: () {
                            _filterRecipes().clear();
                            _searchMyRecipesCtrl.clear();
                            stateSetter(() {});
                          }),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 4),
            Expanded(
              child: RecipesGrid(
                recipes: _searchMyRecipesCtrl.text.isEmpty
                    ? widget.list
                    : _filterRecipes(),
              ),
            ),
          ],
        );
      },
    );
  }
}


// TODO change this to use the paginate_firestore package
    //  in the future if the data is inefficiently read from firestore

  //   return Consumer(
  //     builder: (_, watch, child) {
  //       return PaginateFirestore(
  //         // orderBy is compulsory to enable pagination
  //         query: query.limit(10),

  //         //Change types accordingly
  //         itemBuilderType: PaginateBuilderType.gridView,
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           childAspectRatio: 0.6,
  //           crossAxisCount: kIsWeb && 100.w > 500 ? 4 : 2,
  //         ),
  //         padding: const EdgeInsets.all(1),
  //         // to fetch real-time data
  //         isLive: true,
  //         emptyDisplay: NoRecipes(),
  //         //item builder type is compulsory.
  //         itemBuilder: (index, context, DocumentSnapshot documentSnapshot) {
  //           final _data = documentSnapshot.data() as Map;
  //           return RecipeTile(
  //             index: index,
  //             recipes: _recipes(
  //               data: _data,
  //               recipeId: documentSnapshot.id,
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
