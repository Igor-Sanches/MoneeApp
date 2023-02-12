import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monetization/view/base/custom_snackbar.dart';

import '../data/model/response/game_model.dart';
import '../data/repository/lucky_table_repo.dart';
import '../data/repository/scratch_and_win_repo.dart';
import '../helper/helpers.dart';
import '../helper/route_helper.dart';
import '../util/images.dart';
import '../util/songs.dart';

class LuckyTableController extends GetxController implements GetxService {
  final LuckyTableRepo luckyTableRepo;
  LuckyTableController({@required this.luckyTableRepo});
  InterstitialAd interstitialAd;
  RewardedInterstitialAd rewardedinterstitialAd;
  RewardedAd rewardedAd;
  int _numRewardedLoadAttempts = 0;
  int maxRewardedInterstitialFailedLoadAttempts = 0;
  int _numRewardedInterstitialLoadAttempts = 0;
  int maxRewardedFailedLoadAttempts = 3;
  int _numInterstitialLoadAttempts = 0;
  int maxFailedLoadAttempts = 3;
  bool isRewardedOpen = false;
  bool isOpen = false;
  bool initAd = false;
  Game game;
  bool gameOver = false;
  final int _1 = Random().nextInt(59) + 1;
  final int _2 = Random().nextInt(59) + 1;
  final int _3 = Random().nextInt(59) + 1;
  final int _4 = Random().nextInt(59) + 1;
  final int _5 = Random().nextInt(59) + 1;
  final int _6 = Random().nextInt(59) + 1;
  final int _7 = Random().nextInt(59) + 1;
  final int _8 = Random().nextInt(59) + 1;
  final int _9 = Random().nextInt(59) + 1;
  final int _10 = Random().nextInt(59) + 1;
  final int _11 = Random().nextInt(59) + 1;
  final int _12 = Random().nextInt(59) + 1;
  final int _13 = Random().nextInt(59) + 1;
  final int _14 = Random().nextInt(59) + 1;
  final int _15 = Random().nextInt(59) + 1;
  final int _16 = Random().nextInt(59) + 1;
  final int _17 = Random().nextInt(59) + 1;
  final int _18 = Random().nextInt(59) + 1;
  final int _19 = Random().nextInt(59) + 1;
  final int _20 = Random().nextInt(59) + 1;
  final int _21 = Random().nextInt(59) + 1;
  final int _22 = Random().nextInt(59) + 1;
  final int _23 = Random().nextInt(59) + 1;
  final int _24 = Random().nextInt(59) + 1;
  final int _25 = Random().nextInt(59) + 1;
  final int _26 = Random().nextInt(59) + 1;
  final int _27 = Random().nextInt(59) + 1;
  final int _28 = Random().nextInt(59) + 1;
  final int _29 = Random().nextInt(59) + 1;
  final int _30 = Random().nextInt(59) + 1;
  final int _31 = Random().nextInt(59) + 1;
  final int _32 = Random().nextInt(59) + 1;
  final int _33 = Random().nextInt(59) + 1;
  final int _34 = Random().nextInt(59) + 1;
  final int _35 = Random().nextInt(59) + 1;
  final int _36 = Random().nextInt(59) + 1;
  final int _37 = Random().nextInt(59) + 1;
  final int _38 = Random().nextInt(59) + 1;
  final int _39 = Random().nextInt(59) + 1;
  final int _40 = Random().nextInt(59) + 1;
  int get scratch_1 => _1 >= 41 ? 0 : _1;
  int get scratch_2 => _2 >= 41 ? 0 : _2;
  int get scratch_3 => _3 >= 41 ? 0 : _3;
  int get scratch_4 => _4 >= 41 ? 0 : _4;
  int get scratch_5 => _5 >= 41 ? 0 : _5;
  int get scratch_6 => _6 >= 41 ? 0 : _6;
  int get scratch_7 => _7 >= 41 ? 0 : _7;
  int get scratch_8 => _8 >= 41 ? 0 : _8;
  int get scratch_9 => _9 >= 41 ? 0 : _9;
  int get scratch_10 => _10 >= 41 ? 0 : _10;
  int get scratch_11 => _11 >= 41 ? 0 : _11;
  int get scratch_12 => _12 >= 41 ? 0 : _12;
  int get scratch_13 => _13 >= 41 ? 0 : _13;
  int get scratch_14 => _14 >= 41 ? 0 : _14;
  int get scratch_15 => _15 >= 41 ? 0 : _15;
  int get scratch_16 => _16 >= 41 ? 0 : _16;
  int get scratch_17 => _17 >= 41 ? 0 : _17;
  int get scratch_18 => _18 >= 41 ? 0 : _18;
  int get scratch_19 => _19 >= 41 ? 0 : _19;
  int get scratch_20 => _20 >= 41 ? 0 : _20;
  int get scratch_21 => _21 >= 41 ? 0 : _21;
  int get scratch_22 => _22 >= 41 ? 0 : _22;
  int get scratch_23 => _23 >= 41 ? 0 : _23;
  int get scratch_24 => _24 >= 41 ? 0 : _24;
  int get scratch_25 => _25 >= 41 ? 0 : _25;
  int get scratch_26 => _26 >= 41 ? 0 : _26;
  int get scratch_27 => _27 >= 41 ? 0 : _27;
  int get scratch_28 => _28 >= 41 ? 0 : _28;
  int get scratch_29 => _29 >= 41 ? 0 : _29;
  int get scratch_30 => _30 >= 41 ? 0 : _30;
  int get scratch_31 => _31 >= 41 ? 0 : _31;
  int get scratch_32 => _32 >= 41 ? 0 : _32;
  int get scratch_33 => _33 >= 41 ? 0 : _33;
  int get scratch_34 => _34 >= 41 ? 0 : _34;
  int get scratch_35 => _35 >= 41 ? 0 : _35;
  int get scratch_36 => _36 >= 41 ? 0 : _36;
  int get scratch_37 => _37 >= 41 ? 0 : _37;
  int get scratch_38 => _38 >= 41 ? 0 : _38;
  int get scratch_39 => _39 >= 41 ? 0 : _39;
  int get scratch_40 => _40 >= 41 ? 0 : _40;

  int coin = 0;

  bool loading = true;
  bool errorWithServer = true;

  String get coinWin => '$coin';

  get luckyTableDay => luckyTableRepo.luckyTableDay();

  void createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: game.intersticialRewarded,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            rewardedinterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
            rewardedinterstitialAd.setImmersiveMode(true);
            if(!isRewardedOpen){
              _showRewardedInterstitialAd();
              isRewardedOpen = true;
            }
          },
          onAdFailedToLoad: (LoadAdError error) {
            Get.context.loaderOverlay.hide();
            showCustomSnackBar('couldnt_save_your_reward_because_of_the_ad'.tr);
            _numRewardedInterstitialLoadAttempts += 1;
            rewardedinterstitialAd = null;
            if (_numRewardedInterstitialLoadAttempts < maxRewardedInterstitialFailedLoadAttempts) {
              createRewardedInterstitialAd();
            }
          },
        ));
  }

  void _showRewardedInterstitialAd() {
    if (rewardedinterstitialAd == null) {
      Get.context.loaderOverlay.hide();
      return;
    }
    rewardedinterstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        ad.dispose();
        Get.context.loaderOverlay.hide();
      },
      onAdFailedToShowFullScreenContent: (RewardedInterstitialAd ad, AdError error) {
        Get.context.loaderOverlay.hide();
        ad.dispose();
      },
    );
    rewardedinterstitialAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          Get.context.loaderOverlay.hide();
          setupCoin(coin);
          luckyTableRepo.putDay();
          update();
          Get.toNamed(RouteHelper.getAwardRoute(
              coin,
              'happy'.tr,
              'msg_lucky_table_award'.tr,
              true
          ));
        }).onError((error, stackTrace) {
      Get.context.loaderOverlay.hide();
    });
    rewardedinterstitialAd = null;
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: game.intersticial,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            interstitialAd.setImmersiveMode(true);
            if(!isOpen){
              _showInterstitialAd();
              isOpen = true;
            }
          },
          onAdFailedToLoad: (LoadAdError error) {
            Get.context.loaderOverlay.hide();
            initAd = true;
            update();
            _numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void _showInterstitialAd() {
    if (interstitialAd == null) {
      Get.context.loaderOverlay.hide();
      return;
    }
    interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        Get.context.loaderOverlay.hide();
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        Get.context.loaderOverlay.hide();
        ad.dispose();
      },
    );
    interstitialAd.show();
    interstitialAd = null;
    initAd = true;
    update();
  }

  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: game.rewarded,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
            _showRewardedAd();
          },
          onAdFailedToLoad: (LoadAdError error) {
            Get.context.loaderOverlay.hide();
            rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxRewardedFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void _showRewardedAd() {
    if (rewardedAd == null) {
      Get.context.loaderOverlay.hide();
      return;
    }
    rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        Get.context.loaderOverlay.hide();
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        Get.context.loaderOverlay.hide();
        ad.dispose();
      },
    );

    rewardedAd.setImmersiveMode(true);
    rewardedAd.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {

        });
    rewardedAd = null;
  }

  Future<void> connectWithServe() async{
    loading = true;
    initAd = false;
    update();
    Response response = await luckyTableRepo.connectWithServe();
    loading = false;
    if (response.statusCode == 200) {
      errorWithServer = false;
      game = Game.fromJson(response.body['data']['game']);
      coin = Random().nextInt(game.maxCoin - 1) + 1;
      isOpen = false;
      update();
      _createInterstitialAd();
      return true;
    } else {
      errorWithServer = true;
    }
    update();
    return false;
  }

  void startData(){
    gameOver = false;
    update();
  }

  Future<void> setupCoin(coin, {format}) async{
     await luckyTableRepo.saveGameCoins(coin);
  }

  onChange(int coin) {
   if(!gameOver){
     if(luckyTableDay){
       return;
     }
     Get.context.loaderOverlay.show();
     isRewardedOpen = false;
     createRewardedInterstitialAd();
    }
    gameOver = true;
 }

}
