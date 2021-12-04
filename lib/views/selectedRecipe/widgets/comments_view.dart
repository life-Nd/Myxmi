import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/streams/comments.dart';
import 'package:myxmi/utils/no_data.dart';
import 'package:myxmi/views/home/home_view.dart';
import 'package:myxmi/views/selectedRecipe/widgets/add_comments_view.dart';
import '../../../../main.dart';

class CommentsView extends HookWidget {
  final Map data;
  const CommentsView({Key key, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _user = useProvider(userProvider);
    final _view = useProvider(homeViewProvider);

    return Stack(
      children: [
        if (data.keys != null)
          CommentsList(data: data)
        else
          const NoData(type: 'Comments'),
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
