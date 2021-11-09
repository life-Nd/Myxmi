import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/models/instructions.dart';
import 'package:myxmi/providers/recipe_details.dart';
import 'package:myxmi/screens/selected_recipe.dart';
import 'package:sizer/sizer.dart';
import 'comments_view.dart';
import 'ingredients_listview.dart';
import 'no_details.dart';
import 'steps_listview.dart';
import 'view_selector_text.dart';

final recipeDetailsProvider = ChangeNotifierProvider<RecipeDetailsProvider>(
    (_) => RecipeDetailsProvider());

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
    debugPrint('building RecipeDetails');
    return Consumer(builder: (context, watch, child) {
      final _selectedView = watch(selectedRecipeView);
      return Column(
        children: [
          _ViewsSelector(
            pageCtrl: pageController,
            ingredientsLength: widget?.instructions?.ingredients?.length,
            stepsLength: widget?.instructions?.steps?.length,
            reviewsLength: widget?.instructions?.reviews?.length,
          ),
          SizedBox(
            height: 70.h,
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
                  const NoDetails('noIngredients'),
                if (widget.instructions.steps != null)
                  StepsListView(
                    steps: widget.instructions.steps,
                  )
                else
                  const NoDetails('noSteps'),
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
  final int reviewsLength;
  final PageController pageCtrl;

  const _ViewsSelector(
      {Key key,
      @required this.stepsLength,
      @required this.ingredientsLength,
      @required this.reviewsLength,
      @required this.pageCtrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    debugPrint('building _viewselector');
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
        ViewSelectorText(
          controller: pageCtrl,
          length: reviewsLength ?? 0,
          text: 'comments',
          viewIndex: 2,
        ),
      ],
    );
  }
}
