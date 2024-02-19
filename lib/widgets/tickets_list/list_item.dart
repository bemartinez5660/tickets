import 'package:flutter/material.dart';
import 'package:isu_corp_test/models/ticket.dart';
import 'package:isu_corp_test/screens/work_ticket/work_ticket_screen.dart';
import 'package:isu_corp_test/providers/tickets.dart';
import 'package:isu_corp_test/widgets/dashboard/add_ticket/add_edit_ticket_modal.dart';
import 'package:provider/provider.dart';

class ListItem extends StatefulWidget {
  final Ticket ticket;
  const ListItem({super.key, required this.ticket});

  @override
  State<ListItem> createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dismissible(
      key: ValueKey(widget.ticket.id),
      background: Container(
        alignment: Alignment.centerLeft,
        color: Colors.blueAccent.shade400,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(15),
        child: Icon(Icons.edit, size: 30, color: theme.canvasColor),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        color: Colors.red.shade400,
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(15),
        child: Icon(Icons.delete, size: 30, color: theme.canvasColor),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          Provider.of<Tickets>(context, listen: false)
              .removeTicket(widget.ticket.id as int);
        }
      },
      confirmDismiss: (direction) {
        if (direction == DismissDirection.endToStart) {
          return showDialog(
              context: context,
              builder: ((context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: const Text('Yes')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: const Text('No')),
                    ],
                    content: const Text('Are you going to delete your ticket?'),
                  )));
        } else {
          return showModalBottomSheet(
            context: context,
            builder: (context) => AddAndEditTicketModal(ticket: widget.ticket),
          );
        }
      },
      child: Column(
        children: [
          InkWell(
            onTap: () {},
            highlightColor: Colors.black12,
            child: Container(
              decoration: BoxDecoration(
                  color: const Color.fromRGBO(76, 34, 141, 0.13),
                  borderRadius: BorderRadius.circular(15)),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 18),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(0),
                  title: Text(widget.ticket.clientName),
                  subtitle: Text(widget.ticket.address),
                  trailing: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromRGBO(148, 87, 235, 0.7))),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WorkTicketScreen(ticket: widget.ticket),
                            ));
                      },
                      child: Text(
                        'View ticket',
                        style: TextStyle(color: theme.canvasColor),
                      )),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
