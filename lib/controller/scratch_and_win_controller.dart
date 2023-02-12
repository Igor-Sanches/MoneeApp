import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../data/model/response/game_model.dart';
import '../data/repository/scratch_and_win_repo.dart';
import '../helper/helpers.dart';
import '../helper/route_helper.dart';
import '../util/images.dart';
import '../util/songs.dart';
import '../view/base/custom_snackbar.dart';

class ScratchAndWinController extends GetxController implements GetxService {
  final ScratchAndWinRepo scratchAndWinRepo;
  ScratchAndWinController({@required this.scratchAndWinRepo});
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
  bool isThreshold = false;
  String scratch_1 = Images.scratch_1;
  String scratch_2 = Images.scratch_2;
  String scratch_3 = Images.scratch_3;
  String scratch_4 = Images.scratch_4;
  String scratch_5 = Images.scratch_5;
  String scratch_6 = Images.scratch_6;
  String scratch_7 = Images.scratch_7;
  String scratch_8 = Images.scratch_8;
  String scratch_9 = Images.scratch_9;
  Map<String, bool> scratch = {
    'scratch_1':false,
    'scratch_2':false,
    'scratch_3':false,
    'scratch_4':false,
    'scratch_5':false,
    'scratch_6':false,
    'scratch_7':false,
    'scratch_8':false,
    'scratch_9':false,
  };

  int coin = 0;

  bool loading = true;
  bool errorWithServer = true;

  String get coinWin => '$coin';

  void createRewardedInterstitialAd(coin, title, msg, format) {
    RewardedInterstitialAd.load(
        adUnitId: game.intersticialRewarded,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            rewardedinterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
            rewardedinterstitialAd.setImmersiveMode(true);
            if(!isRewardedOpen){
              _showRewardedInterstitialAd(coin, title, msg, format);
              isRewardedOpen = true;
            }
          },
          onAdFailedToLoad: (LoadAdError error) {
            Get.context.loaderOverlay.hide();
            showCustomSnackBar('couldnt_save_your_reward_because_of_the_ad'.tr);
            _numRewardedInterstitialLoadAttempts += 1;
            rewardedinterstitialAd = null;
            if (_numRewardedInterstitialLoadAttempts < maxRewardedInterstitialFailedLoadAttempts) {
              createRewardedInterstitialAd(coin, title, msg, format);
            }
          },
        ));
  }

  void _showRewardedInterstitialAd(coin, title, msg, format) {
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
          if(format != null){
            setupCoin(coin, format: format);
          }else{
            setupCoin(coin);
          }
          Timer.periodic(const Duration(seconds: 2), (timer) {
            timer.cancel();
            Get.toNamed(RouteHelper.getAwardRoute(
                coin,
                'happy'.tr,
                'msg_scratch_and_win_award'.tr,
                true
            ));
          });
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
    Response response = await scratchAndWinRepo.connectWithServe();
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
    startGame();
    update();
  }

  startGame() {
    if(game != null){
      coin = Random().nextInt(game.maxCoin - 1) + 1;
    }
    scratch = {
      'scratch_1':false,
      'scratch_2':false,
      'scratch_3':false,
      'scratch_4':false,
      'scratch_5':false,
      'scratch_6':false,
      'scratch_7':false,
      'scratch_8':false,
      'scratch_9':false,
    };
    scratch_1 = Images.scratch_1;
    scratch_2 = Images.scratch_2;
    scratch_3 = Images.scratch_3;
    scratch_4 = Images.scratch_4;
    scratch_5 = Images.scratch_5;
    scratch_6 = Images.scratch_6;
    scratch_7 = Images.scratch_7;
    scratch_8 = Images.scratch_8;
    scratch_9 = Images.scratch_9;
    var index1 = 0, index2 = 0, index3 = 0;
    bool startWhile = true;
    while(startWhile){
      index1 = Random().nextInt(8) + 1;
      index2 = Random().nextInt(8) + 1;
      index3 = Random().nextInt(8) + 1;
      if(index1 != index2 && index2 != index3 && index3 != index1){
        startWhile = false;
      }
    }

    switch(index1){
      case 1: scratch_1 = Images.logo; break;
      case 2: scratch_2 = Images.logo; break;
      case 3: scratch_3 = Images.logo; break;
      case 4: scratch_4 = Images.logo; break;
      case 5: scratch_5 = Images.logo; break;
      case 6: scratch_6 = Images.logo; break;
      case 7: scratch_7 = Images.logo; break;
      case 8: scratch_8 = Images.logo; break;
      case 9: scratch_9 = Images.logo; break;
    }
    switch(index2){
      case 1: scratch_1 = Images.logo; break;
      case 2: scratch_2 = Images.logo; break;
      case 3: scratch_3 = Images.logo; break;
      case 4: scratch_4 = Images.logo; break;
      case 5: scratch_5 = Images.logo; break;
      case 6: scratch_6 = Images.logo; break;
      case 7: scratch_7 = Images.logo; break;
      case 8: scratch_8 = Images.logo; break;
      case 9: scratch_9 = Images.logo; break;
    }
    switch(index3){
      case 1: scratch_1 = Images.logo; break;
      case 2: scratch_2 = Images.logo; break;
      case 3: scratch_3 = Images.logo; break;
      case 4: scratch_4 = Images.logo; break;
      case 5: scratch_5 = Images.logo; break;
      case 6: scratch_6 = Images.logo; break;
      case 7: scratch_7 = Images.logo; break;
      case 8: scratch_8 = Images.logo; break;
      case 9: scratch_9 = Images.logo; break;
    }
    update();
  }

  Future<void> setupCoin(coin, {format}) async{
     await scratchAndWinRepo.saveGameCoins(coin, format: format);
  }

  onThreshold() {
    isThreshold = true;
    update();
    isRewardedOpen = false;
    createRewardedInterstitialAd(coin, 'happy'.tr, 'happy_3'.tr, null);
    Helpers.playSound(Songs.victory);

  }

  bool gameOver = false;
  onChange(int index, String scratchS) {
    if(!scratch[scratchS]){
      scratch[scratchS] = true;
      List<String> format = [];
      bool result = false;
      if(scratch.values.where((element) => element).toList().length == 3){
        scratch.entries.toList().forEach((element) {
          if(element.value){
            switch(element.key){
              case 'scratch_1':
                result = scratch_1 == Images.logo;
                if(result){
                  format.add('scratch_1');
                }
                break;
              case 'scratch_2':
                result = scratch_2 == Images.logo;
                if(result){
                  format.add('scratch_2');
                }
                break;
              case 'scratch_3':
                result = scratch_3 == Images.logo;
                if(result){
                  format.add('scratch_3');
                }
                break;
              case 'scratch_4':
                result = scratch_4 == Images.logo;
                if(result){
                  format.add('scratch_4');
                }
                break;
              case 'scratch_5':
                result = scratch_5 == Images.logo;
                if(result){
                  format.add('scratch_5');
                }
                break;
              case 'scratch_6':
                result = scratch_6 == Images.logo;
                if(result){
                  format.add('scratch_6');
                }
                break;
              case 'scratch_7':
                result = scratch_7 == Images.logo;
                if(result){
                  format.add('scratch_7');
                }
                break;
              case 'scratch_8':
                result = scratch_8 == Images.logo;
                if(result){
                  format.add('scratch_8');
                }
                break;
              case 'scratch_9':
                result = scratch_9 == Images.logo;
                if(result){
                  format.add('scratch_9');
                }
                break;
            }
          }
        });
        Get.context.loaderOverlay.show();
        if(result){
          var coin = Random().nextInt(99)+1;
          isRewardedOpen = false;
          createRewardedInterstitialAd(coin, 'happy'.tr, 'happy_2'.tr, format.toString());
        }else{
          Helpers.playSound(Songs.gameover);
        }
        gameOver = true;
        update();
      }
    }
  }

  bool get isForNewGame => gameOver && isThreshold && scratch.values.where((element) => element).toList().length == 3;

}
