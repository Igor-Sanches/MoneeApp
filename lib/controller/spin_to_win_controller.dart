import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../data/model/response/game_model.dart';
import '../data/repository/lucky_table_repo.dart';
import '../data/repository/scratch_and_win_repo.dart';
import '../data/repository/spin_to_win_repo.dart';
import '../helper/helpers.dart';
import '../helper/route_helper.dart';
import '../util/images.dart';
import '../util/songs.dart';
import '../view/base/custom_snackbar.dart';

class SpinToWinController extends GetxController implements GetxService {
  final SpinToWinRepo spinToWinRepo;
  SpinToWinController({@required this.spinToWinRepo});
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
  List<String> items = [];
  List<int> itemsInt = [];
  Game game;
  bool gameOver = false;

  int coin = 0;

  bool loading = true;
  bool errorWithServer = true;

  String get coinWin => '$coin';

  get spinToWinDay => spinToWinRepo.spinToWinDay();

  int get positionSpin => Fortune.randomInt(0, items.length);

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
          spinToWinRepo.putDay();
          update();
          setupCoin(coin);
          Get.toNamed(RouteHelper.getAwardRoute(
              coin,
              'happy'.tr,
              'msg_spin_to_win_award'.tr,
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
    Response response = await spinToWinRepo.connectWithServe();
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
    initAd = false;
    gameOver = false;
    int _1 = Random().nextInt(30);
    int _2 = Random().nextInt(30);
    int _3 = Random().nextInt(30);
    int _4 = Random().nextInt(30);
    int _5 = Random().nextInt(30);
    int _6 = Random().nextInt(30);
    int _7 = Random().nextInt(30);
    int _8 = Random().nextInt(30);
    String spin_1 = _1 == 1 ? '1 Moeda' : '$_1 Moedas';
    String spin_2 = _2 == 1 ? '1 Moeda' : '$_2 Moedas';
    String spin_3 = _3 == 1 ? '1 Moeda' : '$_3 Moedas';
    String spin_4 = _4 == 1 ? '1 Moeda' : '$_4 Moedas';
    String spin_5 = _5 == 1 ? '1 Moeda' : '$_5 Moedas';
    String spin_6 = _6 == 1 ? '1 Moeda' : '$_6 Moedas';
    String spin_7 = _7 == 1 ? '1 Moeda' : '$_7 Moedas';
    String spin_8 = _8 == 1 ? '1 Moeda' : '$_8 Moedas';
    items = [
      spin_1, spin_2, spin_3, spin_4, spin_5, spin_6, spin_7, spin_8
    ];
    itemsInt = [
      _1, _2, _3, _4, _5, _6, _7, _8
    ];
    update();
  }

  Future<void> setupCoin(coin, {format}) async{
     await spinToWinRepo.saveGameCoins(coin);
  }

 bool init = false;
  coinGenerate() {
    coin = Random().nextInt(game.maxCoin);
    return coin;
  }

  void setupGame(int item) {
    coin = itemsInt.elementAt(item);
    isRewardedOpen = false;
    Get.context.loaderOverlay.show();
    createRewardedInterstitialAd();
    gameOver = true;
    update();
  }

}
