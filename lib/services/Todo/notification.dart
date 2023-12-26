import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:minor_project/main.dart';
import 'package:timezone/timezone.dart' as tz;

class Notifications{
  static Future<void> showNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
            "AlzheimerApp-Notifications", "WorkToDo",
            priority: Priority.high, importance: Importance.high);

    DarwinNotificationDetails iosNotificationDetails =
        const DarwinNotificationDetails(
            presentAlert: true, presentBadge: true, presentSound: true);

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);

    // notificationsPlugin.show(
    //     0, "AlzheimerApp", "Have to complete Tut 10", notificationDetails);

    DateTime scheduleDate = DateTime.now().add(const Duration(seconds: 5));
    try {
      await notificationsPlugin.zonedSchedule(
          0,
          "AlzheimerApp",
          "Have to complete Tut 10",
          tz.TZDateTime.from(scheduleDate, tz.local),
          notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.wallClockTime,
          payload: "Tut 10 clicked");

      log("Notification send");
    } catch (e) {
      print(e);
    }
  }

// function used to see the notification payload(data) when app is closed
  static void checkForNotificationClicked() async {
    NotificationAppLaunchDetails? details =
        await notificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null) {
      if (details.didNotificationLaunchApp) {
        NotificationResponse? response = details.notificationResponse;
        if (response != null) {
          String? payload = response.payload;
          log("Notification payload: $payload");
        }
      }
    }
  }
}
