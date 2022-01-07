import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myxmi/utils/download_app.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ScrollController _ctrl = ScrollController();
    return SingleChildScrollView(
      controller: _ctrl,
      child: Column(
        children: <Widget>[
          const DemoContainer(
            title: 'createRecipes',
            imageFirst: true,
          ),
          const DemoContainer(
            title: 'beInspired',
            imageFirst: false,
          ),
          const DemoContainer(
            title: 'productScanner',
            imageFirst: true,
          ),
          const DemoContainer(
            title: 'mealPlanner',
            imageFirst: false,
          ),
          const DemoContainer(
            title: 'organizePantry',
            imageFirst: true,
          ),
          const DemoContainer(
            title: 'createGroceryList',
            imageFirst: false,
          ),
          const DemoContainer(
            title: 'reviewRecipes',
            imageFirst: true,
          ),
          DownloadApp(),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }
}

class DemoContainer extends StatelessWidget {
  final String title;
  // final String message;
  final bool imageFirst;
  const DemoContainer({
    required this.title,
    // required this.message,
    required this.imageFirst,
  });

  List<Widget> _children({required Size size}) {
    return [
      const SizedBox(width: 10),
      SizedBox(
        height: size.height * 0.9,
        width: size.width * 0.4,
        child: Image.asset('assets/$title.png'),
      ),
      const SizedBox(width: 10),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title.tr(),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            Text(
              '${title}Details'.tr(),
              style: const TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Row(
      children: imageFirst == true
          ? _children(size: _size)
          : _children(size: _size).reversed.toList(),
    );
  }
}
