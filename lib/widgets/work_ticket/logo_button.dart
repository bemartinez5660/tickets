
import 'package:flutter/material.dart';

class LogoButton extends StatelessWidget {
  const LogoButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          splashColor: Colors.black,
          borderRadius: BorderRadius.circular(90),
          onTap: () {},
          child: Material(
            borderRadius: BorderRadius.circular(90),
            elevation: 10,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(90),
              child: Image.asset(
                'assets/images/logo.jpg',
                width: 90,
                height: 90,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
