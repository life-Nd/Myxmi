import 'package:flutter/material.dart';
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
    _keys.sort();
    debugPrint('---Keys--$_keys');
    return ListView.builder(
      itemCount: _keys.length,
      itemBuilder: (_, int index) {
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(1),
            leading: _data[_keys[index]]['photo_url'] != null &&
                    _data[_keys[index]]['photo_url'] != 'null'
                ? UserAvatar(
                    photoUrl: '${_data[_keys[index]]['photo_url']}',
                    radius: 44,
                  )
                : const Icon(Icons.person),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text('${_data[_keys[index]]['name']}'),
                ),
                RatingStars(
                  stars: '${_data[_keys[index]]['stars']}',
                ),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${_data[_keys[index]]['message']}'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                        '${DateTime.fromMillisecondsSinceEpoch(int.parse('${_keys[index]}'))}'),
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
