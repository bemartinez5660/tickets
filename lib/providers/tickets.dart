import 'package:flutter/material.dart';
import 'package:isu_corp_test/models/ticket.dart';
import 'package:isu_corp_test/services/database/database_helper.dart';

// Provider to keep the interface updated when there are changes to the ticket
// list
class Tickets with ChangeNotifier {
  final List<Ticket> _ticketsList = [];
  DatabaseHelper dbHelper = DatabaseHelper();

  // Getter for the ticket list
  List<Ticket> get tickets {
    return [..._ticketsList];
  }

  // Method to initialize the ticketList
  Future initTicketList() async {
    List<Map<String, dynamic>> dataList = await dbHelper.getData();
    // dataList.forEach((element) {
    //   print(element);
    // });
    _ticketsList.clear();
    for (var ticket in dataList) {
      _ticketsList.add(Ticket.fromJson(ticket));
    }
    notifyListeners();
  }

  // Method to add a ticket to the list and the database
  Future addTicket(Ticket ticket) async {
    _ticketsList.add(ticket);
    dbHelper.insertData(ticket.toJson());
    notifyListeners();
  }

  // Method to remove a ticket from database and the list
  Future removeTicket(int id) async {
    _ticketsList.removeWhere((ticket) => ticket.id == id);
    dbHelper.deleteData(id);
    notifyListeners();
  }

  // Method for update in the database and the list of the selected ticket with 
  // the new changes coming from the view
  Future updateTicket(Ticket ticket) async {
    int index = _ticketsList
        .indexOf(_ticketsList.firstWhere((element) => element.id == ticket.id));
    _ticketsList.removeAt(index);
    _ticketsList.insert(index, ticket);
        dbHelper.updateData(ticket.id as int, ticket.toJson());
    notifyListeners();
  }
}
