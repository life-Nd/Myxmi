import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/models/comment.dart';
import 'package:myxmi/utils/rating_stars.dart';
import 'package:myxmi/utils/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentsList extends StatelessWidget {
  const CommentsList({
    Key? key,
    required this.data,
  }) : super(key: key);

  final Map? data;

  @override
  Widget build(BuildContext context) {
    if (data != null) {
      final Map? _data = data as Map<String, dynamic>?;
      final List? _keys = _data?.keys.toList();
      return ListView.builder(
        itemCount: _keys?.length,
        shrinkWrap: true,
        itemBuilder: (_, int index) {
          final String _key = _keys![index] as String;
          final CommentModel _comment = CommentModel.fromSnapshot(
            snapshot: data![_key] as Map<String, dynamic>,
          );
          _comment.messageId = _keys[index] as String;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: const EdgeInsets.all(4),
                leading: UserAvatar(
                  photoUrl: _comment.photoUrl,
                  radius: 50,
                ),
                title: Text(_comment.name!),
                subtitle: Text(
                  timeago.format(
                    DateTime.fromMillisecondsSinceEpoch(
                      int.parse(_comment.messageId!),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                trailing: RatingStars(
                  stars: _comment.stars,
                ),
              ),
              ListTile(
                title: Text(_comment.message!),
                subtitle: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.thumb_up,
                        size: 15,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        debugPrint('Like');
                      },
                    ),
                    const Text('|'),
                    IconButton(
                      icon: const Icon(
                        Icons.thumb_down,
                        size: 15,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        debugPrint('Dislike');
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    } else {
      return Text(
        'noComments'.tr(),
      );
    }
  }
}
