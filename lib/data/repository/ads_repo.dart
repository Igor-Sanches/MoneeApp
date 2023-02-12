import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:monetization/data/model/response/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class AdsRepo {
  final ApiClient apiClient;
  AdsRepo({@required this.apiClient});

  Future<Response> getGames(offset) async {
    return await apiClient.getData('${AppConstants.LIST_ADS_URI}?offset=$offset&limit=10');
  }

  Future<Response> putCoin(coin, adId) async {
    return await apiClient.putData(AppConstants.PUT_COIN_AD_URI, {
      'coin':coin,
      'ad':adId
    });
  }

}
