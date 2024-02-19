import 'package:flutter/material.dart';

class CustomizedButton extends StatelessWidget {
  const CustomizedButton({
    super.key,
    required this.screen,
    required this.opacity,
    required this.theme,
    required this.label,
  });

  final Size screen;
  final double opacity;
  final ThemeData theme;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(24),
        splashColor: Colors.black54,
        child: Container(
          height: 50,
          width: screen.width * 0.4,
          decoration: BoxDecoration(
              color: Color.fromRGBO(148, 87, 235, opacity),
              borderRadius: BorderRadius.circular(24)),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                  color: theme.canvasColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
