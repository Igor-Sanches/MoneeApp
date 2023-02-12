import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:monetization/data/model/response/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class SpinToWinRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  SpinToWinRepo({@required this.apiClient, @required this.sharedPreferences});

  Future<Response> connectWithServe() async {
    return await apiClient.getData(AppConstants.SPIN_TO_WIN_CONNECTION_URI);
  }

  Future<Response> saveGameCoins(coin) async {
    return await apiClient.postData(AppConstants.GAME_SPIN_TO_WIN, {"_method": "put", "coin": coin});
  }

  spinToWinDay() {
    if(sharedPreferences.containsKey('day_game_spin')){
      var day = DateTime.now().day;
      var month = DateTime.now().month;
      var year = DateTime.now().year;
      return '$day-$month-$year' == sharedPreferences.getString('day_game_spin');
    }
    return false;
  }

  void putDay() {
    var day = DateTime.now().day;
    var month = DateTime.now().month;
    var year = DateTime.now().year;
    sharedPreferences.setString('day_game_spin', '$day-$month-$year');
  }
}
