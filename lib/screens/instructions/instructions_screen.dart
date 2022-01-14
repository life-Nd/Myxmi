import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/instructions.dart';
import 'package:myxmi/screens/instructions/widgets/instructions_listview.dart';
import 'package:myxmi/screens/instructions/widgets/instructions_pageview.dart';
import 'package:myxmi/screens/recipes/selected/widgets/recipe_details.dart';
import 'package:myxmi/utils/loading_column.dart';
import 'package:myxmi/utils/no_data.dart';

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
              final _instructionsView = ref.watch(instructionsProvider);
              if (_instructionsView.view == 'List') {
                return IconButton(
                  icon: const Icon(Icons.view_week_rounded),
                  onPressed: () {
                    _instructionsView.toggleView();
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.view_agenda_rounded),
                  onPressed: () {
                    debugPrint('List');
                    _instructionsView.toggleView();
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
              final _data = snapshot.data!.data();
              debugPrint('_doc: $_data');
              final List _instructions = _data!['steps'] as List;

              if (snapshot.hasData) {
                return InstructionsWidget(instructions: _instructions);
              } else {
                return NoData(type: 'no_instructions'.tr());
              }
            },
          );
        },
      ),
      bottomNavigationBar: Consumer(
        builder: (_, ref, child) {
          final _instructions = ref.watch(instructionsProvider);
          final _pageViewIndex = _instructions.pageViewIndex;
          // final _totalPages = _instructionsView.totalPages;
          if (_instructions.view == 'Page') {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RawMaterialButton(
                  onPressed: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: IconButton(
                      onPressed: () {
                        final int _newIndex = _pageViewIndex - 1;
                        _instructions.setPageViewIndex(_newIndex);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                ),
                Text(
                  '${_pageViewIndex + 1}/${_instructions.instructions.length}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () {
                    final int _newIndex = _pageViewIndex + 1;
                    _instructions.setPageViewIndex(_newIndex);
                  },
                  child: Text(
                    'next'.tr(),
                  ),
                ),
              ],
            );
          }
          return const Text('');
        },
      ),
    );
  }
}

class InstructionsWidget extends StatelessWidget {
  final List instructions;
  const InstructionsWidget({Key? key, required this.instructions})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (_, ref, watch) {
        final _instructions = ref.watch(instructionsProvider);
        if (_instructions.view == 'List') {
          return InstructionsListView(
            instructions: instructions,
          );
        } else {
          return InstructionsPageView(
            instructions: instructions,
          );
        }
      },
    );
  }
}

// class InstructionsViewProvider extends ChangeNotifier {
//   String _view = 'List';
//   String get view => _view;
//   int pageViewIndex = 0;
//   int totalPages = 0;
  

//   void setView(String pageView) {
//     _view = pageView;
//     totalPages = totalPages;
//     notifyListeners();
//   }

//   void setPageViewIndex(int index) {
//     pageViewIndex = index;
//     notifyListeners();
//   }
// }
