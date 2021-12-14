// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import '../selected_recipe_view.dart';

// class ViewSelectorText extends StatefulWidget {
//   final String text;
//   final int viewIndex;
//   final int length;
//   final PageController controller;
//   const ViewSelectorText(
//       {@required this.text,
//       @required this.length,
//       @required this.viewIndex,
//       @required this.controller},);

//   @override
//   State<ViewSelectorText> createState() => _ViewSelectorTextState();
// }

// class _ViewSelectorTextState extends State<ViewSelectorText> {
//   @override
//   Widget build(BuildContext context) {
//     return Consumer(
//       builder: (_, watch, child) {
//         final _selectedView = watch(selectedRecipeView);
//         return InkWell(
//           onTap: () {
//             setState(() {
//               widget.controller.jumpToPage(widget.viewIndex);
//             },);
//           },
//           child: Container(
//             padding:
//                 const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
//             decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(
//                     width: 4,
//                     color: _selectedView.pageIndex == widget.viewIndex
//                         ? Theme.of(context).appBarTheme.titleTextStyle.color
//                         : Colors.transparent),
//               ),
//             ),
//             child: RichText(
//               text: TextSpan(
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                 ),
//                 children: [
//                   TextSpan(
//                     text: widget.text.tr().toUpperCase(),
//                     style: TextStyle(color: Theme.of(context).iconTheme.color),
//                   ),
//                   WidgetSpan(
//                     child: Transform.translate(
//                       offset: const Offset(0.0, -9.0),
//                       child: Text(
//                         '${widget.length}',
//                         style: const TextStyle(
//                             fontSize: 14, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
