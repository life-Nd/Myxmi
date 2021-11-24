import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/feedback.dart';
import 'package:myxmi/utils/format_time.dart';

import '../../../main.dart';

class FeedbackList extends StatelessWidget {
  const FeedbackList({
    Key key,
    @required this.snapshotData,
  }) : super(key: key);
  final Map snapshotData;

  @override
  Widget build(BuildContext context) {
    final List _keys = snapshotData.keys.toList();
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _keys.length,
      itemBuilder: (_, int index) {
        FeedbackModel _feedback = const FeedbackModel();
        _feedback = FeedbackModel.fromSnapshot(
          keyIndex: _keys[index] as String,
          snapshot: snapshotData[_keys[index]] as Map<String, dynamic>,
        );
        final String _time = DateTime.fromMillisecondsSinceEpoch(
          int.parse(_feedback.messageId),
        ).toString();
        final String _formattedTime = formatTime(DateTime.parse(_time));
        return Consumer(
          builder: (_, watch, child) {
            final _user = watch(userProvider);
            final bool _isSender = _feedback.sender == _user?.account?.uid;
            return Container(
              padding:
                  const EdgeInsets.only(left: 4, right: 14, top: 5, bottom: 5),
              child: Align(
                alignment: _isSender ? Alignment.topLeft : Alignment.topRight,
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
                                borderRadius: BorderRadius.circular(20),
                                color: _isSender
                                    ? Colors.grey.shade200
                                    : Colors.blue[200]),
                            padding: const EdgeInsets.only(
                                left: 50, right: 50, top: 10, bottom: 10),
                            child: Text(
                              _feedback.message,
                              style: const TextStyle(fontSize: 15),
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
  }
}
