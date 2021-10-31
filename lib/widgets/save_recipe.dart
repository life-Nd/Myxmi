import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/image.dart';
import 'package:myxmi/screens/home.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../main.dart';
import '../screens/add_recipe_infos.dart';

class SaveButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context: context);
    final _recipe = useProvider(recipeProvider);
    final _image = useProvider(imageProvider);
    final _user = useProvider(userProvider);
    return RawMaterialButton(
      onPressed: _recipe.recipe.title != null
          ? () async {
              pr.show(max: 100, msg: '${'loading'.tr()} ${'recipe'.tr()}...');
              final rng = Random();
              final _random = rng.nextInt(9000) + 1000;
              _recipe.recipe.reference = '$_random';
              _recipe.recipe.uid = _user.account.uid;
              _recipe.recipe.access = 'Public';
              _recipe.recipe.usedCount = '1';
              _recipe.recipe.stepsCount =
                  '${_recipe.instructions.steps.length}';
              _recipe.instructions.ingredients = _recipe.composition;
              _recipe.instructions.uid = _user.account.uid;
              _recipe.recipe.username = _user.account.displayName;
              _recipe.recipe.userphoto = _user.account.photoURL;
              debugPrint(
                  '_recipe?.recipe.subCategory:${_recipe?.recipe?.subCategory}');
              _recipe.recipe.made =
                  '${DateTime.now().millisecondsSinceEpoch}';
              if (_recipe.recipe.category == 'other') {
                _recipe.recipe.subCategory = null;
              }
              if (_image.imageFile != null &&
                  _recipe.recipe.imageUrl != null) {
                _image.addImageToDb(context: context).whenComplete(() async {
                  _recipe.recipe.imageUrl =
                      _image.imageLink.isNotEmpty ? _image.imageLink : null;
                  await saveRecipe(_recipe.recipe.toMap()).then((value) =>
                      saveInstructions(
                          id: value,
                          instructions: _recipe.instructions.toMap()));
                });
              } else {
                await saveRecipe(_recipe.recipe.toMap()).then((value) =>
                    saveInstructions(
                        id: value, instructions: _recipe.instructions.toMap()));
              }

              pr.close();
              _recipe.reset();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                  (route) => false);

              // .whenComplete(() async {
              //   pr.show(max: 100, msg: '${'loading'.tr()} ${'recipe'.tr()}...');
              //   _recipe.recipe.imageUrl =
              //       _image.imageLink.isNotEmpty ? _image.imageLink : null;
              //   final DocumentReference _db = await FirebaseFirestore.instance
              //       .collection('Recipes')
              //       .add(_recipe.recipe.toMap());
              //   _key = _db.id;
              // }).whenComplete(() async {
              //   debugPrint(
              //       'Instructions: ${_recipe.instructions.ingredients} \n ${_recipe.instructions.steps} ');
              //   await FirebaseFirestore.instance
              //       .collection('Instructions')
              //       .doc(_key)
              //       .set(_recipe.instructions.toMap());
              // }).whenComplete(() {
              //   // TODO after uploading the recipe, we should update the quantity of the products used
              //   // _recipe.instructions.ingredients.forEach((key, value) async {
              //   //   await FirebaseFirestore.instance
              //   //       .collection('Products')
              //   //       .doc(_user.account.uid)
              //   //       .update(_recipe.instructions.toMap());
              //   // });
              //   pr.close();
              //   _recipe.reset();
              //   Navigator.of(context).pushAndRemoveUntil(
              //       MaterialPageRoute(
              //         builder: (context) => Home(uid: _user?.account?.uid),
              //       ),
              //       (route) => false);
              // });
            }
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('fieldsEmpty'.tr()),
                ),
              );
            },
      child: Text(
        'save'.tr(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }
}

Future<String> saveRecipe(Map<String, dynamic> recipe) async {
  final DocumentReference _db =
      await FirebaseFirestore.instance.collection('Recipes').add(recipe);
  return _db.id;
}

Future saveInstructions({String id, Map<String, dynamic> instructions}) async {
  FirebaseFirestore.instance
      .collection('Instructions')
      .doc(id)
      .set(instructions);
}
