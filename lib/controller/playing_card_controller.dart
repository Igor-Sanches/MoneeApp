import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monetization/view/base/custom_snackbar.dart';
import 'package:playing_cards/src/model/suit.dart';

import '../data/model/response/game_model.dart';
import '../data/repository/playing_card_repo.dart';
import '../helper/helpers.dart';
import '../helper/route_helper.dart';
import '../util/admob_service.dart';
import '../util/images.dart';
import '../util/songs.dart';

class PlayingCardController extends GetxController implements GetxService {
  final PlayingCardRepo playingCardRepo;
  PlayingCardController({@required this.playingCardRepo});
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
  Suit card1;
  Suit card2;
  Suit card3;
  Suit card4;
  bool showCard1 = false;
  bool showCard2 = false;
  bool showCard3 = false;
  bool showCard4 = false;

  Game game;
  bool gameOver = false;
  int coin = 0;

  bool loading = true;
  bool errorWithServer = true;

  String get coinWin => '$coin';

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
          Get.toNamed(RouteHelper.getAwardRoute(
              coin,
              'happy'.tr,
              'msg_playing_card_award'.tr,
              true
          ));
        }).onError((error, stackTrace) {
      Get.context.loaderOverlay.hide();
    });
    rewardedinterstitialAd = null;
  }

  Future<bool> connectWithServe() async{
    loading = true;
    initAd = false;
    update();
    Response response = await playingCardRepo.connectWithServe();
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
    if(game != null){
      coin = Random().nextInt(game.maxCoin - 1) + 1;
    }
    gameOver = false;
    showCard1 = false;
    showCard2 = false;
    showCard3 = false;
    showCard4 = false;

    int position = int.parse('${DateTime.now().microsecond}'.substring(0, 1));
    switch(position){
      case 1:
      case 5:
        card3 = Suit.clubs;
        card2 = Suit.diamonds;
        card1 = Suit.hearts;
        card4 = Suit.spades;
        break;
      case 2:
      case 6:
        card3 = Suit.clubs;
        card1 = Suit.diamonds;
        card2 = Suit.hearts;
        card4 = Suit.spades;
        break;
      case 3:
      case 8:
      case 7:
        card2 = Suit.clubs;
        card1 = Suit.diamonds;
        card3 = Suit.hearts;
        card4 = Suit.spades;
        break;
      case 4:
      case 9:
        card2 = Suit.clubs;
        card1 = Suit.diamonds;
        card4 = Suit.hearts;
        card3 = Suit.spades;
        break;
    }
    gameOver = false;
    update();
  }

  Future<void> setupCoin(coin, {format}) async{
     await playingCardRepo.saveGameCoins(coin);
  }

  cardSelected(Suit card, int position) {
    if(gameOver){
      return;
    }
    switch(position){
      case 1: showCard1 = true; break;
      case 2: showCard2 = true; break;
      case 3: showCard3 = true; break;
      case 4: showCard4 = true; break;
    }
    Get.context.loaderOverlay.show();
    if(card == Suit.hearts && !gameOver){
      isRewardedOpen = false;
      createRewardedInterstitialAd();
    }else{
      Helpers.playSound(Songs.gameover);
      isOpen = false;
      isRewardedOpen = false;
      if(Random().nextBool()){
        _createInterstitialAd();
      }else{
        _createRewardedAd();
      }
    }
    gameOver = true;
    update();
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
}
