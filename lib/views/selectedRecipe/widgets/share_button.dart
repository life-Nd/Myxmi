import 'package:flutter/material.dart';

class ShareButton extends StatelessWidget {
  const ShareButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(4),
        child: const Icon(Icons.share, color: Colors.black),
      ),
      onPressed: () {},
    );
  }
}
