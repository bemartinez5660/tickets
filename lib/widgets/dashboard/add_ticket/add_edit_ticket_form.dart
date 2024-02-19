import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isu_corp_test/models/ticket.dart';
import 'package:isu_corp_test/providers/tickets.dart';
import 'package:provider/provider.dart';

class AddAndEditTicketForm extends StatefulWidget {
  const AddAndEditTicketForm({super.key, required this.ticket});
  final Ticket? ticket;

  @override
  State<AddAndEditTicketForm> createState() => _AddAndEditTicketFormState();
}

class _AddAndEditTicketFormState extends State<AddAndEditTicketForm> {
  final _form = GlobalKey<FormState>();
  late Ticket _editTicket;

  // Text Editing Controllers
  late TextEditingController addressController;
  late TextEditingController clientNameController;
  late TextEditingController dateController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();

    // If the ticket is null is an add process and all the fields are emptys but
    // if the ticket comes you have to initialize the fields at the beginning
    // through the text parameter of the TextEditingControllers
    if (widget.ticket == null) {
      addressController = TextEditingController();
      clientNameController = TextEditingController();
      dateController = TextEditingController();
      phoneController = TextEditingController();
      _editTicket = Ticket(
          clientName: '', address: '', phoneNumber: '', date: DateTime.now());
    } else {
      var format = DateFormat('MM/dd/yyyy');
      String dateString = format.format(widget.ticket!.date);
      clientNameController =
          TextEditingController(text: widget.ticket!.clientName);
      addressController = TextEditingController(text: widget.ticket!.address);
      phoneController = TextEditingController(text: widget.ticket!.phoneNumber);
      dateController = TextEditingController(text: dateString);
      _editTicket = widget.ticket as Ticket;
    }
  }

  void _saveForm() async {
    final ticketsProvider = Provider.of<Tickets>(context, listen: false);

    // Cheching the validations of the fields to continue
    if (!_form.currentState!.validate()) {
      return;
    }
    _form.currentState?.save();

    // If the ticket is null is an add process, but if isn't null is an
    // updating process
    if (widget.ticket == null) {
      ticketsProvider.addTicket(_editTicket);
    } else {
      ticketsProvider.updateTicket(_editTicket);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _form,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Client name'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                controller: clientNameController,
                onSaved: (newValue) {},
                onChanged: (newValue) {
                  _editTicket = Ticket(
                      id: _editTicket.id,
                      clientName: newValue,
                      address: _editTicket.address,
                      phoneNumber: _editTicket.phoneNumber,
                      date: _editTicket.date);
                },
                validator: (value) {
                  if (value == "") {
                    return 'You have to specify the client name.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Phone number'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                controller: phoneController,
                onSaved: (newValue) {},
                onChanged: (newValue) {
                  _editTicket = Ticket(
                      id: _editTicket.id,
                      clientName: _editTicket.clientName,
                      address: _editTicket.address,
                      phoneNumber: newValue,
                      date: _editTicket.date);
                },
                validator: (value) {
                  if (value == "") {
                    return 'You have to specify the client phone number.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Client address'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                controller: addressController,
                onSaved: (newValue) {},
                onChanged: (newValue) {
                  _editTicket = Ticket(
                      id: _editTicket.id,
                      clientName: _editTicket.clientName,
                      address: newValue,
                      phoneNumber: _editTicket.phoneNumber,
                      date: _editTicket.date);
                },
                validator: (value) {
                  if (value == "") {
                    return 'You have to specify the client address.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Date'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.text,
                controller: dateController,
                onTap: () async {
                  final resultDate = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1969),
                      lastDate: DateTime.now());
                  var format = DateFormat('MM/dd/yyyy');
                  String dateString = format.format(resultDate as DateTime);
                  dateController.text = dateString;
                  _editTicket = Ticket(
                      id: _editTicket.id,
                      clientName: _editTicket.clientName,
                      address: _editTicket.address,
                      phoneNumber: _editTicket.phoneNumber,
                      date: resultDate);
                },
                readOnly: true,
                validator: (value) {
                  if (value == "") {
                    return 'You have to specify the date.';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    _saveForm();
                  },
                  child: const Text('Save'))
            ],
          ),
        ));
  }
}
