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
            screenshot: 'screenshot',
            title: 'createRecipes',
            message: 'Create your own recipes and share them with your friends',
            imageFirst: true,
          ),
          const DemoContainer(
            screenshot: 'inspiration',
            title: 'Be inspired',
            message:
                'Try the creations of the community then see if you can add your touch.',
            imageFirst: false,
          ),
          const DemoContainer(
            screenshot: 'screenshot',
            title: 'Save all your recipes in one place',
            message:
                'Easily save recipes from any site or app to a digital recipe box, making it easy to create, organize, and share your cooking inspiration.',
            imageFirst: true,
          ),
          const DemoContainer(
            screenshot: 'reviews',
            title: 'REVIEW RECIPES',
            message:
                'Check the reviews of those who tried the recipe before and add yours too.',
            imageFirst: false,
          ),
          const DemoContainer(
            screenshot: 'pantry',
            title: 'ORGANIZE YOUR PANTRY',
            message:
                'Add ingredients to your virtual pantry. See and use them from any of your device.',
            imageFirst: true,
          ),
          const DemoContainer(
            screenshot: 'groceryList',
            title: 'CREATE YOUR GROCERY LIST',
            message:
                'With just one tap add the ingredients to your grocery list and edit your list on the go.',
            imageFirst: false,
          ),
          DownloadApp(),
          const Divider(color: Colors.grey),
        ],
      ),
    );
  }
}

class DemoContainer extends StatelessWidget {
  final String screenshot;
  final String title;
  final String message;
  final bool imageFirst;
  const DemoContainer({
    required this.screenshot,
    required this.title,
    required this.message,
    required this.imageFirst,
  });

  List<Widget> _children({required Size size}) {
    return [
      const SizedBox(width: 10),
      SizedBox(
        height: size.height * 0.9,
        width: size.width * 0.4,
        child: Image.asset('assets/$screenshot.png'),
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
              message.tr(),
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
