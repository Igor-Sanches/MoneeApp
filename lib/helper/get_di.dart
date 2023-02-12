import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../controller/ads_controller.dart';
import '../controller/auth_controller.dart';
import '../controller/games_controller.dart';
import '../controller/localization_controller.dart';
import '../controller/lucky_table_controller.dart';
import '../controller/playing_card_controller.dart';
import '../controller/ranking_controller.dart';
import '../controller/scratch_and_win_controller.dart';
import '../controller/spin_to_win_controller.dart';
import '../controller/splash_controller.dart';
import '../controller/theme_controller.dart';
import '../controller/tic_tac_tok_controller.dart';
import '../controller/user_controller.dart';
import '../data/api/api_client.dart';
import '../data/model/response/language_model.dart';
import '../data/repository/ads_repo.dart';
import '../data/repository/auth_repo.dart';
import '../data/repository/games_repo.dart';
import '../data/repository/lucky_table_repo.dart';
import '../data/repository/playing_card_repo.dart';
import '../data/repository/ranking_repo.dart';
import '../data/repository/scratch_and_win_repo.dart';
import '../data/repository/spin_to_win_repo.dart';
import '../data/repository/splash_repo.dart';
import '../data/repository/tic_tac_toc_repo.dart';
import '../data/repository/user_repo.dart';
import '../util/app_constants.dart';

Future<Map<String, Map<String, String>>> init() async {
  // Core
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() => ApiClient(appBaseUrl: AppConstants.BASE_URL, sharedPreferences: Get.find()));

  // Repository
  Get.lazyPut(() => SplashRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => AuthRepo(sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(() => ScratchAndWinRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => TicTacToeRep(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => GamesRepo(apiClient: Get.find()));
  Get.lazyPut(() => LuckyTableRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => PlayingCardRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => SpinToWinRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => AdsRepo(apiClient: Get.find()));
  Get.lazyPut(() => RankingRepo(apiClient: Get.find(), sharedPreferences: Get.find()));

  // Controller
  Get.lazyPut(() => SplashController(splashRepo: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => LocalizationController(sharedPreferences: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));
  Get.lazyPut(() => TicTacToeController(ticTacTokRepo: Get.find()));
  Get.lazyPut(() => ScratchAndWinController(scratchAndWinRepo: Get.find()));
  Get.lazyPut(() => GamesController(gamesRepo: Get.find()));
  Get.lazyPut(() => LuckyTableController(luckyTableRepo: Get.find()));
  Get.lazyPut(() => SpinToWinController(spinToWinRepo: Get.find()));
  Get.lazyPut(() => PlayingCardController(playingCardRepo: Get.find()));
  Get.lazyPut(() => AdsController(adsRepo: Get.find()));
  Get.lazyPut(() => RankingController(rankingRepo: Get.find()));


  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for(LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues =  await rootBundle.loadString('assets/language/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);
    Map<String, String> jsonLanguage = {};
    mappedJson.forEach((key, value) {
      jsonLanguage[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] = jsonLanguage;
  }
  return languages;
}
