
// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../../services/calendar/calendar_client.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarClient calendarClient = CalendarClient();
  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now().add(const Duration(days: 1));
  final TextEditingController _eventName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(context),
    );
  }

  _body(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[
              TextButton(
                  onPressed: () {
                    // showDateTimePicker(context,
                    //     showTitleActions: true,
                    //     minTime: DateTime(2019, 3, 5),
                    //     maxTime: DateTime(2200, 6, 7), onChanged: (date) {
                    //   print('change $date');
                    // }, onConfirm: (date) {
                    //   setState(() {
                    //     this.startTime = date;
                    //   });
                    // }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: const Text(
                    'Event Start Time',
                    style: TextStyle(color: Colors.blue),
                  )),
              Text('$startTime'),
            ],
          ),
          Row(
            children: <Widget>[
              TextButton(
                  onPressed: () async {
                  // showDatePicker(context,
                  //       firstDate: DateTime(2019, 3, 5),
                  //       lastDate: DateTime(2200, 6, 7));
                  },
                  child: const Text(
                    'Event End Time',
                    style: TextStyle(color: Colors.blue),
                  )),
              Text('$endTime'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _eventName,
              decoration: const InputDecoration(hintText: 'Enter Event name'),
            ),
          ),
          ElevatedButton(
              child: const Text(
                'Insert Event',
              ),
              onPressed: () {
                //log('add event pressed');
                calendarClient.insert(
                  _eventName.text,
                  startTime,
                  endTime,
                );
              }),
        ],
      ),
    );
  }
}