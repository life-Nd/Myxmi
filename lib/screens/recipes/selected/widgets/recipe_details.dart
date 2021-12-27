import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/providers/recipe_details.dart';
import 'package:myxmi/screens/recipes/selected/comments.dart';
import 'package:myxmi/screens/recipes/selected/selected_recipe_view.dart';
import 'package:myxmi/screens/recipes/selected/widgets/add_comments_view.dart';
import 'package:myxmi/screens/recipes/selected/widgets/ingredients_listview.dart';
import 'package:myxmi/utils/no_data.dart';

final recipeDetailsProvider = ChangeNotifierProvider<RecipeDetailsProvider>(
  (_) => RecipeDetailsProvider(),
);

class RecipeDetails extends ConsumerStatefulWidget {
  final Map? ingredients;
  final Map? comments;
  const RecipeDetails({
    Key? key,
    required this.ingredients,
    required this.comments,
  }) : super(key: key);

  @override
  ConsumerState<RecipeDetails> createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends ConsumerState<RecipeDetails> {
  final PageController pageController = PageController();
  @override
  void initState() {
    final _view = ref.read(selectedRecipeView);
    _view.pageIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('RecipeDetails build');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4, left: 4),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: 'ingredients'.tr().toUpperCase(),
                  style: TextStyle(
                    color: Theme.of(context).iconTheme.color,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                WidgetSpan(
                  child: Transform.translate(
                    offset: const Offset(0.0, -9.0),
                    child: Text(
                      '${widget.ingredients?.length}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.ingredients != null) ...[
          IngredientsInRecipeListView(
            ingredients: widget.ingredients,
          ),
          AddComments(
            commentsCount: widget.comments?.length,
          ),
          if (widget.comments != null) ...[
            CommentsList(data: widget.comments),
            Container(
              width: double.infinity,
              color: Theme.of(context).cardColor,
              child: RawMaterialButton(
                onPressed: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.comments!.isNotEmpty)
                      Text(
                        '${'load'.tr()} ${widget.comments!.length} ${'more'} ${'comment'.tr()}',
                      ),
                    if (widget.comments!.length > 1) const Text('s'),
                  ],
                ),
              ),
            ),
          ] else
            Center(
              child: Text(
                'noComments'.tr(),
                style: const TextStyle(fontSize: 18),
              ),
            ),
        ] else
          const NoData(type: 'Ingredients'),
      ],
    );
  }
}
