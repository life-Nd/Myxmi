// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'package:myxmi/screens/add_recipe.dart';
// import 'package:easy_localization/easy_localization.dart';

// class ProductsCategories extends HookWidget {
//   Widget build(BuildContext context) {
//     final _recipe = useProvider(recipeProvider);
//     return SingleChildScrollView(
//       scrollDirection: Axis.horizontal,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           RawMaterialButton(
//             child: Text('cocktails'.tr()),
//             onPressed: () {},
//             fillColor: _recipe.details.subCategory == 'Cocktails'
//                 ? Colors.green
//                 : Theme.of(context).cardColor,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           ),
//           SizedBox(
//             width: 7,
//           ),
//           RawMaterialButton(
//             child: Text('smoothies'.tr()),
//             onPressed: () {},
//             fillColor: _recipe.details.subCategory == 'Smoothies'
//                 ? Colors.green
//                 : Theme.of(context).cardColor,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           ),
//           SizedBox(
//             width: 7,
//           ),
//           RawMaterialButton(
//             child: Text('shakes'.tr()),
//             onPressed: () {},
//             fillColor: _recipe.details.subCategory == 'Shakes'
//                 ? Colors.green
//                 : Theme.of(context).cardColor,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           ),
//           SizedBox(
//             width: 7,
//           ),
//           RawMaterialButton(
//             child: Text('other'.tr()),
//             onPressed: () {},
//             fillColor: _recipe.details.subCategory == 'Other'
//                 ? Colors.green
//                 : Theme.of(context).cardColor,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//           )
//         ],
//       ),
//     );
//   }
// }
