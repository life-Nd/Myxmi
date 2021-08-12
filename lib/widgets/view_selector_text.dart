import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:myxmi/screens/selected_recipe.dart';

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
      final _selectedView = watch(selectedRecipeView);
      return InkWell(
        onTap: () {
          _selectedView.changePageController(viewIndex);
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  width: 4,
                  color: (_selectedView.pageController.hasClients &&
                              _selectedView.pageController.page == viewIndex) ||
                          (!_selectedView.pageController.hasClients &&
                              viewIndex == 0)
                      ? Theme.of(context).appBarTheme.titleTextStyle.color
                      : Colors.transparent),
            ),
          ),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: text.tr().toUpperCase(),
                  style: TextStyle(color: Theme.of(context).iconTheme.color),
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
