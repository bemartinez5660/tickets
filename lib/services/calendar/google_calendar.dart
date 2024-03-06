import 'dart:io';

import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as v3;
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

class GoogleCalendar {
  var _credentials;
  static const _scopes = [v3.CalendarApi.calendarScope];

  Future<bool> exportToGoogleCalendar({
    required String identifier,
    required String summary,
    required String description,
    required DateTime startDateTime,
    required String startTimeZone,
    required DateTime endDateTime,
    required String endTimeZone,
  }) async {
    setCredentials(identifier: identifier);
    //create event for adding to calendar
    v3.Event event = v3.Event();

    v3.EventDateTime start = v3.EventDateTime(); //Setting start time
    v3.EventDateTime end = v3.EventDateTime(); //setting end time

    start.dateTime = startDateTime;
    start.timeZone = startTimeZone;

    end.dateTime = endDateTime;
    end.timeZone = endTimeZone;

    return await _insertEvent(event);
  }

  //add events
  Future<bool> _insertEvent(v3.Event event) async {
    try {
      await clientViaUserConsent(_credentials, _scopes, _launchURL)
          .then((AuthClient client) {
        var calendar = v3.CalendarApi(client);
        String calendarId = "primary";

        calendar.events.insert(event, calendarId).then((value) {
          if (value.status == "confirmed") {
            print('Event added in google calendar');
            return true;
          } else {
            print("Unable to add event in google calendar");
            return false;
          }
        });
      });
    } catch (e) {
      return false;
    }
    return false;
  }

  void setCredentials({required String identifier}) {
    if (Platform.isAndroid) {
      _credentials = ClientId(identifier, "");
    } else if (Platform.isIOS) {
      _credentials = ClientId(identifier, "");
    }
  }

  void _launchURL(String url) async {
    try {
      await launchUrl(
        Uri.parse(url),
        customTabsOptions: CustomTabsOptions(
          colorSchemes: CustomTabsColorSchemes.defaults(
            toolbarColor: Colors.black,
          ),
          shareState: CustomTabsShareState.on,
          urlBarHidingEnabled: true,
          showTitle: true,
          closeButton: CustomTabsCloseButton(
            icon: CustomTabsCloseButtonIcons.back,
          ),
          // animations: CustomTabsAnimations(),
        ),
        safariVCOptions: SafariViewControllerOptions(
          preferredBarTintColor: Colors.orange[500],
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
