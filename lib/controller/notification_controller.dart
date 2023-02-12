import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import '../helper/helpers.dart';
import '../helper/route_helper.dart';

class NotificationController {
  static ReceivedAction initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
        null, //'resource://drawable/res_app_icon',//
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
    var payload = receivedAction.payload;

    if(
    receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction
    ){
      print('Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      await executeLongTaskInBackground();
    }
    else {
      // MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
      //     '/notification-page',
      //         (route) =>
      //     (route.settings.name != '/notification-page') || route.isFirst,
      //     arguments: receivedAction);
    }
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///
  static Future<bool> displayNotificationRationale() async {
    print('clicate');
    // bool userAuthorized = false;
    // BuildContext context = MyApp.navigatorKey.currentContext!;
    // await showDialog(
    //     context: context,
    //     builder: (BuildContext ctx) {
    //       return AlertDialog(
    //         title: Text('Get Notified!',
    //             style: Theme.of(context).textTheme.titleLarge),
    //         content: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Row(
    //               children: [
    //                 Expanded(
    //                   child: Image.asset(
    //                     'assets/animated-bell.gif',
    //                     height: MediaQuery.of(context).size.height * 0.3,
    //                     fit: BoxFit.fitWidth,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //             const SizedBox(height: 20),
    //             const Text(
    //                 'Allow Awesome Notifications to send you beautiful notifications!'),
    //           ],
    //         ),
    //         actions: [
    //           TextButton(
    //               onPressed: () {
    //                 Navigator.of(ctx).pop();
    //               },
    //               child: Text(
    //                 'Deny',
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .titleLarge
    //                     ?.copyWith(color: Colors.red),
    //               )),
    //           TextButton(
    //               onPressed: () async {
    //                 userAuthorized = true;
    //                 Navigator.of(ctx).pop();
    //               },
    //               child: Text(
    //                 'Allow',
    //                 style: Theme.of(context)
    //                     .textTheme
    //                     .titleLarge
    //                     ?.copyWith(color: Colors.deepPurple),
    //               )),
    //         ],
    //       );
    //     });
    // return userAuthorized &&
    //     await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> executeLongTaskInBackground() async {
    print("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    final re = await http.get(url);
    print(re.body);
    print("long task done");
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  static Future<void> createNewNotification(int id, String title, String body, String bigPicture, String largeIcon, Map<String, String> payload) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: 'alerts',
            title: title,
            body: body,
            bigPicture: bigPicture,
            largeIcon: largeIcon,
            notificationLayout: NotificationLayout.BigPicture,
            payload: payload));
  }

}