import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
      onPressed: _recipe.recipesModel.title != null
          ? () async {
              String _key;
              final rng = Random();
              final _random = rng.nextInt(9000) + 1000;
              _recipe.recipesModel.reference = '$_random';
              _recipe.recipesModel.uid = _user.account.uid;
              _recipe.recipesModel.access = 'Public';
              _recipe.recipesModel.usedCount = '1';
              _recipe.recipesModel.stepsCount =
                  '${_recipe.instructions.steps.length}';
              _recipe.instructions.ingredients = _recipe.composition;
              _recipe.instructions.uid = _user.account.uid;
              _recipe.recipesModel.made =
                  '${DateTime.now().millisecondsSinceEpoch}';
              _image.addImageToDb(context: context).whenComplete(() async {
                pr.show(max: 100, msg: '${'loading'.tr()} ${'recipe'.tr()}...');
                _recipe.recipesModel.imageUrl =
                    _image.imageLink.isNotEmpty ? _image.imageLink : null;
                final DocumentReference _db = await FirebaseFirestore.instance
                    .collection('Recipes')
                    .add(_recipe.recipesModel.toMap());

                _key = _db.id;
                debugPrint('----KeyID: $_key');
              }).whenComplete(() async {
                debugPrint(
                    'Instructions: ${_recipe.instructions.ingredients} \n ${_recipe.instructions.steps} ');
                await FirebaseFirestore.instance
                    .collection('Instructions')
                    .doc(_key)
                    .set(_recipe.instructions.toMap());
              }).whenComplete(() {
                pr.close();
                _recipe.reset();
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                    (route) => false);
              });
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
