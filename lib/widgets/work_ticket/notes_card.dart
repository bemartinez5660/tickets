
import 'package:flutter/material.dart';

class NotesCard extends StatelessWidget {
  const NotesCard({
    super.key,
    required this.screen,
  });

  final Size screen;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius:
          const BorderRadius.all(Radius.circular(15)),
      child: Container(
        width: screen.width * 0.9,
        decoration: const BoxDecoration(
            color: Color.fromRGBO(148, 87, 235, 0.3),
            borderRadius:
                BorderRadius.all(Radius.circular(15))),
        child: Column(
          children: [
            Container(
              width: screen.width,
              height: 50,
              decoration: const BoxDecoration(
                color: Color.fromRGBO(148, 87, 235, 0.5),
              ),
              child: const Center(
                  child: Text(
                'Notes',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 17),
              )),
            ),
            Container(
                margin: const EdgeInsets.all(8),
                child: const TextField(
                  maxLines: 7,
                  decoration: InputDecoration(
                      border: InputBorder.none),
                )),
          ],
        ),
      ),
    );
  }
}
