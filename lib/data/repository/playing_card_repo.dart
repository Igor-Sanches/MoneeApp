import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:monetization/data/model/response/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class PlayingCardRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  PlayingCardRepo({@required this.apiClient, @required this.sharedPreferences});

  Future<Response> connectWithServe() async {
    return await apiClient.getData(AppConstants.PLAYING_CARD_CONNECTION_URI);
  }

  Future<Response> saveGameCoins(coin) async {
    return await apiClient.postData(AppConstants.GAME_PLAYING_CARD, {"_method": "put", "coin": coin});
  }
}
