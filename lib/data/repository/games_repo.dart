import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:monetization/data/model/response/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class GamesRepo {
  final ApiClient apiClient;
  GamesRepo({@required this.apiClient});

  Future<Response> getGames(offset) async {
    return await apiClient.getData('${AppConstants.GAMES_URI}?offset=$offset&limit=10');
  }

}
