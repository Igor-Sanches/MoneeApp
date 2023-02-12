import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';
import '../model/response/user_model.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({@required this.apiClient, @required this.sharedPreferences});

  Future<Response> registration(name, zipcode, phone, email, password, referCode, os, deviceInfo) async {
    return await apiClient.postData(AppConstants.REGISTER_URI, {
      'ref_code':referCode,
      'name':name,
      'email':email,
      'password':password,
      'phone':phone,
      'os':os,
      'zipcode':zipcode,
      'device_info':deviceInfo
    });
  }

  Future<Response> login({String email, String password,String os, Map<String, dynamic> deviceInfo}) async {
    return await apiClient.postData(AppConstants.LOGIN_URI, {"email": email, "password": password, 'os':os, 'device_info':deviceInfo});
  }


  Future<Response> updateToken() async {
    String deviceToken;
    if (GetPlatform.isIOS && !GetPlatform.isWeb) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true, announcement: false, badge: true, carPlay: false,
        criticalAlert: false, provisional: false, sound: true,
      );
      if(settings.authorizationStatus == AuthorizationStatus.authorized) {
        deviceToken = await _saveDeviceToken();
      }
    }else {
      deviceToken = await _saveDeviceToken();
    }
    if(!GetPlatform.isWeb) {
      FirebaseMessaging.instance.subscribeToTopic(AppConstants.TOPIC);
    }
    return await apiClient.postData(AppConstants.TOKEN_URI, {"_method": "put", "cm_firebase_token": deviceToken});
  }

  Future<String> _saveDeviceToken() async {
    String deviceToken = '@';
    if(!GetPlatform.isWeb) {
      try {
        deviceToken = await FirebaseMessaging.instance.getToken();
      // ignore: empty_catches
      }catch(e) {}
    }
    if (deviceToken != null) {
      if (kDebugMode) {
        print('--------Device Token---------- $deviceToken');
      }
    }
    return deviceToken;
  }

  Future<Response> verifyToken(String phone, String token) async {
    return await apiClient.postData(AppConstants.VERIFY_TOKEN_URI, {"phone": phone, "reset_token": token});
  }

  // for  user token
  Future<bool> saveUserToken(String token, User user) async {
    apiClient.token = token;
    apiClient.updateHeader(
      token, sharedPreferences.getString(AppConstants.LANGUAGE_CODE)
    );
    sharedPreferences.setString('user_model', jsonEncode(user.toJson()));
    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.TOKEN) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }

  bool clearSharedData() {
    if(!GetPlatform.isWeb) {
      FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
      apiClient.postData(AppConstants.TOKEN_URI, {"_method": "put", "cm_firebase_token": '@'});
    }
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.setStringList(AppConstants.CART_LIST, []);
    sharedPreferences.remove(AppConstants.USER_ADDRESS);
    apiClient.token = null;
    apiClient.updateHeader(null, null);
    return true;
  }

  bool clearSharedAddress(){
    sharedPreferences.remove(AppConstants.USER_ADDRESS);
    return true;
  }

  // for  Remember Email
  Future<void> saveUserNumberAndPassword(String number, String password, String countryCode) async {
    try {
      await sharedPreferences.setString(AppConstants.USER_PASSWORD, password);
      await sharedPreferences.setString(AppConstants.USER_EMAIL, number);
      await sharedPreferences.setString(AppConstants.USER_COUNTRY_CODE, countryCode);
    } catch (e) {
      rethrow;
    }
  }

  String getUserEmail() {
    return sharedPreferences.getString(AppConstants.USER_EMAIL) ?? "";
  }

  String getUserCountryCode() {
    return sharedPreferences.getString(AppConstants.USER_COUNTRY_CODE) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.USER_PASSWORD) ?? "";
  }

  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.NOTIFICATION) ?? true;
  }

  void setNotificationActive(bool isActive) {
    if(isActive) {
      updateToken();
    }else {
      if(!GetPlatform.isWeb) {
        FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.TOPIC);
      }
    }
    sharedPreferences.setBool(AppConstants.NOTIFICATION, isActive);
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.USER_PASSWORD);
    await sharedPreferences.remove(AppConstants.USER_COUNTRY_CODE);
    return await sharedPreferences.remove(AppConstants.USER_EMAIL);
  }

  getUserModel() {
    if(sharedPreferences.containsKey('user_model')){
      return User.fromJson(jsonDecode(sharedPreferences.getString('user_model')));
    }
    return null;
  }
}
