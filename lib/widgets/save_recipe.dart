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
import '../screens/add_recipe.dart';

class SaveButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context: context);
    final _recipe = useProvider(recipeProvider);
    final _image = useProvider(imageProvider);
    final _user = useProvider(userProvider);
    return IconButton(
      icon: Icon(
        Icons.save,
        color: Colors.green,
      ),
      onPressed: _recipe.details.title.isNotEmpty
          ? () async {
              String _key;

              var rng = new Random();
              var _random = rng.nextInt(9000) + 1000;
              _recipe.details.reference = '$_random';
              _recipe.details.uid = '${_user.account.uid}';
              _recipe.details.access = 'Public';
              _recipe.details.usedCount = '1';
              _recipe.details.stepsCount =
                  '${_recipe.instructions.steps.length}';
              _recipe.instructions.products = _recipe.composition;
              _recipe.details.made = '${DateTime.now().millisecondsSinceEpoch}';
              _image.addImageToDb(context: context).whenComplete(() async {
                pr.show(max: 100, msg: '${'loading'.tr()} ${'recipe'.tr()}...');
                _recipe.details.imageUrl = _image.imageLink;
                DocumentReference _db = await FirebaseFirestore.instance
                    .collection('Recipes')
                    .add(_recipe.details.toMap());

                _key = _db.id;
                print('----KeyID: $_key');
              }).whenComplete(() async {
                print(
                    'Instructions: ${_recipe.instructions.products} \n ${_recipe.instructions.steps} ');
                await FirebaseFirestore.instance
                    .collection('Instructions')
                    .doc('$_key')
                    .set(_recipe.instructions.toMap());
              }).whenComplete(() {
                pr.close();

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => Home(),
                    ),
                    (route) => false);
              });
              _recipe.reset();
            }

          // ? () {
          //     showDialog(
          //         context: context,
          //         builder: (_) {
          //           return AlertDialog(
          //             title: Text('${'actualQuantity'.tr()}'),
          //             content:
          //                 Column(mainAxisSize: MainAxisSize.min, children: [
          //               Padding(
          //                 padding: const EdgeInsets.only(
          //                     top: 2, bottom: 4, right: 80, left: 80),
          //                 child: TextField(
          //                   keyboardType: TextInputType.number,
          //                   controller: _actualWeightCtrl,
          //                   decoration: InputDecoration(
          //                     isDense: true,
          //                     border: OutlineInputBorder(
          //                         borderRadius: BorderRadius.circular(20)),
          //                     hintText: 'g',
          //                   ),
          //                 ),
          //               ),
          //             ]),
          //             actions: [
          //               RawMaterialButton(
          //                 fillColor: Colors.green,
          //                 child: Text('${'save'.tr()}'),
          //                 onPressed: () {

          //       FirebaseFirestore.instance
          //           .collection('Recipes')
          //           .add({
          //         'Name': '${_recipe.recipe.title}',
          //         'Made':
          //             '${DateTime.now().millisecondsSinceEpoch}',
          //         'Score': '0.0',
          //         'Composition': _recipe.composition,
          //         'Comments': {},
          //         'Estimated Quantitu8y':
          //             '${_recipe.estimatedWeight.toStringAsFixed(3)}',
          //         'Actual Quantity': '${_actualWeightCtrl.text}',
          //         'UserName': '${_user.account?.displayName}',
          //         'Uid': '${_user.account?.uid}',
          //         'UserEmail': '${_user.account?.email}',
          //         'UserAvatar': '${_user.account?.photoURL}',
          //         'Images': _image.imageLinks,
          //         'Category': '${_recipe.recipe.category}',
          //         'SubCategory': '${_recipe.recipe.subCategory}',
          //         'Stars': '${_recipe.recipe.stars}',
          //         'Access': '${_recipe.recipe.access}',
          //         'Vegan': '${_recipe.recipe.vegan}',
          //         'Difficulty': '${_recipe.recipe.difficulty}',
          //         'Reference': '$_random'
          //       }).then(
          //         (value) =>
          //             Navigator.of(context).pushAndRemoveUntil(
          //                 MaterialPageRoute(
          //                   builder: (_) => Home(),
          //                 ),
          //                 (route) => false),
          //       );
          //       _recipe.reset();
          //       _recipe.unhide();
          //       },
          //     )
          //   ],
          // );
          // });
          // }
          : () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('${'fieldsEmpty'.tr()}'),
                ),
              );
            },
    );
  }
}
