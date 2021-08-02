import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/add_recipe_infos.dart';

class ViewSelectorText extends StatelessWidget {
  final String text;
  final int viewIndex;
  final int length;
  const ViewSelectorText({
    @required this.text,
    @required this.length,
    @required this.viewIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, watch, child) {
      final _recipe = watch(recipeProvider);
      return InkWell(
        onTap: () {
          _recipe.changePageController(viewIndex);
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  width: 4,
                  color: (_recipe.pageController.hasClients &&
                              _recipe.pageController.page == viewIndex) ||
                          (!_recipe.pageController.hasClients && viewIndex == 0)
                      ? Theme.of(context).appBarTheme.titleTextStyle.color
                      : Colors.transparent),
            ),
          ),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: text.tr().toUpperCase(),
                ),
                WidgetSpan(
                  child: Transform.translate(
                    offset: const Offset(0.0, -9.0),
                    child: Text(
                      '$length',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
