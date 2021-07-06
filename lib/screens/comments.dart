// import 'package:myxmi/main.dart';
// import 'package:myxmi/widgets/change_score.dart';
// import 'package:myxmi/widgets/comments.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
// import 'home.dart';
// import 'package:easy_localization/easy_localization.dart';

// TextEditingController _commentCtrl = TextEditingController();

// class CommentsScreen extends HookWidget {
//   CommentsScreen({this.indexData, this.keyIndex});
//   final Map indexData;
//   final String keyIndex;
//   Widget build(BuildContext context) {
//     final _user = useProvider(userProvider);
//     final _view = useProvider(viewProvider);
//     final Map _indexComments = indexData['Comments'];
//     final List _commentsKeys = _indexComments.keys.toList();
//     return Scaffold(
//       appBar: AppBar(
//         leading: _view.view == 0
//             ? Icon(Icons.public)
//             : _view.view == 1
//                 ? Icon(Icons.my_library_books)
//                 : _view.view == 2
//                     ? Icon(Icons.my_library_books)
//                     : Icon(Icons.help),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text('${indexData['Name']}'),
//             Text(' #${indexData['Reference']}'),
//             GestureDetector(
//               child: CircleAvatar(
//                 backgroundColor: double.parse('${indexData['Score']}') < 5.0
//                     ? Colors.red
//                     : Colors.green,
//                 child: Text(
//                   '${indexData['Score']}',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               onTap: () {
//                 changeScore(context: context);
//               },
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//               child: Comments(
//                   indexComments: _indexComments, commentsKeys: _commentsKeys)),
//           Padding(
//             padding: const EdgeInsets.only(left: 4.0, bottom: 4.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     keyboardType: TextInputType.multiline,
//                     maxLines: null,
//                     controller: _commentCtrl,
//                     decoration: InputDecoration(
//                       hintText: 'typeComment'.tr(),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(
//                     Icons.send,
//                     color: Colors.green,
//                   ),
//                   onPressed: () {
//                     print("KEYINDEX: $keyIndex");
//                     FirebaseFirestore.instance
//                         .collection('Recipes')
//                         .doc('$keyIndex')
//                         .collection('Comments')
//                         .add({
//                       'Avatar': '${_user.account.photoURL}',
//                       'Name': '${_user.account.displayName}',
//                       'Text': '${_commentCtrl.text}',
//                       'Time': '${DateTime.now().millisecondsSinceEpoch}',
//                       'Uid': '${_user.account.uid}'
//                     }).whenComplete(() {
//                       _commentCtrl.clear();
//                     });
//                   },
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
