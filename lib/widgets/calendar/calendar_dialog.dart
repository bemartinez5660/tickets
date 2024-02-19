// ignore_for_file: library_private_types_in_public_api, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:isu_corp_test/models/ticket.dart';
import 'package:isu_corp_test/services/database/database_helper.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarDialog extends StatefulWidget {
  const CalendarDialog({super.key, required this.screen});
  final Size screen;

  @override
  _CalendarDialogState createState() => _CalendarDialogState();
}

class _CalendarDialogState extends State<CalendarDialog> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Helper to access the database
  DatabaseHelper dbHelper = DatabaseHelper();

  // List of tickets
  List<Ticket> tickets = [];

  // Flags
  bool flag = true;

  // Futures
  var dataFuture;

  @override
  void initState() {
    super.initState();
    // Getting the data from database in a future
    dataFuture = dbHelper.getData();
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    return AlertDialog(
      content: FutureBuilder<List<Map<String, dynamic>>>(
        future: dataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // A flag so that it only initializes the tickets once
            if (flag) {
              flag = false;
              for (var ticket
                  in (snapshot.data as List<Map<String, dynamic>>)) {
                tickets.add(Ticket.fromJson(ticket));
              }
            }
            return SizedBox(
              width: widget.screen.width,
              height: 450,
              child: TableCalendar(
                firstDay: DateTime.utc(1960, 04, 10),
                lastDay: DateTime.now(),
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                headerStyle: const HeaderStyle(
                  titleCentered: true,
                  formatButtonVisible:
                      false, // Hide the format button
                  leftChevronIcon: Icon(Icons.chevron_left),
                  rightChevronIcon: Icon(Icons.chevron_right),
                  titleTextStyle: TextStyle(fontSize: 18),
                  headerPadding:
                      EdgeInsets.only(bottom: 8), // Adjust the bottom space
                ),
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                  showEventsForSelectedDay(selectedDay, screen);
                },
                eventLoader: (day) {
                  // Filter and return the selected day tickets
                  return tickets
                      .where((ticket) => isSameDay(ticket.date, day))
                      .map((ticket) => ticket.clientName)
                      .toList();
                },
                daysOfWeekStyle: const DaysOfWeekStyle(
                  weekdayStyle: TextStyle(color: Colors.black),
                  weekendStyle: TextStyle(color: Colors.red),
                ),
                calendarStyle: CalendarStyle(
                  selectedDecoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  todayDecoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  markersMaxCount: 1,
                ),
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void showEventsForSelectedDay(DateTime? selectedDay, Size screen) {
    // Show the events for selected day
    if (selectedDay != null) {
      List<Ticket> eventsForSelectedDay = tickets
          .where((ticket) => isSameDay(ticket.date, selectedDay))
          .toList();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Tickets for: \n ${selectedDay.day}/${selectedDay.month}/${selectedDay.year}",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              height: 250,
              width: screen.width * 0.8,
              child: ListView(
                children: eventsForSelectedDay
                    .map((ticket) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 8,
                            ),
                            Card(
                              child: Container(
                                width: screen.width * 0.7,
                                margin: const EdgeInsetsDirectional.all(12),
                                padding: const EdgeInsetsDirectional.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                        text: TextSpan(
                                            text: 'Client: ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            children: [
                                          TextSpan(
                                              text: ticket.clientName,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal))
                                        ])),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    RichText(
                                        text: TextSpan(
                                            text: 'Phone: ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            children: [
                                          TextSpan(
                                              text: ticket.phoneNumber,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal))
                                        ])),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    RichText(
                                        text: TextSpan(
                                            text: 'Address: ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            children: [
                                          TextSpan(
                                              text: ticket.address,
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight:
                                                      FontWeight.normal))
                                        ])),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ))
                    .toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }
}
