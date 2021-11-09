// import 'package:flutter/material.dart';
// import 'package:myxmi/models/recipes.dart';

// class RecipeTileImage extends StatelessWidget {
//   final RecipeModel recipe;

//   const RecipeTileImage({@required this.recipe});
//   @override
//   Widget build(BuildContext context) {
//     final Size _size = MediaQuery.of(context).size;
//     return ClipRRect(
//       borderRadius: const BorderRadius.only(
//         topLeft: Radius.circular(20),
//         topRight: Radius.circular(20),
//       ),
//       child: recipe.imageUrl != null
//           ? SizedBox(
//               width: _size.width,
//               height: _size.height,
//               child: Image.network(
//                 recipe.imageUrl,
//                 fit: BoxFit.values[4],
//                 cacheWidth: 1000,
//                 cacheHeight: 1000,
//                 height: _size.height,
//                 width: _size.width,
//               ),
//             )
//           : Stack(
//               alignment: Alignment.center,
//               children: [
//                 Opacity(
//                   opacity: 0.3,
//                   child: recipe.subCategory != null
//                       ? Image.asset(
//                           'assets/${recipe.subCategory}.jpg',
//                           fit: BoxFit.fitWidth,
//                           height: _size.height,
//                           width: _size.width,
//                           cacheWidth: 1000,
//                           colorBlendMode: BlendMode.color,
//                         )
//                       : null,
//                 ),
//                 const Center(
//                   child: Icon(
//                     Icons.no_photography,
//                     color: Colors.red,
//                     size: 40,
//                   ),
//                 ),
//               ],
//             ),
//     );
//   }
// }
