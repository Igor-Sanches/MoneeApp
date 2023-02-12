import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:monetization/data/model/response/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class LuckyTableRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LuckyTableRepo({@required this.apiClient, @required this.sharedPreferences});

  Future<Response> connectWithServe() async {
    return await apiClient.getData(AppConstants.LUCKY_TABLE_CONNECTION_URI);
  }

  Future<Response> saveGameCoins(coin) async {
    return await apiClient.postData(AppConstants.GAME_LUCKY_TABLE, {"_method": "put", "coin": coin});
  }

  luckyTableDay() {
    if(sharedPreferences.containsKey('day_game')){
      var day = DateTime.now().day;
      var month = DateTime.now().month;
      var year = DateTime.now().year;
      print('dayday $day-$month-$year');
      print(sharedPreferences.getString('day_game'));
      return '$day-$month-$year' == sharedPreferences.getString('day_game');
    }
    return false;
  }

  void putDay() {
    var day = DateTime.now().day;
    var month = DateTime.now().month;
    var year = DateTime.now().year;
    sharedPreferences.setString('day_game', '$day-$month-$year');
  }
}
