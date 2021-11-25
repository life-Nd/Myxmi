import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../main.dart';

final TextEditingController _ctrl = TextEditingController();
String _experience;

class ExperienceTextfield extends StatelessWidget {
  const ExperienceTextfield({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, child) {
      final _user = watch(userProvider);

      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: _ctrl,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: '${'tellMe'.tr()} ${'more'.tr()}',
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.green,
              ),
              onPressed: () {
                sendFeedback(
                  email: _user?.account?.email,
                  uid: _user?.account?.uid,
                  experience: _experience,
                  message: _ctrl.text,
                  name: _user?.account?.displayName,
                );
                _ctrl.clear();
              },
            ),
          ),
        ),
      );
    });
  }

  Future sendFeedback(
      {@required String uid,
      @required String name,
      @required String email,
      @required String experience,
      @required String message}) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final _db = _firestore.collection('Feedback');
    await _db.doc(uid).set(
      {
        '${DateTime.now().millisecondsSinceEpoch}': {
          'uid': uid,
          'name': name,
          'email': email,
          'experience': experience,
          'message': message,
        }
      },
      SetOptions(merge: true),
    );
  }
}
