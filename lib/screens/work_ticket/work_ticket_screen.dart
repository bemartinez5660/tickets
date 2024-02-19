import 'package:flutter/material.dart';
import 'package:isu_corp_test/models/ticket.dart';
import 'package:isu_corp_test/screens/dashboard/dashboard_screen.dart';
import 'package:isu_corp_test/services/database/database_helper.dart';
import 'package:isu_corp_test/widgets/common/customized_back_button.dart';
import 'package:isu_corp_test/widgets/work_ticket/customized_button.dart';
import 'package:isu_corp_test/widgets/work_ticket/logo_button.dart';
import 'package:isu_corp_test/widgets/work_ticket/notes_card.dart';
import 'package:isu_corp_test/widgets/work_ticket/reasons_for_call.dart';
import 'package:isu_corp_test/widgets/work_ticket/schedule_date_card.dart';
import 'package:isu_corp_test/widgets/work_ticket/user_information_card.dart';

class WorkTicketScreen extends StatefulWidget {
  const WorkTicketScreen({super.key, this.ticket});
  final Ticket? ticket;

  @override
  State<WorkTicketScreen> createState() => _WorkTicketScreenState();
}

class _WorkTicketScreenState extends State<WorkTicketScreen> {
  // List of Pop up Menu Items of Pop up Menu Button at the top right of work 
  // ticket screen
  List<PopupMenuEntry<Object>> menuItems = [
    const PopupMenuItem(
      value: 'dashboard',
      child: Row(
        children: [
          SizedBox(
              width: 22,
              height: 22,
              child: Icon(
                Icons.dashboard,
                color: Colors.black,
              )),
          SizedBox(
            width: 12,
          ),
          Text('Dashboard'),
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
  ];

  // The customized icon for floatin menu button
  Widget floatingMenuButtonIcon(ThemeData theme) {
    return Container(
      height: 55,
      width: 55,
      alignment: Alignment.center,
      child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            color: theme.canvasColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Icon(
            Icons.more_vert,
            size: 30,
          )),
    );
  }

  // Future variable to wait until the ticket return from database
  // ignore: prefer_typing_uninitialized_variables
  var getTicketFuture;

  @override
  void initState() {
    super.initState();
    // if the ticket is equal null means the user come from dashboard menu button
    // not from the view ticket button and initialize the ticket from database
    if (widget.ticket == null) {
      getTicketFuture = getTicketFromDatabase();
    }
  }

  Future<Ticket> getTicketFromDatabase() async {
    late Ticket databaseTicket;
    DatabaseHelper dbHelper = DatabaseHelper();
    databaseTicket = await dbHelper.getLastInsertion();
    return databaseTicket;
  }

  @override
  Widget build(BuildContext context) {
    Widget pageForDetailsTicket = Container();
    Widget pageForDatabaseTicket = Container();
    final screen = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    const textStyle = TextStyle(
        fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black54);
    
    // Initializing the widget on work ticket page whether the
    // user tapped to view ticket or from the menu of dashboard
    if (widget.ticket != null) {
      pageForDetailsTicket = pageForDetailsTicketsMethod(
          screen, theme, context, textStyle, widget.ticket as Ticket);
    } else {
      pageForDatabaseTicket = FutureBuilder<Ticket>(
        future: getTicketFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Ticket ticket = snapshot.data as Ticket;
            return pageForDetailsTicketsMethod(
                screen, theme, context, textStyle, ticket);
          } else {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          }
        },
      );
    }
    // In case the user comes from the view ticket button render the widget wich use
    // the ticket passed by params in the other case use the widget which has initialized
    // with the ticket loaded from database 
    return widget.ticket == null ? pageForDatabaseTicket : pageForDetailsTicket;
  }

  Scaffold pageForDetailsTicketsMethod(Size screen, ThemeData theme,
      BuildContext context, TextStyle textStyle, Ticket currentTicket) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            width: screen.width,
            height: screen.height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withOpacity(0.6),
                ], // Colores del gradiente
              ),
            ),
            child: SafeArea(
                child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                children: [
                  CustomizedBackButton(theme: theme),
                  // Menu button
                  Positioned(
                    right: 0,
                    top: 0,
                    child: PopupMenuButton(
                        tooltip: 'Menu',
                        icon: floatingMenuButtonIcon(theme),
                        onSelected: (v) {
                          if (v == 'dashboard') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const DashboardScreen(),
                                ));
                          } else if (v == 'get_directions') {
                            // Navigator.of(context).pushNamed(SettingsScreen.routeName);
                          }
                        },
                        itemBuilder: (c) {
                          return menuItems;
                        }),
                  ),
                  Positioned(
                    top: screen.height * 0.09,
                    left: 0,
                    child: SizedBox(
                      height: screen.height * 0.85,
                      width: screen.width * 0.93,
                      child: ListView(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // User information card
                              UserInformationCard(
                                  screen: screen,
                                  theme: theme,
                                  textStyle: textStyle,
                                  ticket: currentTicket),
                              const SizedBox(
                                width: 8,
                              ),
                              // Schedule card for date of appointment
                              ScheduleDateCard(
                                  screen: screen,
                                  theme: theme,
                                  textStyle: textStyle,
                                  ticket: currentTicket),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          NotesCard(screen: screen),
                          const SizedBox(
                            height: 20,
                          ),
                          ReasonsForCall(screen: screen, theme: theme),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: screen.width * 0.8,
                            height: 150,
                            child: GridView(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      mainAxisExtent: 50),
                              children: [
                                CustomizedButton(
                                    screen: screen,
                                    opacity: 0.4,
                                    theme: theme,
                                    label: 'Overview'),
                                CustomizedButton(
                                    screen: screen,
                                    opacity: 0.5,
                                    theme: theme,
                                    label: 'Work details'),
                                CustomizedButton(
                                    screen: screen,
                                    opacity: 0.7,
                                    theme: theme,
                                    label: 'Purchasing'),
                                CustomizedButton(
                                    screen: screen,
                                    opacity: 0.9,
                                    theme: theme,
                                    label: 'Finishing up'),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          // Customized button with a image of app's logo
                          const LogoButton(),
                          const SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ))),
      ),
    );
  }
}
