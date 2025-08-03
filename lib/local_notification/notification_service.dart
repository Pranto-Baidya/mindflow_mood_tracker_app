
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService{

  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init()async{
     tz.initializeTimeZones();

     final android = AndroidInitializationSettings('@mipmap/ic_launcher');
     final settings = InitializationSettings(android: android);
     await _notifications.initialize(settings);
  }

  static Future<void> requestPermission()async{
    if(Platform.isAndroid){
      await _notifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    }
  }

  static Future<void> scheduleDailyReminder()async{
    await _notifications.zonedSchedule(
        0,
        'Mindflow mood journal reminder',
        "Have you written your today's mood journal?",
        _nextInstanceOfTime(17,45),
         NotificationDetails(
          android: AndroidNotificationDetails(
              'daily_reminder',
              'Daily reminder',
               importance: Importance.high,
               priority: Priority.high,
               playSound: true
          )
        ),
        androidScheduleMode: AndroidScheduleMode.inexact,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime,
    );
  }
  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute){
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year,now.month,now.day,hour,minute);
    if(scheduled.isBefore(now)){
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static Future<void> cancelAll()async{
    await _notifications.cancelAll();
  }

}