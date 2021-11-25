import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/views/home/home_view.dart';
import '../main.dart';

class StreamAuthBuilder extends StatefulWidget {
  const StreamAuthBuilder({
    foundation.Key key,
  }) : super(key: key);

  @override
  State<StreamAuthBuilder> createState() => _StreamAuthBuilderState();
}

class _StreamAuthBuilderState extends State<StreamAuthBuilder> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, watch, child) {
        final _appSources = watch(appNetworkProvider);
        _appSources.getAppNetwork(context);
        return StreamBuilder<User>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, AsyncSnapshot<User> snapUser) {
            return Consumer(
              builder: (context, watch, child) {
                final _user = watch(userProvider);
                _user.account = snapUser.data;
                return HomeView();
              },
            );
          },
        );
      },
    );
  }
}
