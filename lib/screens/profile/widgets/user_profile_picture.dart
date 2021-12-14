import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/image.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/utils/image_selector.dart';
import 'package:myxmi/utils/user_avatar.dart';

class UserProfilePicture extends HookWidget {
  const UserProfilePicture({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final double _width = _size.width;
    final double _radius = kIsWeb && _width > 700 ? _width / 10 : _width / 1.5;

    return Consumer(
      builder: (_, ref, child) {
        final _user = ref.watch(userProvider);
        final _image = ref.watch(imageProvider);
        return Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              UserAvatar(
                photoUrl: _user.account?.photoURL,
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
                            context: context,
                            photoUrl: url,
                          );
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
