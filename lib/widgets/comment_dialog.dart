// import 'package:agati/screens/home.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'comments.dart';

// TextEditingController _commentCtrl = TextEditingController();

// Future<dynamic> commentDialog(
//     BuildContext context, Size _size, Map indexData, String keyIndex) {
//   final Map _indexComments = indexData['Comments'];
//   final List _commentsKeys = _indexComments.keys.toList();
//   return showDialog(
//     context: context,
//     builder: (_) {
//       return AlertDialog(
//         actionsPadding: EdgeInsets.all(1),
//         insetPadding: EdgeInsets.all(20),
//         contentPadding: EdgeInsets.all(1),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
//                 // changeScore(context);
//               },
//             ),
//           ],
//         ),
//         content: Comments(
//             indexComments: _indexComments, commentsKeys: _commentsKeys),
//         actions: [
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   keyboardType: TextInputType.multiline,
//                   maxLines: null,
//                   controller: _commentCtrl,
//                   decoration: InputDecoration(
//                     hintText: 'Type a comment',
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(
//                   Icons.send,
//                   color: Colors.green,
//                 ),
//                 onPressed: () {
//                     FirebaseFirestore.instance
//                       .collection('Vape')
//                       .doc('Recipes')
//                       .set({
//                     '$keyIndex': {
//                       'Comments': {
//                         '${DateTime.now().millisecondsSinceEpoch}':
//                             '${_commentCtrl.text.trim()}'
//                       }
//                     }
//                   }, SetOptions(merge: true)).whenComplete(() {
//                     _commentCtrl.clear();
//                     Navigator.of(context).pushAndRemoveUntil(
//                         MaterialPageRoute(
//                           builder: (_) => Home(),
//                         ),
//                         (route) => false);
//                   });
//                 },
//               )
//             ],
//           ),
//         ],
//       );
//     },
//   );
// }
