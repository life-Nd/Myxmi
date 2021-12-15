import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/instructions/instructions_listview.dart';
import 'package:myxmi/screens/instructions/widgets/instructions_pageview.dart';
import 'package:myxmi/screens/recipes/selected/widgets/recipe_details.dart';
import 'package:myxmi/utils/loading_column.dart';
import 'package:myxmi/utils/no_data.dart';

final _instructionsViewProvider =
    ChangeNotifierProvider<InstructionsViewProvider>(
  (ref) => InstructionsViewProvider(),
);

class InstructionsScreen extends StatelessWidget {
  const InstructionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('instructions'.tr()),
        actions: [
          Consumer(
            builder: (_, ref, child) {
              final _instructionsView = ref.watch(_instructionsViewProvider);
              if (_instructionsView.view == 'List') {
                return IconButton(
                  icon: const Icon(Icons.view_week_rounded),
                  onPressed: () {
                    debugPrint('Page');
                    _instructionsView.setView('Page');
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.view_agenda_rounded),
                  onPressed: () {
                    debugPrint('List');
                    _instructionsView.setView('List');
                  },
                );
              }
            },
          ),
        ],
      ),
      body: Consumer(
        builder: (_, ref, watch) {
          final _recipe = ref.watch(recipeDetailsProvider);
          return StreamBuilder(
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
                return InstructionsSelected(steps: _doc!['steps'] as List);
              } else {
                return NoData(type: 'no_instructions'.tr());
              }
            },
          );
        },
      ),
    );
  }
}

class InstructionsSelected extends StatelessWidget {
  final List steps;
  const InstructionsSelected({Key? key, required this.steps}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, watch) {
        final _instructionsView = ref.watch(_instructionsViewProvider);
        if (_instructionsView._view == 'List') {
          return InstructionsListView(
            instructions: steps,
          );
        } else {
          return InstructionsPageView(
            instructions: steps,
          );
        }
      },
    );
  }
}

class InstructionsViewProvider extends ChangeNotifier {
  String _view = 'List';
  String get view => _view;
  void setView(String value) {
    _view = value;
    notifyListeners();
  }
}
