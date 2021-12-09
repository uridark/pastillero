import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String>();

  static Future init({bool initScheduled = false}) async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const setting = InitializationSettings(android: android);

    final details = await _notifications.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotification.add(details.payload!);
    }

    await _notifications.initialize(setting,
        onSelectNotification: (payload) async {
      onNotification.add(payload!);
    });

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    DateTime? scheduledData,
  }) async =>
      _notifications.show(id, title, body, await _notificationDetails(),
          payload: payload);

  static Future _notificationDetails() async {
    const styleinformation = BigPictureStyleInformation(
        FilePathAndroidBitmap('assets/images/1024.png'));
    const sound = 'a_long_cold_sting.wav';
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'Channel for Alarm notification',
        importance: Importance.max,
        playSound: true,
        largeIcon: const DrawableResourceAndroidBitmap('notifi'),
        sound: RawResourceAndroidNotificationSound(sound.split('.').first),
        enableVibration: true,
        styleInformation: styleinformation,
      ),
    );
  }

  static Future scheduleDaily9AMNotification(
      {required String body,
      required int hora,
      required String title,
      required int minuto}) async {
    int i = 0;
    const styleinformation = BigPictureStyleInformation(
        FilePathAndroidBitmap('assets/images/1024.png'));
    const sound = 'a_long_cold_sting.wav';
    await _notifications.zonedSchedule(
        i + 1,
        title,
        body,
        _nextInstanceOf9AM(hora, minuto),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'Diario',
            'Medicamento',
            channelDescription: 'Recordatorio',
            priority: Priority.max,
            importance: Importance.max,
            playSound: true,
            largeIcon: const DrawableResourceAndroidBitmap('notifi'),
            sound: RawResourceAndroidNotificationSound(sound.split('.').first),
            enableVibration: true,
            styleInformation: styleinformation,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
    print('Notification Succesfully Scheduled at ' +
        hora.toString() +
        ' ' +
        minuto.toString());
  }

  static tz.TZDateTime _nextInstanceOf9AM(int hora, int minuto) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hora, minuto);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> scheduleWeeklyNotification(int dia, int hora, int minuto) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'id',
        'name',
        channelDescription: 'description',
        priority: Priority.max,
        importance: Importance.max,
      ),
    );

    await _notifications.zonedSchedule(
      0,
      'notification for Tomorrow',
      'body',
      _netxInstanceOfDay(dia, hora, minuto),
      details,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  tz.TZDateTime _netxInstanceOfDay(int dia, int hora, int minuto) {
    tz.TZDateTime scheduleDate = _nextIntance(dia, hora, minuto);
    //while(scheduleDate.weekday  != DateTime.friday ){
    //scheduleDate = scheduleDate.add(Duration(days: 1));
    //}
    return scheduleDate;
  }

  tz.TZDateTime _nextIntance(int dia, int hora, int minuto) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduleDate =
        tz.TZDateTime(tz.local, now.year, now.month, dia, hora, minuto);
    if (scheduleDate.isBefore(now)) {
      scheduleDate = scheduleDate.add(Duration(days: 1));
    }
    return scheduleDate;
  }

  static Future<void> repeatNotification(
      {required String body, required String title}) async {
    print('Notification Succesfully Scheduled at ');
    const styleinformation = BigPictureStyleInformation(
        FilePathAndroidBitmap('assets/images/1024.png'));
    const sound = 'a_long_cold_sting.wav';
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'Bienaventurados Repeat',
      'Bienaventurados Repeat',
      channelDescription: 'Repetiremos sin cansancio que Dios te ama!',
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'Diario',
        'Medicamento',
        channelDescription: 'Recordatorio',
        priority: Priority.max,
        importance: Importance.max,
        playSound: true,
        largeIcon: const DrawableResourceAndroidBitmap('notifi'),
        sound: RawResourceAndroidNotificationSound(sound.split('.').first),
        enableVibration: true,
        styleInformation: styleinformation,
      ),
    );
    await _notifications.periodicallyShow(
      0,
      title,
      body,
      RepeatInterval.daily,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }

  Future<void> cancelAllNotification() async {
    await _notifications.cancelAll();
  }
}
