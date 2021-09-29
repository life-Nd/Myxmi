import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String photoURL;
  final double radius;

  const UserAvatar({Key key, @required this.photoURL, @required this.radius})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: photoURL,
      child: CircleAvatar(
        radius: radius,
        foregroundImage: NetworkImage(photoURL),
      ),
    );
  }
}
