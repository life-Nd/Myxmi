import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/image.dart';
import 'package:myxmi/utils/image_selector.dart';
import 'package:sizer/sizer.dart';

import '../../../main.dart';
import '../../../utils/user_avatar.dart';

class UserProfilePicture extends HookWidget {
  const UserProfilePicture({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _radius = kIsWeb && 100.w > 700 ? 100.w / 10 : 100.w / 1.5;
    final _user = useProvider(userProvider);
    final _image = useProvider(imageProvider);

    return Center(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          UserAvatar(
            photoUrl: _user?.account?.photoURL,
            radius: _radius,
          ),
          FloatingActionButton(
            mini: true,
            backgroundColor: Colors.deepOrange.shade300,
            onPressed: () {},
            child: ImageSelector(
              onComplete: () async {
                await _image.addImageToDb(context: context).then(
                  (url) async {
                    if (url != null) {
                      await _user.changeUserPhoto(
                          context: context, photoUrl: url);
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
