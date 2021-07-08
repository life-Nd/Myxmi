import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../app.dart';
import '../main.dart';

class SupportScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('support'.tr()),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(8),
                  hintText: 'title'.tr(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            Container(
              height: _size.height / 1.4,
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border:
                    Border.all(color: Theme.of(context).cardColor, width: 2),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(4),
                    hintText: 'message'.tr(),
                    border: InputBorder.none),
              ),
            ),
            RawMaterialButton(
              fillColor: Colors.green,
              onPressed: () {},
              child: Text('send'.tr()),
            )
          ],
        ),
      ),
    );
  }
}

TextEditingController _messageCtrl = TextEditingController();

// ignore: must_be_immutable
class SupportView extends HookWidget {
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
                      itemCount: _keys.length,
                      itemBuilder: (_, int index) {
                        final String _keyIndex = "${_keys[index]}";
                        final String _message =
                            '${_data[_keyIndex]['Message']}';
                        final String _by = '${_data[_keyIndex]['By']}';
                        debugPrint("BY: $_by");
                        final String _time = '${_data[_keyIndex]['Time']}';
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
                            'By': _user.account.uid,
                            'Message': _messageCtrl.text,
                            'Name': _user.account.displayName,
                            'Email': _user.account.email,
                            'Avatar': _user.account.photoURL,
                            'Language': _prefs.language,
                            'Time': '$_now',
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
