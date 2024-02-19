import 'package:flutter/material.dart';
import 'package:isu_corp_test/models/ticket.dart';
import 'package:isu_corp_test/widgets/dashboard/add_ticket/add_edit_ticket_form.dart';

class AddAndEditTicketModal extends StatelessWidget {
  const AddAndEditTicketModal({super.key, this.ticket});
  final Ticket? ticket;

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        // Allows to close the keyboard when the user tap out the field
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: AnimatedPadding(
        // Adjust the padding of BottomSheet when the keyboard is active
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        duration: const Duration(milliseconds: 100),
        curve: Curves.decelerate,
        child: SingleChildScrollView(
          child: SizedBox(
            height: screen.height * 0.6,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Text(
                        ticket == null ? 'Add new ticket' : 'Edit ticket',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.close))
                    ],
                  ),
                  const Divider(color: Colors.grey),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AddAndEditTicketForm(ticket: ticket),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
