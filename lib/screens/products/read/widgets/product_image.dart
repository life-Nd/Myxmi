import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/image.dart';
import 'package:myxmi/providers/user.dart';
import 'package:myxmi/utils/image_selector.dart';
import 'package:myxmi/utils/user_avatar.dart';

class EditableProductImage extends HookWidget {
  const EditableProductImage({Key? key, required this.photoUrl, this.id})
      : super(key: key);
  final String photoUrl;
  final String? id;
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _image = ref.watch(imageProvider);
        final _user = ref.watch(userProvider);

        return Center(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              UserAvatar(
                photoUrl: photoUrl,
                radius: 150,
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
                          await FirebaseFirestore.instance
                              .collection('Products')
                              .doc(_user.account!.uid)
                              .update(
                            {
                              '$id.imageUrl': url,
                            },
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
