import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:myxmi/screens/home.dart';
import 'package:flutter/foundation.dart';
import 'package:myxmi/widgets/recipes_grid.dart';

TextEditingController _searchMyRecipesCtrl = TextEditingController();

class MyRecipes extends StatefulWidget {
  final Stream<QuerySnapshot> path;
  const MyRecipes({Key key, this.path}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _RecipesState();
}

class _RecipesState extends State<MyRecipes> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<RecipesModel> _recipes({QuerySnapshot querySnapshot}) {
      return querySnapshot.docs.map((QueryDocumentSnapshot data) {
        return RecipesModel.fromSnapshot(
          snapshot: data.data() as Map<String, dynamic>,
          keyIndex: data.id,
        );
      }).toList();
    }

    debugPrint('building recipe');
    return Consumer(
      builder: (_, watch, __) {
        final _view = watch(viewProvider);
        final _recipe = watch(recipeProvider);
        return StreamBuilder<QuerySnapshot>(
          stream: widget.path,
          builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text(
                'somethingWentWrong'.tr(),
                style: const TextStyle(color: Colors.white),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              debugPrint('----<<<<<Loading ${_view.view} from db....>>>>>----');
              return Center(
                child: Text(
                  "${'loading'.tr()}...",
                ),
              );
            }
            if (snapshot.data != null) {
              _recipe.recipesList = _recipes(querySnapshot: snapshot.data);
              return MyRecipesView(
                myRecipes: _recipes(querySnapshot: snapshot.data),
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.only(bottom: 20.0, left: 40, right: 40.0),
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
      },
    );
  }
}

class MyRecipesView extends StatelessWidget {
  final List<RecipesModel> _filteredRecipes = [];
  final List<RecipesModel> myRecipes;
  MyRecipesView({Key key, this.myRecipes}) : super(key: key);
  List<RecipesModel> _filterRecipes() {
    final Iterable _filter = myRecipes.asMap().entries.where((entry) {
      return entry.value.toMap().containsValue(
            _searchMyRecipesCtrl.text.trim().toLowerCase(),
          );
    });
    final _filtered = Map.fromEntries(_filter as Iterable<MapEntry>);
    _filtered.forEach((key, value) {
      _filteredRecipes.add(value as RecipesModel);
    });
    return _filteredRecipes;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, StateSetter stateSetter) {
      return SingleChildScrollView(
        child: Column(
          children: [
            SearchField(
              controller: _searchMyRecipesCtrl,
              onSubmit: (submitted) {
                _filteredRecipes.clear();
                stateSetter(() {});
              },
              clear: () {
                _filteredRecipes.clear();
                _searchMyRecipesCtrl.clear();
                stateSetter(() {});
              },
              search: () {
                _filteredRecipes.clear();
                stateSetter(() {});
              },
            ),
            RecipesGrid(
              recipes: _searchMyRecipesCtrl.text.isEmpty
                  ? myRecipes
                  : _filterRecipes(),
            ),
          ],
        ),
      );
    });
  }
}

class SearchField extends StatelessWidget {
  final ValueChanged<String> onSubmit;
  final Function search;
  final Function clear;
  final TextEditingController controller;

  const SearchField({
    Key key,
    @required this.controller,
    @required this.onSubmit,
    @required this.clear,
    @required this.search,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            onSubmitted: (submitted) {
              debugPrint('SUBMITTED: $submitted');
              !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
              onSubmit(submitted);
            },
            onChanged: (value) {
              search();
            },
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              hintText: 'search'.tr(),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.clear,
            color: Colors.red,
          ),
          onPressed: () {
            !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
            FocusScope.of(context).unfocus();
            clear();
          },
        ),
        IconButton(
            icon: const Icon(
              Icons.search,
            ),
            onPressed: () {
              search();
              !kIsWeb ?? FocusScope.of(context).requestFocus(FocusNode());
              FocusScope.of(context).unfocus();
            }),
      ],
    );
  }
}
