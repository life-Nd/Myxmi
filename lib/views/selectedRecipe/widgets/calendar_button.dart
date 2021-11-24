import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CalendarButton extends StatelessWidget {
  const CalendarButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return IconButton(
      icon: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(4),
        child: const Icon(Icons.calendar_today, color: Colors.black),
      ),
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            padding: const EdgeInsets.all(0),
            duration: const Duration(milliseconds: 2222),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            content: Container(
              width: _size.width,
              height: _size.height / 2,
              color: Colors.red.shade700,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        '${'mealPlanner'.tr()} ${'comingSoon'.tr()}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Text(
                      '(${'featureNotAvailable'.tr()})',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                      ),
                    ),
                  ]

                  // trailing: IconButton(
                  //     icon: const Icon(Icons.close),
                  //     onPressed: () {
                  //       ScaffoldMessenger.of(context)
                  //           .hideCurrentSnackBar();
                  // },),
                  ),
            ),
          ),
        );
      },
    );
  }
}
