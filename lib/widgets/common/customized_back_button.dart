import 'package:flutter/material.dart';

class CustomizedBackButton extends StatelessWidget {
  const CustomizedBackButton({
    super.key,
    required this.theme,
  });

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Container(
        height: 55,
        width: 55,
        alignment: Alignment.center,
        child: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: theme.canvasColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Icon(
                    Icons.arrow_back_ios,
                    size: 30,
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
