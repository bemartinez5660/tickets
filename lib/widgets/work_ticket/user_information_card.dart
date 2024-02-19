import 'package:flutter/material.dart';
import 'package:isu_corp_test/models/ticket.dart';
import 'package:isu_corp_test/screens/directions/directions_screen.dart';

class UserInformationCard extends StatelessWidget {
  const UserInformationCard({
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
    return Material(
      elevation: 10,
      borderRadius: const BorderRadius.all(Radius.circular(24)),
      child: Container(
        width: screen.width * 0.6,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.canvasColor,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                ),
                const SizedBox(
                  width: 7,
                ),
                Flexible(
                  child: Text(
                    ticket.clientName,
                    softWrap: true,
                    style: textStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(Icons.phone_outlined),
                const SizedBox(
                  width: 7,
                ),
                Flexible(
                  child: Text(
                    ticket.phoneNumber,
                    softWrap: true,
                    textAlign: TextAlign.justify,
                    style: textStyle,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                const Icon(Icons.directions_outlined),
                const SizedBox(
                  width: 7,
                ),
                Flexible(
                  child: Text(
                    softWrap: true,
                    ticket.address,
                    style: textStyle,
                  ),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DirectionsScreen(ticket: ticket),
                      ));
                    },
                    icon: const Icon(Icons.location_on))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
