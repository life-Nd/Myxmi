import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String photoUrl;
  final double radius;

  const UserAvatar({Key key, @required this.photoUrl, @required this.radius})
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
              contentPadding: const EdgeInsets.all(0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              content: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InteractiveViewer(
                  child: Image.network(
                    photoUrl,
                    cacheHeight: 1000,
                    errorBuilder: (context, child, error) {
                      return const Icon(
                        Icons.person_outline,
                        size: 40,
                      );
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(44),
        child: Image.network(
          photoUrl,
          height: radius,
          width: radius,
          fit: BoxFit.fitWidth,
          
          errorBuilder: (context, child, error) {
            debugPrint('error: $error');
            return Icon(
              Icons.person_outline,
              size: radius / 2,
            );
          },
        ),
      ),
    );
  }
}
