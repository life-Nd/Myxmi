import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_image/firebase_image.dart';
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
            image: 'my_recipes',
            imageFirst: true,
          ),
          const DemoContainer(
            title: 'beInspired',
            image: 'favorites',
            imageFirst: false,
          ),
          const DemoContainer(
            title: 'productScanner',
            image: 'scanner',
            imageFirst: true,
          ),
          const DemoContainer(
            title: 'mealPlanner',
            image: 'planner',
            imageFirst: false,
          ),
          const DemoContainer(
            title: 'organizePantry',
            image: 'products',
            imageFirst: true,
          ),
          const DemoContainer(
            title: 'createGroceryList',
            image: 'cart',
            imageFirst: false,
          ),
          const DemoContainer(
            title: 'reviewRecipes',
            image: 'recipe',
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
  final String image;
  final bool imageFirst;
  const DemoContainer({
    required this.title,
    required this.image,
    required this.imageFirst,
  });

  List<Widget> _children({required Size size, required bool isDarkTheme}) {
    final String _image = isDarkTheme
        ? 'assets/images/${image}_dark.png'
        : 'assets/images/$image.png';
    return [
      const SizedBox(width: 10),
      SizedBox(
        height: size.height * 0.9,
        width: size.width * 0.4,
        child: Image(
          image:
              FirebaseImage('gs://myxmi-94982.appspot.com/images/$_image.png'),
        ),
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
    final _isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: imageFirst == true
          ? _children(size: _size, isDarkTheme: _isDarkTheme)
          : _children(size: _size, isDarkTheme: _isDarkTheme).reversed.toList(),
    );
  }
}
