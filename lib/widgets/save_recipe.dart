import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myxmi/providers/image.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../main.dart';
import '../screens/add_recipe.dart';

TextEditingController _actualWeightCtrl = TextEditingController();

class SaveButton extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeProvider);
    final _image = useProvider(imageProvider);
    final _user = useProvider(userProvider);
    return IconButton(
      icon: Icon(
        Icons.save,
        color: Colors.green,
      ),
      onPressed: _recipe.recipe.title.isNotEmpty
          ? () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text('${'actualQuantity'.tr()}'),
                      content:
                          Column(mainAxisSize: MainAxisSize.min, children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2, bottom: 4, right: 80, left: 80),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _actualWeightCtrl,
                            decoration: InputDecoration(
                              isDense: true,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: 'g',
                            ),
                          ),
                        ),
                      ]),
                      actions: [
                        RawMaterialButton(
                          fillColor: Colors.green,
                          child: Text('${'save'.tr()}'),
                          onPressed: () {
                            var rng = new Random();
                            var _random = rng.nextInt(9000) + 1000;
                            _recipe.recipe.reference = '$_random';
                            _recipe.recipe.uid = '${_user.account.uid}';
                            _recipe.recipe.access = 'Public';
                            

                            FirebaseFirestore.instance
                                .collection('Recipes')
                                .add(_recipe.recipe.toMap());

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
                          },
                        )
                      ],
                    );
                  });
            }
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
