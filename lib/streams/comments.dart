import 'package:flutter/material.dart';
import 'package:myxmi/models/comment.dart';
import 'package:myxmi/utils/rating_stars.dart';
import 'package:myxmi/utils/user_avatar.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({
    Key key,
    @required this.data,
  }) : super(key: key);

  final Map data;

  @override
  Widget build(BuildContext context) {
    final Map _data = data as Map<String, dynamic>;
    final List _keys = _data?.keys != null ? _data?.keys?.toList() : [];
    // _keys.sort();
    debugPrint('---Keys--$_keys');
    return ListView.builder(
      itemCount: _keys.length,
      itemBuilder: (_, int index) {
        debugPrint('data[_keys[index]] :${data[_keys[index]]}');
        final CommentModel _comment = CommentModel.fromSnapshot(
            snapshot: data[_keys[index]] as Map<String, dynamic>);
        _comment.messageId = _keys[index] as String;
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(4),
            leading: _comment?.photoUrl != null && _comment.photoUrl != 'null'
                ? UserAvatar(
                    photoUrl: _comment.photoUrl,
                    radius: 50,
                  )
                : const Icon(Icons.person),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(_comment.name),
                ),
                RatingStars(
                  stars: _comment.stars,
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_comment.message),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                        '${DateTime.fromMillisecondsSinceEpoch(int.parse(_comment.messageId))}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
