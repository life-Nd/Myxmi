import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/widgets/recipe_list.dart';

class RecipesScreen extends StatefulWidget {
  final String legend;
  final String uid;
  RecipesScreen({this.legend, this.uid});
  createState() => RecipesScreenState();
}

class RecipesScreenState extends State<RecipesScreen> {
  Future _future;
  Widget futureBuilder;
  @override
  void initState() {
    getFuture();
    super.initState();
  }

  Future getFuture() {
    print('widget.legend: ${widget.legend}');
    String _legend = widget.legend;
    print('LEGEND: $_legend');
    switch (_legend) {
      case ('All'):
        _future = FirebaseFirestore.instance
            .collection('Recipes')
            .where('category', isEqualTo: '$_legend')
            .get();
        return _future;
      case ('MyRecipes'):
        _future = FirebaseFirestore.instance
            .collection('Recipes')
            .where('uid', isEqualTo: '${widget.uid}')
            .get();
        return _future;
      default:
        _future = FirebaseFirestore.instance
            .collection('Recipes')
            .where('sub_category', isEqualTo: '$_legend')
            .get();
        return _future;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _future,
      builder: (_, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text(
            'somethingWentWrong'.tr(),
            style: TextStyle(color: Colors.white),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            alignment: Alignment.center,
            child: Text(
              "${'loading'.tr()}...",
            ),
          );
        }
        return snapshot.data != null
            ? RecipeList(
                snapshot: snapshot.data,
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
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
  }
}
