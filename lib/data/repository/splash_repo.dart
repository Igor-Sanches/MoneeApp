import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../../util/html_type.dart';
import '../api/api_client.dart';

class SplashRepo {
  ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SplashRepo({@required this.sharedPreferences, @required this.apiClient});

  Future<Response> getConfigData() async {
    return await apiClient.getData(AppConstants.CONFIG_URI);
  }

  Future<void> initSharedData() async {
    if(!sharedPreferences.containsKey(AppConstants.THEME)) {
      sharedPreferences.setBool(AppConstants.THEME, false);
    }
    if(!sharedPreferences.containsKey(AppConstants.COUNTRY_CODE)) {
      sharedPreferences.setString(AppConstants.COUNTRY_CODE, AppConstants.languages[0].countryCode);
    }
    if(!sharedPreferences.containsKey(AppConstants.LANGUAGE_CODE)) {
      sharedPreferences.setString(AppConstants.LANGUAGE_CODE, AppConstants.languages[0].languageCode);
    }
    if(!sharedPreferences.containsKey(AppConstants.CART_LIST)) {
      sharedPreferences.setStringList(AppConstants.CART_LIST, []);
    }
    if(!sharedPreferences.containsKey(AppConstants.SEARCH_HISTORY)) {
      sharedPreferences.setStringList(AppConstants.SEARCH_HISTORY, []);
    }
    if(!sharedPreferences.containsKey(AppConstants.NOTIFICATION)) {
      sharedPreferences.setBool(AppConstants.NOTIFICATION, true);
    }
    if(!sharedPreferences.containsKey(AppConstants.INTRO)) {
      sharedPreferences.setBool(AppConstants.INTRO, true);
    }
    if(!sharedPreferences.containsKey(AppConstants.NOTIFICATION_COUNT)) {
      sharedPreferences.setInt(AppConstants.NOTIFICATION_COUNT, 0);
    }
  }

  void disableIntro() {
    sharedPreferences.setBool(AppConstants.INTRO, false);
  }

  bool showIntro() {
    return sharedPreferences.getBool(AppConstants.INTRO);
  }

  Future<Response> getHtmlText(HtmlType htmlType) async {
    // return await apiClient.getData(
    //   htmlType == HtmlType.TERMS_AND_CONDITION ? AppConstants.TERMS_AND_CONDITIONS_URI
    //     : htmlType == HtmlType.PRIVACY_POLICY ? AppConstants.PRIVACY_POLICY_URI : htmlType == HtmlType.ABOUT_US
    //       ? AppConstants.ABOUT_US_URI : htmlType == HtmlType.SHIPPING_POLICY ? AppConstants.SHIPPING_POLICY_URI
    //       : htmlType == HtmlType.CANCELATION ? AppConstants.CANCELATION_URI : AppConstants.REFUND_URI,
    //   headers: {
    //     'Content-Type': 'application/json; charset=UTF-8',
    //     'Accept': 'application/json',
    //     AppConstants.MODULE_ID: ''
    //   },
    // );
  }

  bool getLanguage() {
    if(sharedPreferences.containsKey(AppConstants.LANGUAGE)){
      return sharedPreferences.getBool(AppConstants.LANGUAGE);
    }
    return false;
  }

  getLanguageLocale() {
    return sharedPreferences.getString(AppConstants.LANGUAGE_CODE);
  }

  void setNotification(Map<String, dynamic> data) {
    if(sharedPreferences.containsKey(AppConstants.NOTIFICTION_DATA)){
       sharedPreferences.remove(AppConstants.NOTIFICTION_DATA);
    }
    sharedPreferences.setString(AppConstants.NOTIFICTION_DATA, jsonEncode(data));
  }

  Map<String, dynamic> getNotification(){
    if(!sharedPreferences.containsKey(AppConstants.NOTIFICTION_DATA)){
      return null;
    }
    return jsonDecode(sharedPreferences.getString(AppConstants.NOTIFICTION_DATA));
  }

  void removeNotification() {
    sharedPreferences.remove(AppConstants.NOTIFICTION_DATA);
  }
}
