import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';

class ReasonsForCall extends StatelessWidget {
  const ReasonsForCall({
    super.key,
    required this.screen,
    required this.theme,
  });

  final Size screen;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Container(
        width: screen.width * 0.9,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Reason for call',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              lorem(paragraphs: 1, words: 30),
              style: const TextStyle(),
              textAlign: TextAlign.justify,
            )
          ],
        ),
      ),
    );
  }
}
