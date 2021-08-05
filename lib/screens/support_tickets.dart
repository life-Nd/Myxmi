import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/providers/support.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../main.dart';
import 'support_chat.dart';

final support =
    ChangeNotifierProvider<SupportProvider>((ref) => SupportProvider());

class SupportTickets extends StatelessWidget {
  final Map<String, dynamic> _data = {};
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, child) {
        final _user = watch(userProvider);
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Support')
              .orderBy('time')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState != ConnectionState.waiting &&
                snapshot.hasData) {
              for (final QueryDocumentSnapshot element in snapshot.data.docs) {
                _data[element.id] = element.data();
              }
              final List _keys = _data.keys.toList();
              _keys.sort();
              return ListView.builder(
                itemCount: _keys.length,
                itemBuilder: (_, int index) {
                  final _keyIndex = '${_keys[index]}';
                  final _dataIndex = _data[_keyIndex];
                  final String _title = '${_dataIndex['title']}';
                  final String _message = '${_dataIndex['message']}';
                  final String _by = '${_dataIndex['by']}';
                  final String _time = '${_dataIndex['time']}';
                  final String _timeAgo = timeago.format(
                    DateTime.fromMillisecondsSinceEpoch(int.parse(_time)),
                  );
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 7.0, right: 7, top: 4, bottom: 7),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topRight: _by == _user.account.uid
                              ? const Radius.circular(0.0)
                              : const Radius.circular(10.0),
                          topLeft: _by == _user.account.uid
                              ? const Radius.circular(10.0)
                              : const Radius.circular(0.0),
                          bottomRight: _by == _user.account.uid
                              ? const Radius.circular(20.0)
                              : const Radius.circular(10.0),
                          bottomLeft: _by == _user.account.uid
                              ? const Radius.circular(0.0)
                              : const Radius.circular(40.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 4.0, right: 4, top: 4, bottom: 4),
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => SupportChat(),
                              ),
                            );
                          },
                          contentPadding: const EdgeInsets.all(1),
                          title: Text(
                            _title,
                            style: const TextStyle(fontSize: 17),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_message),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    _timeAgo,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'noTicketsFound'.tr(),
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              );
            }
          },
        );
      },
    );
  }
}
