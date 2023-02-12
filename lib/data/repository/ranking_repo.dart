import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:monetization/data/model/response/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class RankingRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  RankingRepo({@required this.apiClient, this.sharedPreferences});

  Future<Response> getGames(offset) async {
    return await apiClient.getData('${AppConstants.LIST_RANKING_URI}?offset=$offset&limit=10');
  }

  bool get isMyInRaking => sharedPreferences.getBool('my_raking') ?? false;

  void setMyInRaking(boolean){
    sharedPreferences.setBool('my_raking', boolean);
  }
}
