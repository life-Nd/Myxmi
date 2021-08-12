import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/models/recipes.dart';
import 'package:myxmi/widgets/recipe_details.dart';
import 'package:myxmi/widgets/recipe_image.dart';
import 'package:myxmi/widgets/view_selector_text.dart';
import 'package:easy_localization/easy_localization.dart';

final InstructionsModel _instructions = InstructionsModel();

class SelectedRecipe extends StatefulWidget {
  final RecipeModel recipeModel;

  const SelectedRecipe({Key key, @required this.recipeModel}) : super(key: key);
  @override
  State<StatefulWidget> createState() => _SelectionRecipeState();
}

class _SelectionRecipeState extends State<SelectedRecipe> {
  Map<String, dynamic> _data = {};
  @override
  Widget build(BuildContext context) {
    debugPrint('building _selectionRecipe');
    final Size _size = MediaQuery.of(context).size;
    return Consumer(
      builder: (_, watch, __) {
        return Scaffold(
          // appBar: AppBar(
          //   title: Consumer(builder: (context, watch, child) {
          //     return Text(widget.recipeModel.title);
          //   }),
          // ),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                floating: true,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                title: Consumer(
                  builder: (context, watch, child) {
                    return Text(widget.recipeModel.title);
                  },
                ),
                flexibleSpace: RecipeImage(
                  _size.height / 1.4,
                ),
                expandedHeight: _size.height / 1.6,
              ),
              SliverList(
                delegate: SliverChildListDelegate.fixed(
                  [
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                        stream: FirebaseFirestore.instance
                            .collection('Instructions')
                            .doc(widget.recipeModel.recipeId)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<
                                    DocumentSnapshot<Map<String, dynamic>>>
                                snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            debugPrint('Loading');
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('loading'.tr()),
                                const CircularProgressIndicator(),
                              ],
                            );
                          }
                          if (snapshot.hasData &&
                              snapshot.data.data() != null) {
                            final DocumentSnapshot<Map<String, dynamic>>
                                _snapshot = snapshot.data;
                            _data = _snapshot.data();
                            _instructions.fromSnapshot(snapshot: _data);
                          }

                          return Column(
                            children: [
                              _ViewsSelector(
                                instructions: _instructions,
                              ),
                              SizedBox(
                                height: _size.height / 2,
                                child: RecipeDetails(
                                  instructions: _instructions,
                                ),
                              ),
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewsSelector extends StatelessWidget {
  final InstructionsModel instructions;

  const _ViewsSelector({Key key, this.instructions}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ViewSelectorText(
          length: instructions?.ingredients?.length ?? 0,
          viewIndex: 0,
          text: 'ingredients',
        ),
        ViewSelectorText(
          length: instructions?.steps?.length ?? 0,
          viewIndex: 1,
          text: 'steps',
        ),
        ViewSelectorText(
          length: instructions?.reviews?.length ?? 0,
          text: 'reviews',
          viewIndex: 2,
        ),
      ],
    );
  }
}
