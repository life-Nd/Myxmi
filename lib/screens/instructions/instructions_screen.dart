import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/instructions/instructions_listview.dart';
import 'package:myxmi/screens/instructions/widgets/instructions_pageview.dart';
import 'package:myxmi/screens/recipes/selected/widgets/recipe_details.dart';
import 'package:myxmi/utils/loading_column.dart';
import 'package:myxmi/utils/no_data.dart';

late String _view = 'List';

class InstructionsScreen extends StatefulWidget {
  const InstructionsScreen({Key? key}) : super(key: key);

  @override
  State<InstructionsScreen> createState() => _InstructionsScreenState();
}

class _InstructionsScreenState extends State<InstructionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, child) {
        final _recipe = ref.watch(recipeDetailsProvider);

        return Scaffold(
          appBar: AppBar(
            title: Text('instructions'.tr()),
            actions: [
              if (_view == 'List')
                IconButton(
                  icon: const Icon(Icons.view_agenda_rounded),
                  onPressed: () {
                    setState(() {
                      _view = 'List';
                    });
                  },
                )
              else
                IconButton(
                  icon: const Icon(Icons.view_week_rounded),
                  onPressed: () {
                    setState(() {
                      _view = 'Page';
                    });
                  },
                )
            ],
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Instructions')
                .doc('${_recipe.details.recipeId}')
                .snapshots(),
            builder: (
              _,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot,
            ) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingColumn();
              }
              final _doc = snapshot.data!.data();
              debugPrint('_doc: $_doc');
              if (snapshot.hasData) {
                if (_view == 'List') {
                  return InstructionsListView(
                    instructions: _doc!['steps'] as List,
                  );
                } else {
                  return InstructionsPageView(
                    instructions: _doc!['steps'] as List,
                  );
                }
              } else {
                return NoData(type: 'no_instructions'.tr());
              }
            },
          ),
        );
      },
    );
  }
}
