import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static void initialize() {
    // initializationSettings  for Android
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
    );
  }

  // static void createanddisplaynotification(RemoteMessage message) async {
  //   try {
  //     const id = 1;
  //     const NotificationDetails notificationDetails = NotificationDetails(
  //         android: AndroidNotificationDetails(
  //             "pushNotificationonapp", "pushnotificationappchannel",
  //             importance: Importance.high, priority: Priority.high));

  //     await _notificationsPlugin.show(
  //       id,
  //       message.notification!.title,
  //       message.notification!.body,
  //       notificationDetails,
  //       payload: message.data['click_action'],
  //     );
  //   } on Exception catch (e) {
  //     print(e);
  //   }
  // }
}
