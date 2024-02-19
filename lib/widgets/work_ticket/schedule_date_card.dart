import 'package:flutter/material.dart';
import 'package:isu_corp_test/models/ticket.dart';
import 'package:intl/intl.dart';

class ScheduleDateCard extends StatelessWidget {
  const ScheduleDateCard({
    super.key,
    required this.screen,
    required this.theme,
    required this.textStyle,
    required this.ticket,
  });

  final Size screen;
  final ThemeData theme;
  final TextStyle textStyle;
  final Ticket ticket;

  @override
  Widget build(BuildContext context) {
    var format = DateFormat('MM/dd/yyyy');
    String dateString = format.format(ticket.date);
    return Material(
      elevation: 10,
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Container(
        width: screen.width * 0.3,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(148, 87, 235, 0.3),
                  borderRadius: BorderRadius.circular(15)),
              child: const Text(
                'Schedule for',
                style: TextStyle(fontWeight: FontWeight.w800),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              dateString,
              style: textStyle.copyWith(fontSize: 15),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}
