import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/widgets/recipe_list.dart';

class RecipesScreen extends StatefulWidget {
  final String legend;
  final String uid;
  final String searchText;
  const RecipesScreen({this.legend, this.uid, this.searchText});
  @override
  State<RecipesScreen> createState() => RecipesScreenState();
}

class RecipesScreenState extends State<RecipesScreen> {
  Stream<QuerySnapshot> _stream;
  Widget futureBuilder;

  @override
  void initState() {
    getStream();

    super.initState();
  }

  Stream getStream() {
    final String _legend = widget.legend;
    switch (_legend) {
      case 'All':
        _stream = FirebaseFirestore.instance
            .collection('Recipes')
            .where('category', isEqualTo: _legend)
            .snapshots();
        return _stream;
      case 'MyRecipes':
        _stream = FirebaseFirestore.instance
            .collection('Recipes')
            .where('uid', isEqualTo: widget.uid)
            .snapshots();
        return _stream;
      case 'Searching':
        _stream = FirebaseFirestore.instance
            .collection('Recipes')
            .where('title', isEqualTo: widget.searchText)
            .snapshots();
        return _stream;
      default:
        _stream = FirebaseFirestore.instance
            .collection('Recipes')
            .where('sub_category', isEqualTo: _legend)
            .snapshots();
        return _stream;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _stream,
      builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text(
            'somethingWentWrong'.tr(),
            style: const TextStyle(color: Colors.white),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          debugPrint('Loading....');
          return Center(
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
      },
    );
  }
}
