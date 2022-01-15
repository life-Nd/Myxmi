import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/ingredients.dart';
import 'package:myxmi/providers/instructions.dart';
import 'package:myxmi/screens/recipes/selected/widgets/ingredients_listview.dart';

// import 'package:myxmi/providers/user.dart';
String _view = 'UpdateIngredients';
bool _isLoading = false;

class InstructionsListView extends StatelessWidget {
  final List? instructions;
  const InstructionsListView({Key? key, required this.instructions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _ingredients = ref.watch(ingredientsProvider);
        final _instructions = ref.watch(instructionsProvider);

        _instructions.instructions = instructions!;
        // final _checkedInstructions = _instructions.checked;

        return Column(
          children: [
            const Expanded(
              child: _InstructionsListView(),
            ),
            RawMaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              fillColor: Colors.green,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return StatefulBuilder(
                      builder: (_, StateSetter stateSetter) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          insetPadding:
                              const EdgeInsets.only(top: 40, bottom: 40),
                          title: _view == 'UpdateIngredients'
                              ? Center(child: Text('ingredientsUsed'.tr()))
                              : Center(child: Text('instructionsDone'.tr())),
                          content: Column(
                            children: [
                              if (_view == 'UpdateIngredients') ...[
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.5,
                                  width: MediaQuery.of(context).size.width,
                                  child: IngredientsInRecipeListView(
                                    ingredients: _ingredients.allIngredients,
                                  ),
                                ),
                                const Spacer(),
                                if (!_isLoading)
                                  RawMaterialButton(
                                    elevation: 20,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    fillColor: Colors.green,
                                    onPressed: () {
                                      stateSetter(() {
                                        _isLoading = true;
                                      });
                                      Future.delayed(
                                        const Duration(seconds: 2),
                                        () {
                                          stateSetter(
                                            () {
                                              _view = 'SaveRecipeVersion';
                                              _isLoading = false;
                                            },
                                          );
                                        },
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'updatePantryStock'.tr(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  )
                              ] else ...[
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.7,
                                  width: MediaQuery.of(context).size.width,
                                  child: const _InstructionsListView(),
                                ),
                                const Spacer(),
                                if (!_isLoading)
                                  RawMaterialButton(
                                    elevation: 20,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    fillColor: Colors.green,
                                    onPressed: () {
                                      stateSetter(() {
                                        _isLoading = true;
                                      });
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        stateSetter(() {
                                          _view = 'UpdateIngredients';
                                          _isLoading = false;
                                        });
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'saveRecipeVersion'.tr(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              ]
                            ],
                          ),
                          actions: [
                            RawMaterialButton(
                              child: Text(
                                'cancel'.tr(),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                          // RawMaterialButton(
                          //   child: Text(
                          //     'yes'.tr(),
                          //     style: const TextStyle(
                          //       fontSize: 25,
                          //       fontWeight: FontWeight.w400,
                          //     ),
                          //   ),
                          //   onPressed: () async {},
                          // ),
                          // debugPrint(
                          //   'ingredients:--${_ingredients.runtimeType}-- $_ingredients',
                          // );
                          //   final SharedPreferences _prefs =
                          //       await SharedPreferences.getInstance();
                          //   final String _now =
                          //       '${DateTime.now().millisecondsSinceEpoch}';
                          //   final List _keys = _ingredients.checkedIngredients;
                          //   for (int i = 0;
                          //       i < _ingredients.checkedIngredients.length;
                          //       i++) {}
                          // },
                          //   debugPrint('ingredient: $i');
                          //   debugPrint('_keys[i]: ${_keys[i]}');
                          //   final String _key = _keys[i] as String;
                          //   final Map _ingredient =
                          //       _ingredients[_keys[i]] as Map;
                          //   final String _ingredientValue =
                          //       _ingredient['value'] as String;
                          //   final double _quantityUsed =
                          //       double.parse(_ingredientValue);
                          //   final List? _storedIngredient =
                          //       _prefs.getStringList(_key);
                          //   debugPrint(
                          //     '_storedIngredient: $_storedIngredient',
                          //   );
                          //   final String _initialStock =
                          //       _storedIngredient != null
                          //           ? '${_storedIngredient[0]}'
                          //           : '0';
                          //   final String _finalStock = _initialStock != '0'
                          //       ? '${int.parse(_initialStock) - _quantityUsed.toInt()}'
                          //       : '0';

                          //   final String _expiryDate =
                          //       _storedIngredient?[1] != null
                          //           ? '${_storedIngredient![1]}'
                          //           : _now;
                          //   debugPrint('_initialStock: $_initialStock');
                          //   debugPrint('_quantityUsed: $_quantityUsed');
                          //   _prefs.setStringList(
                          //     _key,
                          //     [
                          //       _finalStock,
                          //       _expiryDate,
                          //       _now,
                          //     ],
                          //   );
                          // }
                          // final Map<String, dynamic> _ingredientsMapped =
                          //     _ingredients.map((key, value) {
                          //   final Map _value = value as Map;
                          //   return MapEntry<String, String>(
                          //     '${_value['name']}',
                          //     '${_value['value']} ${_value['type']}',
                          // );
                          // }
                          // );
                          // },
                        );
                      },
                    );
                  },
                );
              },
              child: Text(
                'done'.tr(),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _InstructionsListView extends StatelessWidget {
  const _InstructionsListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, watch) {
        final _instructions = ref.watch(instructionsProvider);

        final _checkedInstructions = _instructions.checked;
        return ListView.builder(
          shrinkWrap: true,
          itemCount: _instructions.instructions.length,
          itemBuilder: (_, int index) {
            final String _instruction =
                _instructions.instructions[index] as String;
            final bool _checked = _checkedInstructions
                .contains(_instructions.instructions[index]);
            return _instruction != ''
                ? Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        onTap: () {
                          _instructions.toggleInstruction(
                            _instructions.instructions[index].toString(),
                          );
                        },
                        leading: IconButton(
                          icon: _checked
                              ? const Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                  size: 30,
                                )
                              : const Icon(
                                  Icons.radio_button_unchecked,
                                  size: 30,
                                ),
                          onPressed: () {
                            _instructions.toggleInstruction(
                              _instructions.instructions[index].toString(),
                            );
                          },
                        ),
                        title: Text(
                          '${_instructions.instructions[index]}',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  )
                : Container();
          },
        );
      },
    );
  }
}
