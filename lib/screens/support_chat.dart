import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../main.dart';

TextEditingController _messageCtrl = TextEditingController();

// ignore: must_be_immutable
class SupportChat extends HookWidget {
  Map _data = {};
  @override
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final _prefs = useProvider(prefProvider);
    final _change = useState<bool>(false);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.help_rounded,
              size: 40,
            ),
            Expanded(
              child: ListTile(
                title: Row(
                  children: [
                    const SizedBox(width: 22),
                    Text('support'.tr()),
                  ],
                ),
                subtitle: Row(
                  children: [
                    const CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.green,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      'connected'.tr(),
                    ),
                    const Text('')
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Support')
                    .doc(_user.account.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot?.data?.data() != null) {
                    _data = snapshot.data.data() as Map;
                    final List _keys = _data.keys.toList();
                    _keys.sort();
                    return ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (_, int index) {
                        final _keyIndex = '${_keys[index]}';
                        debugPrint('DATA: $_data');
                        debugPrint('KEYINDEX: $_keyIndex');
                        final String _message = '${_data['Message']}';
                        final String _by = '${_data['By']}';
                        final String _time = '${_data['Time']}';
                        // final String _avatar = '${_data['Avatar']}';
                        final String _timeAgo = timeago.format(
                            DateTime.fromMillisecondsSinceEpoch(
                                int.parse(_time)));

                        return Row(
                          mainAxisAlignment: _by == _user.account.uid
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Card(
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
                                    left: 13.0, right: 13, top: 4, bottom: 7),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          _message,
                                          style: const TextStyle(fontSize: 17),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          _timeAgo,
                                          style: const TextStyle(fontSize: 8),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                    );
                  } else {
                    return const Text('');
                  }
                }),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 7, right: 4, bottom: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: _messageCtrl,
                    onChanged: (value) {
                      _change.value = !_change.value;
                    },
                    decoration: InputDecoration(
                        hintText: 'typeMessage'.tr(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                  ),
                ),
              ),
              GestureDetector(
                onTap: _messageCtrl.text.length > 1
                    ? () {
                        final int _now = DateTime.now().millisecondsSinceEpoch;
                        FirebaseFirestore.instance
                            .collection('Support')
                            .doc(_user.account.uid)
                            .set(
                          {
                            'by': _user.account.uid,
                            'message': _messageCtrl.text,
                            'name': _user.account.displayName,
                            'email': _user.account.email,
                            'avatar': _user.account.photoURL,
                            'language': _prefs.language,
                            'time': '$_now',
                          },
                          SetOptions(merge: true),
                        );
                      }
                    : () {
                        debugPrint('Text empty');
                      },
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
