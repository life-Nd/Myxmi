import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/feedback.dart';
import '../main.dart';

final TextEditingController _ctrl = TextEditingController();
String _experience;
Map _snapshotData = {};

class FeedbackScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('feedback'.tr()),
      ),
      body: Consumer(
        builder: (_, watch, child) {
          final _user = watch(userProvider);
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Feedback')
                  .doc(_user?.account?.uid)
                  .snapshots(),
              builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.data != null) {
                  _snapshotData = snapshot.data.data() as Map<String, dynamic>;
                  final List _keys = _snapshotData.keys.toList();
                  _keys.sort();
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: _keys.length,
                    itemBuilder: (_, int index) {
                      FeedbackModel _feedback = const FeedbackModel();
                      _feedback = FeedbackModel.fromSnapshot(
                        keyIndex: _keys[index] as String,
                        snapshot:
                            _snapshotData[_keys[index]] as Map<String, dynamic>,
                      );
                      final String _time = DateTime.fromMillisecondsSinceEpoch(
                        int.parse(_feedback.messageId),
                      ).toString();
                      final String _formattedTime =
                          DateFormat('yyyy-MM-dd hh:mm a')
                              .format(DateTime.parse(_time));
                      return Consumer(
                        builder: (_, watch, child) {
                          final _user = watch(userProvider);
                          final bool _isSender =
                              _feedback.sender == _user?.account?.uid;
                          debugPrint('isSender: $_isSender');
                          return Container(
                            padding: const EdgeInsets.only(
                                left: 4, right: 14, top: 5, bottom: 5),
                            child: Align(
                              alignment: _isSender
                                  ? Alignment.topLeft
                                  : Alignment.topRight,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: _isSender
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.end,
                                    children: [
                                      if (_feedback.experience != null)
                                        if (_feedback.experience == 'amazing')
                                          const Text(
                                            '😀',
                                            style: TextStyle(
                                              fontSize: 24,
                                            ),
                                          )
                                        else if (_feedback.experience == 'okay')
                                          const Text(
                                            '🙂',
                                            style: TextStyle(
                                              fontSize: 24,
                                            ),
                                          )
                                        else
                                          const Text(
                                            '😡',
                                            style: TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                      Flexible(
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: _isSender
                                                  ? Colors.grey.shade200
                                                  : Colors.blue[200]),
                                          padding: const EdgeInsets.only(
                                              left: 50,
                                              right: 50,
                                              top: 10,
                                              bottom: 10),
                                          child: Text(
                                            _feedback.message,
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '$_formattedTime ',
                                    style: const TextStyle(fontSize: 11),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      'noFeedbacksYet'.tr(),
                    ),
                  );
                }
              });
        },
      ),
      extendBody: true,
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          ExperiencesSelector(),
          ExperienceTextfield(),
        ],
      ),
    );
  }
}

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

class ExperiencesSelector extends StatelessWidget {
  const ExperiencesSelector({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (_, StateSetter stateSetter) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          RawMaterialButton(
            fillColor: _experience == 'bad' ? Colors.white : Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            onPressed: () {
              _experience = 'bad';
              stateSetter(() {});
            },
            child: const Text(
              '😡',
              style: TextStyle(fontSize: 30),
            ),
          ),
          RawMaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            fillColor:
                _experience == 'okay' ? Colors.white : Colors.transparent,
            onPressed: () {
              _experience = 'okay';
              stateSetter(() {});
            },
            child: const Text(
              '🙂',
              style: TextStyle(fontSize: 40),
            ),
          ),
          RawMaterialButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            fillColor:
                _experience == 'amazing' ? Colors.white : Colors.transparent,
            onPressed: () {
              _experience = 'amazing';
              stateSetter(() {});
            },
            child: const Text(
              '😀',
              style: TextStyle(fontSize: 50),
            ),
          ),
        ],
      );
    });
  }
}
