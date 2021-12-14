import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String? photoUrl;
  final double radius;

  const UserAvatar({Key? key, required this.photoUrl, required this.radius})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InteractiveViewer(
                  child: _image(fullSize: true),
                ),
              ),
            );
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(44),
        child: _image(fullSize: false),
      ),
    );
  }

  Widget _image({required bool fullSize}) {
    return Image.network(
      photoUrl!,
      height: fullSize ? null : radius,
      width: fullSize ? null : radius,
      fit: BoxFit.fitWidth,
      cacheHeight: 1000,
      cacheWidth: 1000,
      errorBuilder: (context, child, error) {
        debugPrint('error: $error');
        return Icon(
          Icons.person_outline,
          size: radius / 2,
        );
      },
    );
  }
}
