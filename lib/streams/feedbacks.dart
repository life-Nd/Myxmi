import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/utils/loading_column.dart';
import 'package:myxmi/views/feedback/widgets/feedback_list.dart';
import '../main.dart';

Map _snapshotData = {};

class StreamFeedbackBuilder extends HookWidget {
  const StreamFeedbackBuilder({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Feedback')
            .doc(_user?.account?.uid)
            .snapshots(),
        builder: (_, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            debugPrint('--FIREBASE-- READING: Feedback/${_user?.account?.uid}');
            return const LoadingColumn();
          }
          if (snapshot.data != null) {
            _snapshotData = snapshot.data.data() as Map<String, dynamic>;
            final List _keys = _snapshotData.keys.toList();
            _keys.sort();
            return FeedbackList(snapshotData: _snapshotData);
          } else {
            return Center(
              child: Text(
                'noFeedbacksYet'.tr(),
              ),
            );
          }
        });
  }
}
