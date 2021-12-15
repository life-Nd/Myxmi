import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/image.dart';
import 'package:myxmi/providers/recipe_entries.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/providers/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class SaveButton extends StatefulWidget {
  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context: context);

    return Consumer(
      builder: (_, ref, child) {
        final _recipe = ref.watch(recipeEntriesProvider);
        final _image = ref.watch(imageProvider);
        final _user = ref.watch(userProvider);
        final _router = ref.watch(routerProvider);
        return RawMaterialButton(
          onPressed: _recipe.recipe.title != null
              ? () async {
                  final SharedPreferences _prefs =
                      await SharedPreferences.getInstance();
                  pr.show(
                    max: 100,
                    msg: '${'loading'.tr()} ${'recipe'.tr()}...',
                  );
                  // final rng = Random();
                  // final _random = rng.nextInt(9000) + 1000;
                  // _recipe.recipe.reference = '$_random';
                  // _recipe.recipe.uid = _user.account!.uid;
                  // _recipe.recipe.access = 'Public';
                  // _recipe.recipe.usedCount = '1';
                  // _recipe.recipe.instructionsCount =
                  //     '${_recipe.instructions.length}';
                  // _recipe.recipe.username = _user.account!.displayName;
                  // _recipe.recipe.userphoto = _user.account!.photoURL;
                  // _recipe.recipe.tags = {
                  //   _recipe.category: true,
                  //   _recipe.subCategory: true,
                  //   _recipe.diet: true,
                  // };

                  final Map _composition = _recipe.composition;
                  final List _keys = _composition.keys.toList();
                  for (int i = 0; i < _keys.length; i++) {
                    final Map _ingredients = _composition[_keys[i]] as Map;
                    // _recipe.ingredients = {
                    //   '${_ingredients['name']}':
                    //       "${_ingredients['value']} ${_ingredients['type']}",
                    // };
                    final String _quantity = '${_ingredients['value']}';
                    final double _quantityUsed = double.parse(_quantity);
                    final List? _product =
                        _prefs.getStringList(_keys[i] as String);
                    debugPrint('_product: $_product');
                    // if (_product != null) {
                    //   final double _updatedProduct =
                    //       double.parse(_product[0] as String) - _quantityUsed;
                    //   _prefs.setStringList(
                    //     _keys[i] as String,
                    //     ['$_updatedProduct', _product[1] as String],
                    //   );
                    //   debugPrint('_updatedProduct: $_updatedProduct');
                    //   debugPrint(
                    //     '_updatedPrefs: ${_keys[i]}=[$_updatedProduct ${_product[1]}]',
                    //   );
                    // }
                  }

                  // _recipe.recipe.made =
                  //     '${DateTime.now().millisecondsSinceEpoch}';
                  // if (_recipe.category == 'other') {
                  //   _recipe.subCategory = null;
                  // }

                  if (_image.imageFile != null) {
                    // await _image.addImageToDb(context: context).whenComplete(
                    //   () async {
                    //     _recipe.recipe.imageUrl = _image.imageLink.isNotEmpty
                    //         ? _image.imageLink
                    //         : null;
                    //     debugPrint(
                    //       '_recipe.recipe.toMap(): ${_recipe.recipe.toMap()}',
                    //     );
                    //     debugPrint(
                    //       '_recipe.ingredients as Map<String, dynamic>,: ${_recipe.ingredients as Map<String, dynamic>}',
                    //     );
                    // await saveRecipe(
                    //   _recipe.recipe.toMap(),
                    // ).then(
                    //   (value) {
                    //     saveIngredients(
                    //       recipeId: value,
                    //       ingredients:
                    //           _recipe.ingredients as Map<String, dynamic>,
                    //     );
                    //     saveInstructions(
                    //       recipeId: value,
                    //       instructions: _recipe.instructions.asMap()
                    //           as Map<String, dynamic>,
                    //     ).then(
                    //       (value) {
                    //         pr.close();
                    //         _image.reset();
                    //         _recipe.reset();
                    //       },
                    //     );
                    //   },
                    // );
                    //     },
                    //   );
                    // } else {
                    //   final Map _instructionsMapped = {};
                    //   debugPrint('_instructionsMapped: $_instructionsMapped');
                    //   _instructionsMapped['list'] = _recipe.instructions;
                    //   _instructionsMapped['made'] =
                    //       '${DateTime.now().millisecondsSinceEpoch}';
                    //   _instructionsMapped['uid'] = _user.account!.uid;
                    // await saveRecipe(
                    //   _recipe.recipe.toMap(),
                    // ).then(
                    //   (value) async => saveInstructions(
                    //     recipeId: value,
                    //     instructions: _recipe.instructions.asMap()
                    //         as Map<String, dynamic>,
                    //   ).then(
                    //     (value) {
                    //       pr.close();
                    //       _image.reset();
                    //       _recipe.reset();
                    //     },
                    //   ),
                    // );
                  }
                  // if (!mounted) return;
                  // _router.pushPage(
                  //   name: '/home',
                  // );
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
      },
    );
  }
}

Future<String> saveRecipe(Map<String, dynamic> recipe) async {
  debugPrint('--FIREBASE-- Writing: Recipes/ $recipe ');
  final DocumentReference _db =
      await FirebaseFirestore.instance.collection('Recipes').add(recipe);
  return _db.id;
}

Future saveIngredients({
  String? recipeId,
  required Map<String, dynamic> ingredients,
}) async {
  debugPrint('--FIREBASE-- Writing: Instructions/$recipeId.$ingredients ');
  FirebaseFirestore.instance
      .collection('Ingredients')
      .doc(recipeId)
      .set(ingredients);
}

Future saveInstructions({
  String? recipeId,
  required Map<String, dynamic> instructions,
}) async {
  debugPrint('--FIREBASE-- Writing: Instructions/$recipeId.$instructions ');
  FirebaseFirestore.instance
      .collection('Instructions')
      .doc(recipeId)
      .set(instructions);
}
