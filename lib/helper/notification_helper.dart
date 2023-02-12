import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'helpers.dart';

class NotificationHelper {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('notification');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings, onSelectNotification: (String payload) async {
      // try{
      //   var dataPayload;
      //   if(payload != null && payload.isNotEmpty) {
      //     dataPayload = jsonDecode(payload);
      //     try{
      //       Get.find<SplashController>().setNotification(dataPayload);
      //     }catch(ex){}
      //     var postId = dataPayload['post_id'] ?? 0;
      //     var link = dataPayload['link'] ?? '';
      //     if (int.parse(postId) > 0) {
      //       Get.offAllNamed(RouteHelper.getDetailsRoute(postId.toString()));
      //     }
      //     if (link != null && link != '') {
      //       if(Get.find<SplashController>().configModel.externalBrowser){
      //         Get.find<SplashController>().removeNotification();
      //         Helpers.externalBrowser(link);
      //       }else{
      //         Get.toNamed(RouteHelper.getWebViewRoute(link));
      //       }
      //     }
      //   }
      //   // ignore: empty_catches
      // }catch (e) {}
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var data = message.data;
      print('datadata $data');
      print('mensagem recebida');
      if(data['post_id'] != null){
        String _uniqueId = data['unique_id'];
        String title = data['title'];
        String message = data['message'];
        String bigImage = data['big_image'];
        String link = data['link'];
        String _postId = data['post_id'];
        int uniqueId = int.parse(_uniqueId);
        int postId = int.parse(_postId);

        createNotification(uniqueId, title, message, bigImage, jsonEncode(data), flutterLocalNotificationsPlugin);
      }

    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      var data = message.data;
      // try{
      //   if(message.data != null || message.data.isNotEmpty) {
      //     try{
      //       Get.find<SplashController>().setNotification(data);
      //     }catch(ex){}
      //     String _uniqueId = data['unique_id'];
      //     String title = data['title'];
      //     String message = data['message'];
      //     String bigImage = data['big_image'];
      //     String link = data['link'];
      //     String _postId = data['post_id'];
      //     int uniqueId = int.parse(_uniqueId);
      //     int postId = int.parse(_postId);
      //     if (postId > 0) {
      //       Get.offAllNamed(RouteHelper.getDetailsRoute(postId.toString()));
      //     }
      //     if (link != null && link != '') {
      //       if(Get.find<SplashController>().configModel.externalBrowser){
      //         Get.find<SplashController>().removeNotification();
      //         Helpers.externalBrowser(link);
      //       }else{
      //         Get.toNamed(RouteHelper.getWebViewRoute(link));
      //       }
      //
      //     }
      //   }
      // }catch (e) {}e
    });
  }

  static Future<void> showBigTextNotification(int uniqueId, String title, String message, String bigImage, String payload, FlutterLocalNotificationsPlugin fln) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message, htmlFormatBigText: true,
      contentTitle: title, htmlFormatContentTitle: true,
    );
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'app_name'.tr, 'app_name'.tr, importance: Importance.max,
      styleInformation: bigTextStyleInformation, priority: Priority.max, playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(uniqueId, title, message, platformChannelSpecifics, payload: payload);
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(int uniqueId, String title, String message, String bigImage, String payload, FlutterLocalNotificationsPlugin fln) async{

    final String largeIconPath = await _downloadAndSaveFile(bigImage, 'largeIcon');
    final String bigPicturePath = await _downloadAndSaveFile(bigImage, 'bigPicture');
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath), hideExpandedLargeIcon: true,
      contentTitle: title, htmlFormatContentTitle: true,
      summaryText: message, htmlFormatSummaryText: true,
    );
    final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'app_name'.tr, 'app_name'.tr,
      largeIcon: FilePathAndroidBitmap(largeIconPath), priority: Priority.max, playSound: true,
      styleInformation: bigPictureStyleInformation, importance: Importance.max,
      sound: const RawResourceAndroidNotificationSound('notification'),
    );
    final NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(uniqueId, title, message, platformChannelSpecifics, payload: payload);
  }

  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }


  static void createNotification(int uniqueId, String title, String message, String bigImage, String payload, FlutterLocalNotificationsPlugin fln) async{
    if(bigImage != null && bigImage.isNotEmpty) {
        try{
          await showBigPictureNotificationHiddenLargeIcon(uniqueId, title, message, bigImage, payload, fln);
        }catch(e) {
          await showBigTextNotification(uniqueId, title, message, bigImage, payload, fln);
        }
      }else {
        await showBigTextNotification(uniqueId, title, message, bigImage, payload, fln);
      }
   // }
  }

}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  // var data = message.data;
  // if(data['post_id'] != null){
  //   String _uniqueId = data['unique_id'];
  //   String title = data['title'];
  //   String message = data['message'];
  //   String bigImage = data['big_image'];
  //   int uniqueId = int.parse(_uniqueId);
  //
  //   String link = data['link'];
  //   String _postId = data['post_id'];
  //   int postId = int.parse(_postId);
  //   Map<String, String> map = {
  //     'unique_id':uniqueId.toString(),
  //     'title':title.toString(),
  //     'message':message.toString(),
  //     'big_image':bigImage.toString(),
  //     'link':link.toString(),
  //     'post_id':postId.toString()
  //   };
  //   try{
  //     Get.find<SplashController>().setNotification(data);
  //   }catch(ex){}
  //   NotificationController.createNewNotification(uniqueId, title, message, bigImage, bigImage, map);
    // FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
    // var androidInitialize = const AndroidInitializationSettings('notification');
    // var iOSInitialize = const IOSInitializationSettings();
    // var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    // flutterLocalNotificationsPlugin.initialize(initializationsSettings, onSelectNotification: (String payload) async {
    //   try{
    //     var dataPayload;
    //     if(payload != null && payload.isNotEmpty) {
    //       dataPayload = jsonDecode(payload);
    //       var postId = dataPayload['post_id'] ?? 0;
    //       var link = dataPayload['link'] ?? '';
    //       if (int.parse(postId) > 0) {
    //         Get.offAllNamed(RouteHelper.getDetailsRoute(postId.toString()));
    //       }
    //       if (link != null && link != '') {
    //         Get.offAllNamed(RouteHelper.getWebViewRoute(link));
    //       }
    //     }
    //     // ignore: empty_catches
    //   }catch (e) {}
    //   return;
    // });
    // NotificationHelper.createNotification(uniqueId, title, message, bigImage, jsonEncode(data), flutterLocalNotificationsPlugin);
}