import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetization/view/screen/games/games/tic_tac_toe_game_screen.dart';

import '../controller/splash_controller.dart';
import '../util/html_type.dart';
import '../view/screen/about/about_screen.dart';
import '../view/screen/auth/sign_in_screen.dart';
import '../view/screen/auth/sign_up_screen.dart';
import '../view/screen/award/award_screen.dart';
import '../view/screen/dashboard/dashboard_screen.dart';
import '../view/screen/games/games/lucky_table_game_screen.dart';
import '../view/screen/games/games/playing_card_game_screen.dart';
import '../view/screen/games/games/scratch_and_win_game_screen.dart';
import '../view/screen/games/games/spin_to_win_game_screen.dart';
import '../view/screen/html/html_viewer_screen.dart';
import '../view/screen/language/language_screen.dart';
import '../view/screen/maintenance/maintenance_screen.dart';
import '../view/screen/ranking/ranking_screen.dart';
import '../view/screen/splash/splash_screen.dart';
import '../view/screen/unknown_source/unknown_source_screen.dart';
import '../view/screen/update/update_screen.dart';

class RouteHelper {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String main = '/main';
  static const String maintenance = '/maintenance';
  static const String update = '/update';
  static const String language = '/language';
  static const String unknown_source = '/unknown-source';
  static const String sign_in = '/sign-in';
  static const String sign_up = '/sign-up';
  static const String tic_tac_tow = '/tic-tac-tow';
  static const String scratch_and_win = '/scratch-and-win';
  static const String html = '/html';
  static const String lucky_table = '/lucky-table';
  static const String playing_card = '/playing-card';
  static const String spin_to_win = '/spin-to-win';
  static const String award = '/award';
  static const String about = '/about';
  static const String ranking = '/ranking';

  static String getMainRoute(String page) => '$main?page=$page';
  static String getInitialRoute() => initial;
  static String getSplashRoute() => splash;
  static String getMaintenanceRoute() => maintenance;
  static String getUpdateRoute() => update;
  static String getLanguageRoute() => language;
  static String getUnknownSourceRoute() => unknown_source;
  static String getTicTacToeGame(String banner) => '$tic_tac_tow?banner=$banner';
  static String getScratchAndWinGame(String banner) => '$scratch_and_win?banner=$banner';
  static String getLuckyTableGame(String banner) => '$lucky_table?banner=$banner';
  static String getSpinToWinGame(String banner) => '$spin_to_win?banner=$banner';
  static String getPlayingCardGame(String banner) => '$playing_card?banner=$banner';
  static String getSignInRoute(String page) => '$sign_in?page=$page';
  static String getSignUpRoute() => sign_up;
  static String getHtmlRoute(String page) => '$html?page=$page';
  static String getAwardRoute(int coin, String title, String msg, bool ad) => '$award?coin=$coin&title=$title&msg=$msg&ad=${ad ? 1 : 0}';
  static String getAboutRoute() => about;
  static String getRankingRoute() => ranking;

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => getRoute(const DashboardScreen(pageIndex: 0))),
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: maintenance, page: () => getRoute(const MaintenanceScreen())),
    GetPage(name: update, page: () => getRoute(const UpdateScreen())),
    GetPage(name: language, page: () => const ChooseLanguageScreen()),
    GetPage(name: unknown_source, page: () => const UnknownSourceScreen()),
    GetPage(name: tic_tac_tow, page: () => TicTacToeGameScreen(banner: Get.parameters['banner'])),
    GetPage(name: scratch_and_win, page: () => ScratchAndWinGameScreen(banner: Get.parameters['banner'])),
    GetPage(name: lucky_table, page: () => LuckyTableGameScreen(banner: Get.parameters['banner'])),
    GetPage(name: spin_to_win, page: () => SpinToWindScreen(banner: Get.parameters['banner'])),
    GetPage(name: playing_card, page: () => PlayingCardScreen(banner: Get.parameters['banner'])),
    GetPage(name: sign_in, page: () => SignInScreen(
      exitFromApp: Get.parameters['page'] == sign_in || Get.parameters['page'] == splash,
    )),
    GetPage(name: sign_up, page: () => const SignUpScreen()),
    GetPage(name: html, page: () => HtmlViewerScreen(
      htmlType: Get.parameters['page'] == 'terms-and-condition' ? HtmlType.TERMS_AND_CONDITION
          : Get.parameters['page'] == 'privacy-policy' ? HtmlType.PRIVACY_POLICY
          : Get.parameters['page'] == 'shipping-policy' ? HtmlType.SHIPPING_POLICY
          : Get.parameters['page'] == 'cancellation-policy' ? HtmlType.CANCELATION
          : Get.parameters['page'] == 'refund-policy' ? HtmlType.REFUND : HtmlType.ABOUT_US,
    )),
    GetPage(name: award, page: () {
      String coin = Get.parameters['coin'];
      String title = Get.parameters['title'];
      String msg = Get.parameters['msg'];
      bool ad = Get.parameters['ad'] == '1';
      return AwardScreen(coin: coin, title: title, msg: msg, ad: ad);
    }),
    GetPage(name: about, page: () => const AboutScreen()),
    GetPage(name: ranking, page: () => const RankingScreen())
  ];

  static getRoute(Widget navigateTo) {
    var config = Get.find<SplashController>().configModel;
    if(config.maintenance){
      return const MaintenanceScreen();
    }
    return navigateTo;
  }
}