import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/image.dart';
import 'package:myxmi/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../main.dart';
import '../screens/add_infos_to_recipe.dart';

class SaveButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context: context);
    final _recipe = useProvider(recipeEntriesProvider);
    final _image = useProvider(imageProvider);
    final _user = useProvider(userProvider);
    debugPrint(
        '_recipe.instructions.ingredients: ${_recipe.instructions.ingredients}');

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
              final SharedPreferences _prefs =
                  await SharedPreferences.getInstance();
              final List _keys = _recipe.instructions.ingredients.keys.toList();
              for (int i = 0; i < _keys.length; i++) {
                debugPrint('i: ${_keys[i]}');
                debugPrint(
                    '_recipe.instructions.ingredients[i]: ${_recipe.instructions.ingredients[_keys[i]]}');
                final List _product = _prefs.getStringList(_keys[i] as String);
                debugPrint('_product: $_product');
                if (_product != null) {
                  final double _updatedProduct =
                      double.parse(_product[0] as String) - 1;
                  _prefs.setStringList(_keys[i] as String,
                      ['$_updatedProduct', _product[1] as String]);
                  debugPrint('_updatedProduct: $_updatedProduct');
                }
              }

              _recipe.recipe.made = '${DateTime.now().millisecondsSinceEpoch}';
              if (_recipe.recipe.category == 'other') {
                _recipe.recipe.subCategory = null;
              }
              if (_image.imageFile != null && _recipe.recipe.imageUrl != null) {
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
              for (int i = 0;
                  i < _recipe.instructions.ingredients.keys.length;
                  i++) {
                final List _product = _prefs.getStringList(
                    _recipe.instructions.ingredients[i] as String);
                final double _updatedProduct =
                    double.parse(_product[0] as String) - 1;
                _prefs.setStringList(
                    _recipe.instructions.ingredients[i] as String,
                    ['$_updatedProduct', _product[1] as String]);
              }

              pr.close();
              _recipe.reset();
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ),
                  (route) => false);
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
  debugPrint('--FIREBASE-- Writing: Recipes/ $recipe ');
  final DocumentReference _db =
      await FirebaseFirestore.instance.collection('Recipes').add(recipe);
  return _db.id;
}

Future saveInstructions({String id, Map<String, dynamic> instructions}) async {
  debugPrint('--FIREBASE-- Writing: Instructions/$id.$instructions ');
  FirebaseFirestore.instance
      .collection('Instructions')
      .doc(id)
      .set(instructions);
}

