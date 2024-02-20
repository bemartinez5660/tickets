import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:isu_corp_test/screens/directions/directions_screen.dart';
import 'package:isu_corp_test/widgets/calendar/calendar_dialog.dart';
import 'package:isu_corp_test/screens/work_ticket/work_ticket_screen.dart';
import 'package:isu_corp_test/providers/tickets.dart';
import 'package:isu_corp_test/widgets/dashboard/add_ticket/add_edit_ticket_modal.dart';
import 'package:isu_corp_test/widgets/tickets_list/list_item.dart';
import 'package:isu_corp_test/screens/login/login_screen.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () async {
        await Provider.of<Tickets>(context, listen: false).initTicketList();
      },
    );
  }

  Future<void> _fetchAndSetTickets() async {
    await Provider.of<Tickets>(context, listen: false).initTicketList();
  }

  // List of Pop up Menu Items of Pop up Menu Button at the top right of dashboard screen
  List<PopupMenuEntry<Object>> menuItems = [
    const PopupMenuItem(
      value: 'work_ticket',
      child: Row(
        children: [
          SizedBox(
              width: 22,
              height: 22,
              child: Icon(
                Icons.edit_document,
                color: Colors.black,
              )),
          SizedBox(
            width: 12,
          ),
          Text('Work ticket'),
        ],
      ),
    ),
    const PopupMenuDivider(height: 4),
    const PopupMenuItem(
      value: 'get_directions',
      child: Row(
        children: [
          SizedBox(
              width: 22,
              height: 22,
              child: Icon(
                Icons.directions,
                color: Colors.black,
              )),
          SizedBox(
            width: 12,
          ),
          Text('Get directions'),
        ],
      ),
    ),
    const PopupMenuDivider(height: 4),
    const PopupMenuItem(
      value: 'instructions',
      child: Row(
        children: [
          SizedBox(
              width: 22,
              height: 22,
              child: Icon(
                Icons.info,
                color: Colors.black,
              )),
          SizedBox(
            width: 12,
          ),
          Text('Instructions'),
        ],
      ),
    ),
    const PopupMenuDivider(height: 4),
    const PopupMenuItem(
      value: 'logout',
      child: Row(
        children: [
          SizedBox(
              width: 22,
              height: 22,
              child: Icon(
                Icons.logout,
                color: Colors.black,
              )),
          SizedBox(
            width: 12,
          ),
          Text('LogOut'),
        ],
      ),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    final ticketList = Provider.of<Tickets>(context).tickets;
    return Scaffold(
      // Container with gradient to the background of the screen
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.primaryColor,
              theme.primaryColor.withOpacity(0.6),
            ], // Gradient colors
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Positioned(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            style: const ButtonStyle(
                                elevation: MaterialStatePropertyAll(10)),
                            onPressed: () {
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => const ScheduleScreen(),
                              // ));
                              showDialog(
                                  context: context,
                                  builder: (context) => CalendarDialog(
                                        screen: screen,
                                      ));
                            },
                            icon: Icon(
                              Icons.calendar_month,
                              color: theme.canvasColor,
                              size: 30,
                            )),
                        IconButton(
                            tooltip: 'Sync with Google Calendar',
                            style: const ButtonStyle(
                                elevation: MaterialStatePropertyAll(10)),
                            onPressed: () {
                              // Just some tests to integrate the google calendar api
                              // but i havent enough time to complete it...
                              // Navigator.of(context).push(MaterialPageRoute(
                              //   builder: (context) => const CalendarScreen(),
                              // ));
                            },
                            icon: Icon(
                              Icons.sync,
                              color: theme.canvasColor,
                              size: 30,
                            )),
                      ],
                    ),
                    Text(
                      'Tickets',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          color: theme.canvasColor),
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      children: [
                        // Button to add a new ticket which show a bottom sheet
                        //with a form
                        IconButton(
                            tooltip: 'Add a new ticket',
                            style: const ButtonStyle(
                                elevation: MaterialStatePropertyAll(10)),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) =>
                                      const AddAndEditTicketModal(),
                                  isScrollControlled: true);
                            },
                            icon: Icon(
                              Icons.add_circle,
                              color: theme.canvasColor,
                              size: 30,
                            )),
                        // Menu button
                        PopupMenuButton(
                            tooltip: 'Menu',
                            icon: Icon(
                              Icons.more_vert,
                              color: theme.canvasColor,
                              size: 30,
                            ),
                            onSelected: (v) {
                              if (v == 'work_ticket') {
                                if (ticketList.isNotEmpty) {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const WorkTicketScreen(),
                                      ));
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) => const AlertDialog(
                                      title: Text('Empty list'),
                                      content: Text('Add a ticket.'),
                                    ),
                                  );
                                }
                              } else if (v == 'get_directions') {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      const DirectionsScreen(),
                                ));
                              } else if (v == 'instructions') {
                                showDialog(
                                    context: context,
                                    builder: (_) => const AlertDialog(
                                          title: Text(
                                            'Notes',
                                            textAlign: TextAlign.center,
                                          ),
                                          content: SizedBox(
                                            height: 300,
                                            child: Card(
                                              child: Padding(
                                                padding: EdgeInsets.all(10.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '1- To delete or modify an item in the list, slide it sideways.',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      '2- To update the list swipe down.',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    Text(
                                                      ' 3- You can recover the password is working.',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(
                                                      'Thank you very much for giving me the opportunity to take this test, I would be very proud to work for your company. \n Flutter Developer \n Bárbaro Enrique Martinez',
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ));
                              } else if (v == 'logout') {
                                FirebaseAuth.instance
                                    .signOut()
                                    .then((value) => Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginScreen(),
                                        )));
                              }
                            },
                            itemBuilder: (c) {
                              return menuItems;
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Center(
                    child: Container(
                  height: screen.height * 0.8,
                  width: screen.width * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(25)),
                  // Widget to update the tickets list with those from the database
                  // when the user swipe down
                  child: RefreshIndicator(
                    onRefresh: () => _fetchAndSetTickets(),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: ListView.builder(
                        itemCount: ticketList.length,
                        itemBuilder: (context, index) => ListItem(
                          ticket: ticketList[index],
                        ),
                      ),
                    ),
                  ),
                )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
