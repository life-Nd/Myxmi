import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/recipe.dart';
import 'package:myxmi/providers/home_screen.dart';
import 'package:myxmi/providers/router.dart';
import 'package:myxmi/providers/user.dart';

class CalendarButton extends StatelessWidget {
  final RecipeModel recipe;
  final Widget childRecipe;
  const CalendarButton({
    Key? key,
    required this.recipe,
    required this.childRecipe,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _user = ref.watch(userProvider);
        final _router = ref.watch(routerProvider);
        final _uid = _user.account?.uid;
        final _view = ref.watch(homeScreenProvider);
        return InkWell(
          onTap: _uid != null
              ? () {
                  // _router.pushPage(
                  //   name: '/calendar',
                  //   arguments: {
                  //     'uid': _uid,
                  //   },
                  // );
                }
              : () {
                  _view.changeView(index: 5);
                  _router.pushPage(name: '/home');
                },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(4),
            child: const Icon(
              Icons.calendar_today_rounded,
              color: Colors.black,
              size: 25,
            ),
          ),
        );
      },
    );
  }
}
          //   final DateTime _now = DateTime.now();
          //   final DateTimeRange _dates = await showDateRangePicker(
          //     context: context,
          //     firstDate: _now,
          //     lastDate: _now.add(const Duration(days: 60)),
          //     builder: (BuildContext context, Widget child) {
          //       return Padding(
          //         padding: const EdgeInsets.only(top: 50.0),
          //         child: Container(
          //           padding: const EdgeInsets.all(10),
          //           margin: const EdgeInsets.all(10),
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(20),
          //             color: Theme.of(context).scaffoldBackgroundColor,
          //           ),
          //           child: SingleChildScrollView(
          //             child: StatefulBuilder(
          //               builder: (_, StateSetter stateSetter) {
          //                 return Column(
          //                   children: [
          //                     SizedBox(
          //                       height:
          //                           MediaQuery.of(context).size.height / 2.5,
          //                       child: childRecipe,
          //                     ),
          //                     Card(
          //                       child: Padding(
          //                         padding: const EdgeInsets.all(10.0),
          //                         child: Column(
          //                           children: [
          //                             Text(
          //                               recipe.title.toUpperCase(),
          //                               style: const TextStyle(
          //                                 fontSize: 20,
          //                                 fontWeight: FontWeight.bold,
          //                               ),
          //                             ),
          //                             Padding(
          //                               padding: const EdgeInsets.all(8.0),
          //                               child: Text(
          //                                 '${'chooseRecipeType'.tr()} ',
          //                                 style: const TextStyle(
          //                                   fontSize: 17,
          //                                 ),
          //                               ),
          //                             ),
          //                             const RecipeTypeSelector(),
          //                             Row(
          //                               mainAxisAlignment:
          //                                   MainAxisAlignment.center,
          //                               children: [
          //                                 SizedBox(
          //                                   width: double.infinity,
          //                                   height: 150,
          //                                   child: createInlinePicker(
          //                                     onChange: (time) {
          //                                       _calendar.time = time;
          //                                     },
          //                                     value: _calendar.time,
          //                                     displayHeader: false,
          //                                   ),
          //                                 ),
          //                               ],
          //                             ),
          //                             Padding(
          //                               padding: const EdgeInsets.all(8.0),
          //                               child: Text(
          //                                 '${'chooseDate'.tr()} ',
          //                                 style: const TextStyle(
          //                                   fontSize: 17,
          //                                 ),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ),
          //                     SizedBox(
          //                       height:
          //                           MediaQuery.of(context).size.height / 1.5,
          //                       width: double.infinity,
          //                       child: child,
          //                     ),
          //                   ],
          //                 );
          //               },
          //             ),
          //           ),
          //         ),
          //       );
          //     },
          //   );

          //   if (_dates != null) {
          //     final Map _datesMap = {};
          //     debugPrint('_dates: ${_dates.duration.inDays} $_dates');
          //     final Map _months = {};
          //     for (int i = 0; i <= _dates.duration.inDays; i++) {
          //       final DateTime _date = _dates.start.add(Duration(days: i));
          //       debugPrint('$_date');

          //       _datesMap['${_date.millisecondsSinceEpoch}'] =
          //           '${_date.year}-${_date.month}';
          //     }
          //     _datesMap.forEach((key, value) {
          //       debugPrint('key: $key value: $value');
          //       _months[value] = _months[value] == null
          //           ? {'$key': true}
          //           : {..._months[value], key: true};
          //     },);
          //     debugPrint('_months: $_months');

          //     for (final _monthKey in _months.keys) {
          //       final _nowMilliseconds = DateTime.now();
          //       // debugPrint(
          //       //     'YEAR-MONTH $_monthKey 🚧  ${_months[_monthKey].keys.toList().length} \n 🚀 ${_months[_monthKey]} 🚀');

          //       final _db = FirebaseFirestore.instance
          //           .collection('Calendar')
          //           .doc('${_user.account.uid}-$_monthKey');
          //       _db.set({
          //         '${_nowMilliseconds.millisecondsSinceEpoch}': {
          //           'dates': _months[_monthKey],
          //           'imageUrl': recipe.imageUrl,
          //           'title': recipe.title,
          //           'recipeId': recipe.recipeId,
          //           'type': _calendar.recipeType,
          //         }
          //       }, SetOptions(merge: true));
          //     }
          //     _calendar.recipeType = null;
          //   }
   
