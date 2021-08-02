import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';
import 'package:myxmi/widgets/recipe_details.dart';
import 'package:myxmi/widgets/recipe_image.dart';
import 'package:myxmi/widgets/view_selector_text.dart';
import 'package:easy_localization/easy_localization.dart';

final InstructionsModel _instructions = InstructionsModel();

class SelectedRecipe extends StatefulWidget {
  final String recipeId;
  const SelectedRecipe({Key key, @required this.recipeId}) : super(key: key);
  @override
  State createState() => SelectedRecipeState();
}

class SelectedRecipeState extends State<SelectedRecipe> {
  Map<String, dynamic> _data = {};
  @override
  void initState() {
    debugPrint('RECIPE ID: ${widget.recipeId}');
    // getInstructions();
    super.initState();
  }

  // Future<InstructionsModel> getInstructions() async {
  //   final _db = FirebaseFirestore.instance
  //       .collection('Instructions')
  //       .doc(widget.recipeId);
  //   _db.snapshots().listen((event) {
  //     debugPrint('VALUE: ${event.data()}');
  //     _snapshot = event.data();
  //     _instructions.fromSnapshot(snapshot: _snapshot);
  //   });
  //   return _instructions;
  //   // get().then((value) {
  //   //   debugPrint('VALUE: ${value.data()}');
  //   //   _snapshot = value.data();
  //   //   _instructions.fromSnapshot(snapshot: _snapshot);
  //   // });
  //   // return _instructions;
  // }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, watch, child) {
          final _recipe = watch(recipeProvider);
          return Text(_recipe.recipeModel.title);
        }),
      ),
      body: Container(
        height: _size.height,
        width: _size.width,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          gradient: LinearGradient(
            begin: Alignment.center,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).cardColor,
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              RecipeImage(_size.height / 1.2),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('Instructions')
                      .doc(widget.recipeId)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      debugPrint('Loading');
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('loading'.tr()),
                          const CircularProgressIndicator(),
                        ],
                      );
                    }
                    if (snapshot.hasData && snapshot.data.data() != null) {
                      final DocumentSnapshot<Map<String, dynamic>> _snapshot =
                          snapshot.data;
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
      ),
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
