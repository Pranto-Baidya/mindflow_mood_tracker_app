import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _notificationService = FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async {

    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await _notificationService.initialize(settings);
  }

  static Future<void> requestPermission() async {
    await _notificationService
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static const NotificationDetails notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'daily_channel_id',
      'Mindflow Daily Notification',
      channelDescription: 'Reminder to log your mood journal daily',
      importance: Importance.max,
      priority: Priority.high,
    ),
  );

  static Future<void> showImmediateNotification() async {
    await _notificationService.show(
      0,
      'Mindflow mood journal',
      "You'll now receive daily notifications",
      notificationDetails,
    );
  }

  static Future<void> showNotificationAt() async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      21,
      59,
    );
    await _notificationService.zonedSchedule(
      1,
      'Mindflow mood journal',
      "Take a moment for yourself — how are you feeling today? Check in now!",
      scheduleDate,
      notificationDetails,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

    print('Notification scheduled at: $scheduleDate');
  }

  static Future<void> setReminderNotification(
      { required int id,
        required  String title,
        required String description,
        required DateTime date,
        required TimeOfDay time
      }) async{
    var scheduleDate = tz.TZDateTime(
      tz.local,
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

    await _notificationService.zonedSchedule(
        id,
        title,
        description,
        scheduleDate,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,

    );

  }

  static Future<void> cancelNotifications() async {
    await _notificationService.cancelAll();
  }
}
