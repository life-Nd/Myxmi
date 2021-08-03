import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myxmi/screens/home.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../main.dart';
import 'support.dart';

final TextEditingController _titleCtrl = TextEditingController();
final TextEditingController _messageCtrl = TextEditingController();

class SupportChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          ),
        ),
        title: ListTile(
          minLeadingWidth: 40,
          leading: const Icon(
            Icons.help_rounded,
            color: Colors.green,
            size: 40,
          ),
          dense: true,
          title: Text('support'.tr()),
          subtitle: Text('connected'.tr()),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('${'urQuestion?'.tr()} ?'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 2),
              child: TextField(
                controller: _titleCtrl,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'enterShortTitle'.tr(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _messageCtrl,
                maxLines: 20,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'enterMessage'.tr(),
                ),
              ),
            ),
          ],
        ),
      ),
      extendBody: true,
      bottomNavigationBar: Consumer(builder: (_, watch, __) {
        final _user = watch(userProvider);
        final _prefs = watch(prefProvider);
        final _view = watch(viewProvider);
        return Padding(
            padding: const EdgeInsets.all(8.0),
            child: _view.loading
                ? Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.bottomCenter,
                    child: const CircularProgressIndicator(color: Colors.blue))
                : RawMaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    fillColor: Colors.blue,
                    onPressed: () {
                      debugPrint('NOTEMPTY:_titleCtrl.text:${_titleCtrl.text}');
                      debugPrint(
                          'NOTEMPTY:_messageCtrl.text:${_messageCtrl.text}');
                      if (_titleCtrl.text.isNotEmpty &&
                          _messageCtrl.text.isNotEmpty) {
                        _view.loadingEntry(isLoading: true);

                        final int _now = DateTime.now().millisecondsSinceEpoch;
                        FirebaseFirestore.instance.collection('Support').add(
                          {
                            'by': _user.account.uid,
                            'message': _messageCtrl.text,
                            'title': _titleCtrl.text,
                            'answered': false,
                            'time': '$_now',
                            'name': _user.account.displayName,
                            'email': _user.account.email,
                            'avatar': _user.account.photoURL,
                            'language': _prefs.language,
                            'messagesCount': '0'
                          },
                        ).then(
                          (value) {
                            debugPrint('value: ${value.id}');
                            _titleCtrl.clear();
                            _messageCtrl.clear();
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => AlertDialog(
                                insetPadding: const EdgeInsets.all(1),
                                contentPadding: const EdgeInsets.all(1),
                                title: const Icon(
                                  Icons.check_circle_outline,
                                  size: 50,
                                  color: Colors.green,
                                ),
                                content: ListTile(
                                  title: Text('messageSent'.tr()),
                                  subtitle: Text(
                                    '${'answerWithin'.tr()} ${'hours'.tr()}',
                                  ),
                                ),
                                actions: [
                                  RawMaterialButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => SupportScreen(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'close'.tr(),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        );
                      }
                    },
                    child: Text('ask'.tr()),
                  ));
      }),
    );
  }
}

class SupportStream extends StatelessWidget {
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
                      DateTime.fromMillisecondsSinceEpoch(int.parse(_time)));

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
/*


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
*/ 