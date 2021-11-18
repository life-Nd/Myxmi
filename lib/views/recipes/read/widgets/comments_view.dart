import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/pages/add_comments.dart';
import 'package:myxmi/utils/no_data.dart';
import 'package:myxmi/utils/user_avatar.dart';
import 'package:myxmi/views/home/home_view.dart';
import '../../../../main.dart';
import 'rating_stars.dart';
import 'recipe_details.dart';

class CommentsView extends HookWidget {
  const CommentsView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _recipe = useProvider(recipeDetailsProvider);
    final _user = useProvider(userProvider);
    final _view = useProvider(homeViewProvider);

    return Stack(
      children: [
        StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Comments')
              .doc(_recipe.recipe.recipeId)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              debugPrint(
                  '--FIREBASE-- READING: Comments/${_recipe.recipe.recipeId}');
            }
            if (snapshot.hasData && snapshot.data.data() != null) {
              final Map _data = snapshot.data.data() as Map<String, dynamic>;
              final List _keys =
                  _data?.keys != null ? _data?.keys?.toList() : [];
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
            return const NoData(type: 'Reviews');
          },
        ),
        Container(
          alignment: Alignment.bottomRight,
          padding: kIsWeb ? const EdgeInsets.only(bottom: 50, right: 20) : null,
          child: FloatingActionButton(
            onPressed: _user?.account?.uid != null
                ? () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const AddComments(),
                      ),
                    );
                  }
                : () {
                    _view.view = 4;
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Home(),
                      ),
                    );
                  },
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
