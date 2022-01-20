import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:myxmi/providers/ingredients.dart';
import 'package:myxmi/providers/instructions.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/screens/recipes/list/widgets/recipe_image.dart';
import 'package:myxmi/screens/recipes/list/widgets/recipe_tile_details.dart';
import 'package:myxmi/screens/recipes/selected/widgets/ingredients_listview.dart';
import 'package:myxmi/screens/recipes/selected/widgets/recipe_details.dart';
import 'package:myxmi/utils/calendar_save_button.dart';

String _view = 'calendar';
String _calendarUpdateStatus = 'null';
String _calendarSaveOption = 'null';
// String _ingredientsUpdateStatus = 'null';
// String _instructionsUpdateStatus = 'null';

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
        final _router = ref.watch(routerProvider);
        _instructions.instructions = instructions!;
        // final _checkedInstructions = _instructions.checked;
        final _recipe = ref.watch(recipeDetailsProvider);
        // final _user = ref.watch(userProvider);
        return Stack(
          children: [
            const _InstructionsListView(),
            Align(
              alignment: Alignment.bottomCenter,
              child: RawMaterialButton(
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
                            actionsPadding: const EdgeInsets.all(0.1),
                            contentPadding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                              top: 4,
                              bottom: 4,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            insetPadding:
                                const EdgeInsets.only(top: 40, bottom: 40),
                            title: TitleRow(
                              setState: stateSetter,
                            ),
                            content: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                const Divider(
                                  color: Colors.grey,
                                  indent: 10,
                                  endIndent: 10,
                                ),
                                if (_view == 'calendar') ...[
                                  if (_calendarUpdateStatus == 'null') ...[
                                    const SizedBox(height: 20),
                                    TrackInCalendar(
                                      setState: stateSetter,
                                    ),
                                  ] else if (_calendarUpdateStatus == 'success')
                                    Text(
                                      'calendarUpdateSuccess'.tr(),
                                      style: const TextStyle(
                                        color: Colors.green,
                                      ),
                                    )
                                  else
                                    Text(
                                      'calendarLoading'.tr(),
                                      style: const TextStyle(
                                        color: Colors.red,
                                      ),
                                    ),
                                ],
                                if (_view == 'ingredients') ...[
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: IngredientsInRecipeListView(
                                      ingredients: _ingredients.allIngredients,
                                    ),
                                  ),
                                  if (!_isLoading)
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: SaveEventToCalendarButton(
                                        color: Colors.grey,
                                        hour: DateTime.now()
                                            .hour
                                            .toString()
                                            .padLeft(2, '0'),
                                        minute: DateTime.now()
                                            .minute
                                            .toString()
                                            .padLeft(2, '0'),
                                        selectedDates: [
                                          DateTime.now(),
                                        ],
                                        imageUrl: _recipe.details.imageUrl,
                                        recipeId: _recipe.details.recipeId,
                                        title: _recipe.details.title,
                                        type: 'track',
                                      ),
                                      // child: RawMaterialButton(
                                      //   elevation: 20,
                                      //   shape: RoundedRectangleBorder(
                                      //     borderRadius:
                                      //         BorderRadius.circular(20),
                                      //   ),
                                      //   fillColor: Colors.green,
                                      //   onPressed: () {
                                      //     final _calendar =
                                      //         ref.read(calendarEventProvider);
                                      //     stateSetter(() {
                                      //       _isLoading = true;
                                      //     });
                                      //     Future.delayed(
                                      //       const Duration(seconds: 2),
                                      //       () {
                                      //         stateSetter(
                                      //           () {
                                      //             _calendar.updateDb(
                                      //               eventId: _recipe
                                      //                   .details.recipeId!,
                                      //               date: '${DateTime.now()}',
                                      //               uid: _user.account!.uid,
                                      //             );
                                      //             _view = 'SaveRecipeVersion';
                                      //             _isLoading = false;
                                      //           },
                                      //         );
                                      //       },
                                      //     );
                                      //   },
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.all(8.0),
                                      //     child: Text(
                                      //       'updatePantryStock'.tr(),
                                      //       style: const TextStyle(
                                      //         color: Colors.white,
                                      //         fontSize: 22,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                    )
                                  else
                                    Center(
                                      child:
                                          LoadingAnimationWidget.halfTringleDot(
                                        color: Colors.grey,
                                        size: 200,
                                      ),
                                    )
                                ] else if (_view == 'instructions') ...[
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    width: MediaQuery.of(context).size.width,
                                    child: const _InstructionsListView(),
                                  ),
                                  if (!_isLoading)
                                    RawMaterialButton(
                                      elevation: 20,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      fillColor: Colors.green,
                                      onPressed: () {
                                        // final _recipe =
                                        //     ref.watch(recipeEntriesProvider);
                                        stateSetter(() {
                                          _isLoading = true;
                                        });
                                        Future.delayed(
                                            const Duration(seconds: 2), () {
                                          _router.pushPage(
                                            name: '/add-recipe-infos',
                                          );
                                          // stateSetter(() async {
                                          //   _view = 'calendar';
                                          //   await _recipe.updateProductsStock();
                                          //   _isLoading = false;
                                          // });
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
                                    Center(
                                      child:
                                          LoadingAnimationWidget.halfTringleDot(
                                        color: Colors.grey,
                                        size: 200,
                                      ),
                                    ),
                                ]
                              ],
                            ),
                            actions: [
                              InkWell(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'cancel'.tr(),
                                  ),
                                ),
                                onTap: () {
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
            ),
          ],
        );
      },
    );
  }
}

class TrackInCalendar extends StatelessWidget {
  const TrackInCalendar({
    Key? key,
    required this.setState,
  }) : super(key: key);
  final StateSetter setState;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Consumer(
            builder: (_, ref, watch) {
              final _recipe = ref.watch(recipeDetailsProvider);
              return Row(
                children: [
                  Expanded(
                    child: RecipeImage(
                      recipe: _recipe.details,
                      fitWidth: false,
                      hideButtons: true,
                    ),
                  ),
                  Expanded(
                    child: RecipeTileDetails(
                      recipe: _recipe.details,
                      titleSize: 24,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(
              left: 40,
              right: 40,
              top: 8,
              bottom: 8,
            ),
            child: Column(
              children: [
                Text(
                  '${'saveToCalendar'.tr()} ?',
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                      fillColor: _calendarUpdateStatus == 'no'
                          ? Colors.red
                          : Theme.of(context).cardColor,
                      onPressed: () {
                        setState(() {
                          _calendarUpdateStatus = 'no';
                        });
                      },
                      child: Text(
                        'no'.tr(),
                        style: TextStyle(
                          color: _calendarUpdateStatus == 'no'
                              ? Colors.white
                              : Theme.of(
                                  context,
                                ).textTheme.bodyText1!.color,
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                      fillColor: _calendarUpdateStatus == 'yes'
                          ? Colors.green
                          : Theme.of(context).cardColor,
                      onPressed: () {
                        setState(() {
                          _calendarUpdateStatus = 'yes';
                        });
                      },
                      child: Text(
                        'yes'.tr(),
                        style: TextStyle(
                          color: _calendarUpdateStatus == 'yes'
                              ? Colors.white
                              : Theme.of(
                                  context,
                                ).textTheme.bodyText1!.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.only(
              left: 40,
              right: 40,
              top: 8,
              bottom: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'optionsToSave'.tr(),
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                      fillColor: _calendarSaveOption == 'cooked'
                          ? Colors.red
                          : Theme.of(context).cardColor,
                      onPressed: () {
                        setState(() {
                          _calendarSaveOption = 'cooked';
                        });
                      },
                      child: Text(
                        'cooked'.tr(),
                        style: TextStyle(
                          color: _calendarSaveOption == 'cooked'
                              ? Colors.white
                              : Theme.of(
                                  context,
                                ).textTheme.bodyText1!.color,
                        ),
                      ),
                    ),
                    RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                      fillColor: _calendarSaveOption == 'consumed'
                          ? Colors.green
                          : Theme.of(context).cardColor,
                      onPressed: () {
                        setState(() {
                          _calendarSaveOption = 'consumed';
                        });
                      },
                      child: Text(
                        'consumed'.tr(),
                        style: TextStyle(
                          color: _calendarSaveOption == 'consumed'
                              ? Colors.white
                              : Theme.of(
                                  context,
                                ).textTheme.bodyText1!.color,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class TitleRow extends StatelessWidget {
  const TitleRow({Key? key, required this.setState}) : super(key: key);
  final StateSetter setState;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: _view == 'calendar' ? 3 : 2,
          child: InkWell(
            onTap: () {
              setState(() {
                _view = 'calendar';
              });
            },
            child: Text(
              'calendar'.tr(),
              style: TextStyle(
                fontSize: _view == 'calendar' ? 28 : 15,
                fontWeight:
                    _view == 'calendar' ? FontWeight.w400 : FontWeight.normal,
              ),
            ),
          ),
        ),
        Expanded(
          flex: _view == 'ingredients' ? 3 : 2,
          child: InkWell(
            onTap: () {
              setState(() {
                _view = 'ingredients';
              });
            },
            child: Text(
              'ingredients'.tr(),
              style: TextStyle(
                fontSize: _view == 'ingredients' ? 28 : 15,
                fontWeight: _view == 'ingredients'
                    ? FontWeight.w400
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
        Expanded(
          flex: _view == 'instructions' ? 3 : 2,
          child: InkWell(
            onTap: () {
              setState(() {
                _view = 'instructions';
              });
            },
            child: Text(
              'instructions'.tr(),
              style: TextStyle(
                fontSize: _view == 'instructions' ? 28 : 15,
                fontWeight: _view == 'instructions'
                    ? FontWeight.w400
                    : FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
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
