import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/providers/recipe_details.dart';
import 'package:myxmi/utils/no_data.dart';
import 'package:myxmi/views/selectedRecipe/widgets/steps_listview.dart';
import 'package:myxmi/views/selectedRecipe/widgets/view_selector_text.dart';
import '../selected_recipe_view.dart';
import 'comments_view.dart';
import 'ingredients_listview.dart';

final recipeDetailsProvider =
    Provider<RecipeDetailsProvider>((_) => RecipeDetailsProvider());

class RecipeDetails extends StatefulWidget {
  final InstructionsModel instructions;
  const RecipeDetails({Key key, this.instructions}) : super(key: key);

  @override
  State<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {
  final PageController pageController = PageController();
  @override
  void initState() {
    final _view = context.read(selectedRecipeView);
    _view.pageIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final double _height = _size.height;
    return Consumer(builder: (context, watch, child) {
      final _selectedView = watch(selectedRecipeView);
      return Column(
        children: [
          _ViewsSelector(
            pageCtrl: pageController,
            ingredientsLength: widget?.instructions?.ingredients?.length,
            stepsLength: widget?.instructions?.steps?.length,
            commentsLength: widget?.instructions?.comments?.length,
          ),
          SizedBox(
            height: _height * 0.70,
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                _selectedView.changeIndex(index);
              },
              children: [
                if (widget.instructions.ingredients != null)
                  IngredientsInRecipeListView(
                      ingredients: widget.instructions.ingredients)
                else
                  const NoData(type: 'Ingredients'),
                if (widget.instructions.steps != null)
                  StepsListView(
                    steps: widget.instructions.steps,
                  )
                else
                  const NoData(type: 'Steps'),
                const CommentsView()
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _ViewsSelector extends StatelessWidget {
  final int stepsLength;
  final int ingredientsLength;
  final int commentsLength;
  final PageController pageCtrl;

  const _ViewsSelector(
      {Key key,
      @required this.stepsLength,
      @required this.ingredientsLength,
      @required this.commentsLength,
      @required this.pageCtrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ViewSelectorText(
          controller: pageCtrl,
          length: ingredientsLength ?? 0,
          viewIndex: 0,
          text: 'ingredients',
        ),
        ViewSelectorText(
          controller: pageCtrl,
          length: stepsLength ?? 0,
          viewIndex: 1,
          text: 'steps',
        ),
        Consumer(builder: (context, watch, child) {
          final _recipe = watch(recipeDetailsProvider);
          final _recipeDetails = _recipe?.details;
          return ViewSelectorText(
            controller: pageCtrl,
            length: _recipeDetails?.commentsCount != null
                ? int.parse(_recipeDetails?.commentsCount)
                : 0,
            text: 'comments',
            viewIndex: 2,
          );
        }),
      ],
    );
  }
}
