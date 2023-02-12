import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:monetization/data/model/response/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class TicTacToeRep {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  TicTacToeRep({@required this.apiClient, @required this.sharedPreferences});

  int victories() {
    return sharedPreferences.getInt(AppConstants.TIC_TAC_TOE_VICTORIES) ?? 0;
  }

  int defeats() {
    return sharedPreferences.getInt(AppConstants.TIC_TAC_TOE_DEFEATS) ?? 0;
  }

  int ties() {
    return sharedPreferences.getInt(AppConstants.TIC_TAC_TOE_TIES) ?? 0;
  }

  void addVictory() {
    sharedPreferences.setInt(AppConstants.TIC_TAC_TOE_VICTORIES, victories() + 1);
  }

  void addDefeats() {
    sharedPreferences.setInt(AppConstants.TIC_TAC_TOE_DEFEATS, defeats() + 1);
  }

  void addTies() {
    sharedPreferences.setInt(AppConstants.TIC_TAC_TOE_TIES, ties() + 1);
  }

  Future<Response> connectWithServe() async {
    return await apiClient.getData(AppConstants.TIC_TAC_TOE_CONNECTION_URI);
  }

  Future<Response> saveGameCoins(coin, win) async {
    return await apiClient.postData(AppConstants.GAME_TIC_TAC_TOE, {"_method": "put", "coin": coin, "win":win});
  }

}
