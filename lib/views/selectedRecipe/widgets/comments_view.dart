import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/streams/comments.dart';
import 'package:myxmi/utils/no_data.dart';
import 'package:myxmi/views/home/home_view.dart';
import 'package:myxmi/views/selectedRecipe/widgets/add_comments_view.dart';
import 'package:myxmi/views/selectedRecipe/widgets/recipe_details.dart';
import '../../../../main.dart';

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
              // final List _keys =
              //     _data?.keys != null ? _data?.keys?.toList() : [];
              // _keys.sort();
              // debugPrint('---Keys--$_keys');
              return CommentsList(data: _data);
            }
            return const NoData(type: 'Comments');
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
                        builder: (_) => HomeView(),
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
