import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/screens/home/home_screen.dart';

class StreamAuthBuilder extends StatefulWidget {
  const StreamAuthBuilder({
    foundation.Key? key,
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
        return StreamBuilder<User?>(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, AsyncSnapshot<User?> snapUser) {
            return Consumer(
              builder: (_, ref, child) {
                final _user = ref.watch(userProvider);
                _user.account = snapUser.data;
                return HomeScreen();
              },
            );
          },
        );
      },
    );
  }
}
