import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import '../recipe_list.dart';

class RecipesScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
            child: FutureBuilder(
            future: FirebaseFirestore.instance
              .collection('Recipes')
              .orderBy('Made', descending: true)
              .limit(20)
              .get(),
          builder: (_, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text(
                'somethingWentWrong'.tr(),
                style: TextStyle(color: Colors.white),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
                print("LOADING Recipes");
                return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${'loading'.tr()}...",
                  ),
                ],
              );
            }
            return snapshot.data != null
                ? RecipeList(snapshot: snapshot.data)
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
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  );
          },
        )),
      ],
    );
  }
}
