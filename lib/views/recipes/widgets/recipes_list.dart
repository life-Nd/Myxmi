import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/models/recipes.dart';
import 'auto_complete_recipes.dart';
import 'recipes_grid.dart';

TextEditingController _searchMyRecipesCtrl = TextEditingController();

class RecipesList extends StatefulWidget {
  final QuerySnapshot querySnapshot;
  final bool showAutoCompleteField;

  const RecipesList(
      {Key key,
      @required this.querySnapshot,
      @required this.showAutoCompleteField})
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

  List<RecipeModel> _recipes() {
    if (widget.querySnapshot.docs.isNotEmpty) {
      return widget.querySnapshot.docs.map((QueryDocumentSnapshot data) {
        return RecipeModel.fromSnapshot(
          snapshot: data.data() as Map<String, dynamic>,
          keyIndex: data.id,
        );
      }).toList();
    } else {
      return [];
    }
  }

  List<RecipeModel> _filterRecipes() {
    final List<RecipeModel> _filteredRecipes = [];
    final Iterable _filter = _recipes().asMap().entries.where((entry) {
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
                          suggestions: _recipes(),
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
                    ? _recipes()
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
