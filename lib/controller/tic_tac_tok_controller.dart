import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monetization/view/base/custom_snackbar.dart';

import '../data/model/response/game_model.dart';
import '../data/repository/tic_tac_toc_repo.dart';
import '../helper/helpers.dart';
import '../helper/route_helper.dart';
import '../util/images.dart';
import '../util/songs.dart';

class TicTacToeController extends GetxController implements GetxService {
  final TicTacToeRep ticTacTokRepo;
  TicTacToeController({@required this.ticTacTokRepo});
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
  String get _x => 'X';
  String get _o => 'O';
  String get _false => 'false';
  bool loading = true;
  bool errorWithServer = true;
  Map<String, bool> victoryGame = {
    'selected1':false,
    'selected2':false,
    'selected3':false,
    'selected4':false,
    'selected5':false,
    'selected6':false,
    'selected7':false,
    'selected8':false,
    'selected9':false,
  };

  String selected1 = 'false';
  String selected2 = 'false';
  String selected3 = 'false';
  String selected4 = 'false';
  String selected5 = 'false';
  String selected6 = 'false';
  String selected7 = 'false';
  String selected8 = 'false';
  String selected9 = 'false';
  bool computerStartsTheGame = false;
  bool processing = false;
  bool gameOver = false;
  bool start = true;
  int victories = 0;
  int defeats = 0;
  int ties = 0;

  get _win {
    String result = '';
    if(selected1 == _o && selected2 == _o && selected3 == _o){
      result = '1 - 2 - 3';
    }else if(selected4 == _o && selected5 == _o && selected6 == _o){
      result = '4 - 5 - 6';
    }else if(selected7 == _o && selected8 == _o && selected9 == _o){
      result = '7 - 8 - 9';
    }else if(selected1 == _o && selected4 == _o && selected7 == _o){
      result = '1 - 4 - 7';
    }else if(selected2 == _o && selected5 == _o && selected8 == _o){
      result = '2 - 5 - 8';
    }else if(selected3 == _o && selected6 == _o && selected9 == _o){
      result = '3 - 6 - 9';
    }else if(selected1 == _o && selected5 == _o && selected9 == _o){
      result = '1 - 5 - 9';
    }else if(selected3 == _o && selected5 == _o && selected7 == _o){
      result = '3 - 5 - 7';
    }
    return result;
  }


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
          int coin = Random().nextInt(5) + 1;
          setupCoin(coin);
          ticTacTokRepo.addVictory();
          victories = ticTacTokRepo.victories();
          update();
          Get.toNamed(RouteHelper.getAwardRoute(
              coin,
              'happy'.tr,
              'msg_tic_tac_toe_award'.tr,
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
    Response response = await ticTacTokRepo.connectWithServe();
    loading = false;
    if (response.statusCode == 200) {
      errorWithServer = false;
      game = Game.fromJson(response.body['data']['game']);
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
    victories = ticTacTokRepo.victories();
    defeats = ticTacTokRepo.defeats();
    ties = ticTacTokRepo.ties();
    selected1 = 'false';
    selected2 = 'false';
    selected3 = 'false';
    selected4 = 'false';
    selected5 = 'false';
    selected6 = 'false';
    selected7 = 'false';
    selected8 = 'false';
    selected9 = 'false';
    victoryGame = {
      'selected1':false,
      'selected2':false,
      'selected3':false,
      'selected4':false,
      'selected5':false,
      'selected6':false,
      'selected7':false,
      'selected8':false,
      'selected9':false,
    };
    processing = false;
    gameOver = false;
    start = true;
    update();
  }

  bool x = false;
  void goSelect(int selected) {
    if(start){
      return;
    }
    if(gameOver){
      return;
    }
    if(processing){
      showCustomSnackBar('wait_your_turn'.tr);
      return;
    }
    switch(selected){
      case 1:
        if(selected1 == _false){
          selected1 = x ? _x : _o;
        }
        break;
      case 2:
        if(selected2 == _false){
          selected2 = x ? _x : _o;
        }
        break;
      case 3:
        if(selected3 == _false){
          selected3 = x ? _x : _o;
        }
        break;
      case 4:
        if(selected4 == _false){
          selected4 = x ? _x : _o;
        }
        break;
      case 5:
        if(selected5 == _false){
          selected5 = x ? _x : _o;
        }
        break;
      case 6:
        if(selected6 == _false){
          selected6 = x ? _x : _o;
        }
        break;
      case 7:
        if(selected7 == _false){
          selected7 = x ? _x : _o;
        }
        break;
      case 8:
        if(selected8 == _false){
          selected8 = x ? _x : _o;
        }
        break;
      case 9:
        if(selected9 == _false){
          selected9 = x ? _x : _o;
        }
        break;
    }
    update();
    var result = _checkIfCheck();
    if(result['play-win']){
      playerVictory();
    }else if(result['ties']){
      _ties();
    }else{
      computer();
    }
  }

  Map<String, dynamic> _checkIfCheck(){
    if(selected1 == _x && selected2 == _x && selected3 == _x){
      victoryGame = {
        'selected1':true,
        'selected2':true,
        'selected3':true,
        'selected4':false,
        'selected5':false,
        'selected6':false,
        'selected7':false,
        'selected8':false,
        'selected9':false,
      };
      return {
        'play-win':false,
        'computer-win':true,
        'ties':false
      };
    }else if(selected4 == _x && selected5 == _x && selected6 == _x){
      victoryGame = {
        'selected1':false,
        'selected2':false,
        'selected3':false,
        'selected4':true,
        'selected5':true,
        'selected6':true,
        'selected7':false,
        'selected8':false,
        'selected9':false,
      };
      return {
        'play-win':false,
        'computer-win':true,
        'ties':false
      };
    }else if(selected7 == _x && selected8 == _x && selected9 == _x){
      victoryGame = {
        'selected1':false,
        'selected2':false,
        'selected3':false,
        'selected4':false,
        'selected5':false,
        'selected6':false,
        'selected7':true,
        'selected8':true,
        'selected9':true,
      };
      return {
        'play-win':false,
        'computer-win':true,
        'ties':false
      };
    }else if(selected1 == _x && selected4 == _x && selected7 == _x){
      victoryGame = {
        'selected1':true,
        'selected2':false,
        'selected3':false,
        'selected4':true,
        'selected5':false,
        'selected6':false,
        'selected7':true,
        'selected8':false,
        'selected9':false,
      };
      return {
        'play-win':false,
        'computer-win':true,
        'ties':false
      };
    }else if(selected2 == _x && selected5 == _x && selected8 == _x){
      victoryGame = {
        'selected1':false,
        'selected2':true,
        'selected3':false,
        'selected4':false,
        'selected5':true,
        'selected6':false,
        'selected7':false,
        'selected8':true,
        'selected9':false,
      };
      return {
        'play-win':false,
        'computer-win':true,
        'ties':false
      };
    }else if(selected3 == _x && selected6 == _x && selected9 == _x){
      victoryGame = {
        'selected1':false,
        'selected2':false,
        'selected3':true,
        'selected4':false,
        'selected5':false,
        'selected6':true,
        'selected7':false,
        'selected8':false,
        'selected9':true,
      };
      return {
        'play-win':false,
        'computer-win':true,
        'ties':false
      };
    }else if(selected1 == _x && selected5 == _x && selected9 == _x){
      victoryGame = {
        'selected1':true,
        'selected2':false,
        'selected3':false,
        'selected4':false,
        'selected5':true,
        'selected6':false,
        'selected7':false,
        'selected8':false,
        'selected9':true,
      };
      return {
        'play-win':false,
        'computer-win':true,
        'ties':false
      };
    }else if(selected3 == _x && selected5 == _x && selected7 == _x){
      victoryGame = {
        'selected1':false,
        'selected2':false,
        'selected3':true,
        'selected4':false,
        'selected5':true,
        'selected6':false,
        'selected7':true,
        'selected8':false,
        'selected9':false,
      };
      return {
        'play-win':false,
        'computer-win':true,
        'ties':false
      };
    }

    if(selected1 == _o && selected2 == _o && selected3 == _o){
      victoryGame = {
        'selected1':true,
        'selected2':true,
        'selected3':true,
        'selected4':false,
        'selected5':false,
        'selected6':false,
        'selected7':false,
        'selected8':false,
        'selected9':false,
      };
      return {
        'play-win':true,
        'computer-win':false,
        'ties':false
      };
    }else if(selected4 == _o && selected5 == _o && selected6 == _o){
      victoryGame = {
        'selected1':false,
        'selected2':false,
        'selected3':false,
        'selected4':true,
        'selected5':true,
        'selected6':true,
        'selected7':false,
        'selected8':false,
        'selected9':false,
      };
      return {
        'play-win':true,
        'computer-win':false,
        'ties':false
      };
    }else if(selected7 == _o && selected8 == _o && selected9 == _o){
      victoryGame = {
        'selected1':false,
        'selected2':false,
        'selected3':false,
        'selected4':false,
        'selected5':false,
        'selected6':false,
        'selected7':true,
        'selected8':true,
        'selected9':true,
      };
      return {
        'play-win':true,
        'computer-win':false,
        'ties':false
      };
    }else if(selected1 == _o && selected4 == _o && selected7 == _o){
      victoryGame = {
        'selected1':true,
        'selected2':false,
        'selected3':false,
        'selected4':true,
        'selected5':false,
        'selected6':false,
        'selected7':true,
        'selected8':false,
        'selected9':false,
      };
      return {
        'play-win':true,
        'computer-win':false,
        'ties':false
      };
    }else if(selected2 == _o && selected5 == _o && selected8 == _o){
      victoryGame = {
        'selected1':false,
        'selected2':true,
        'selected3':false,
        'selected4':false,
        'selected5':true,
        'selected6':false,
        'selected7':false,
        'selected8':true,
        'selected9':false,
      };
      return {
        'play-win':true,
        'computer-win':false,
        'ties':false
      };
    }else if(selected3 == _o && selected6 == _o && selected9 == _o){
      victoryGame = {
        'selected1':false,
        'selected2':false,
        'selected3':true,
        'selected4':false,
        'selected5':false,
        'selected6':true,
        'selected7':false,
        'selected8':false,
        'selected9':true,
      };
      return {
        'play-win':true,
        'computer-win':false,
        'ties':false
      };
    }else if(selected1 == _o && selected5 == _o && selected9 == _o){
      victoryGame = {
        'selected1':true,
        'selected2':false,
        'selected3':false,
        'selected4':false,
        'selected5':true,
        'selected6':false,
        'selected7':false,
        'selected8':false,
        'selected9':true,
      };
      return {
        'play-win':true,
        'computer-win':false,
        'ties':false
      };
    }else if(selected3 == _o && selected5 == _o && selected7 == _o){
      victoryGame = {
        'selected1':false,
        'selected2':false,
        'selected3':true,
        'selected4':false,
        'selected5':true,
        'selected6':false,
        'selected7':true,
        'selected8':false,
        'selected9':false,
      };
      return {
        'play-win':true,
        'computer-win':false,
        'ties':false
      };
    }
     var ties = selected1 != _false && selected2 != _false && selected3 != _false && selected4 != _false && selected5 != _false && selected6 != _false &&selected7 != _false &&selected8 != _false && selected9 != _false;
     if(ties){
       return {
         'play-win':false,
         'computer-win':false,
         'ties':true
       };
     }

    return {
      'play-win':false,
      'computer-win':false,
      'ties':false
    };
  }

  startGame() {
    computerStartsTheGame = Random().nextBool();
    start = false;
    if(computerStartsTheGame){
      processing = true;
      computer();
    }
    update();
  }

  void _ties()async {
    await Helpers.playSound(Songs.gameover);
    _pauseGame();
    ticTacTokRepo.addTies();
    ties = ticTacTokRepo.ties();
    isOpen = false;
    isRewardedOpen = false;
    Get.context.loaderOverlay.show();
    if(Random().nextBool()){
      _createInterstitialAd();
    }else{
      _createRewardedAd();
    }
  }

  void computerVictory() async{
    await Helpers.playSound(Songs.gameover);
    _pauseGame();
    ticTacTokRepo.addDefeats();
    defeats = ticTacTokRepo.defeats();
    update();
    isOpen = false;
    isRewardedOpen = false;
    Get.context.loaderOverlay.show();
    if(Random().nextBool()){
      _createInterstitialAd();
    }else{
      _createRewardedAd();
    }
  }

  void playerVictory() async{
    isRewardedOpen = false;
    Get.context.loaderOverlay.show();
    createRewardedInterstitialAd();
    _pauseGame();
  }

  void _pauseGame() {
    processing = false;
    gameOver = true;
    update();
  }

  startNewGame() {
    selected1 = 'false';
    selected2 = 'false';
    selected3 = 'false';
    selected4 = 'false';
    selected5 = 'false';
    selected6 = 'false';
    selected7 = 'false';
    selected8 = 'false';
    selected9 = 'false';
    victoryGame = {
      'selected1':false,
      'selected2':false,
      'selected3':false,
      'selected4':false,
      'selected5':false,
      'selected6':false,
      'selected7':false,
      'selected8':false,
      'selected9':false,
    };
    computerStartsTheGame = Random().nextBool();
    processing = false;
    gameOver = false;
    if(computerStartsTheGame){
      processing = true;
      computer();
    }
    update();
  }

  computer() {
    if(gameOver){
      processing = false;
      return false;
    }
    processing = true;
    Timer.periodic(const Duration(seconds: 2), (timer) {
      timer.cancel();
      //Kill the game if all horizontal columns have 1 to kill
      if(selected1 == _x && selected2 == _x && selected3 == _false){
        selected3 = _x;
      }else if(selected4 == _x && selected5 == _x && selected6 == _false){
        selected6 = _x;
      }else if(selected7 == _x && selected8 == _x && selected9 == _false){
        selected9 = _x;
      }else if(selected1 == _x && selected2 == _false && selected3 == _x){
        selected2 = _x;
      }else if(selected4 == _x && selected5 == _false && selected6 == _x){
        selected5 = _x;
      }else if(selected7 == _x && selected8 == _false && selected9 == _x){
        selected8 = _x;
      }else if(selected1 == _false && selected2 == _x && selected3 == _x){
        selected1 = _x;
      }else if(selected4 == _false && selected5 == _x && selected6 == _x){
        selected4 = _x;
      }else if(selected7 == _false && selected8 == _x && selected9 == _x){
        selected7 = _x;
      }
      //Kill the game if all vertical columns have 1 to kill
      else if(selected1 == _x && selected4 == _x && selected7 == _false){
        selected7 = _x;
      }else if(selected2 == _x && selected5 == _x && selected8 == _false){
        selected8 = _x;
      }else if(selected3 == _x && selected6 == _x && selected9 == _false){
        selected9 = _x;
      }else if(selected1 == _x && selected4 == _false && selected7 == _x){
        selected4 = _x;
      }else if(selected2 == _x && selected5 == _false && selected8 == _x){
        selected5 = _x;
      }else if(selected3 == _x && selected6 == _false && selected9 == _x){
        selected6 = _x;
      }else if(selected1 == _false && selected4 == _x && selected7 == _x){
        selected1 = _x;
      }else if(selected2 == _false && selected5 == _x && selected8 == _x){
        selected2 = _x;
      }else if(selected3 == _false && selected6 == _x && selected9 == _x){
        selected3 = _x;
      }
      //Kill the game if all slanted columns have 1 to kill
      else if(selected1 == _x && selected5 == _x && selected9 == _false){
        selected9 = _x;
      }else if(selected1 == _x && selected5 == _false && selected9 == _x){
        selected5 = _x;
      }else if(selected1 == _false && selected5 == _x && selected9 == _x){
        selected1 = _x;
      }else if(selected3 == _x && selected5 == _x && selected7 == _false){
        selected7 = _x;
      }else if(selected3 == _x && selected5 == _false && selected7 == _x){
        selected5 = _x;
      }else if(selected3 == _false && selected5 == _x && selected7 == _x){
        selected3 = _x;
      }
      //Try to stop the game from killing the game if all horizontal columns have a 1 to kill
      else if(selected1 == _o && selected2 == _o && selected3 == _false){
        selected3 = _x;
      }else if(selected4 == _o && selected5 == _o && selected6 == _false){
        selected6 = _x;
      }else if(selected7 == _o && selected8 == _o && selected9 == _false){
        selected9 = _x;
      }else if(selected1 == _o && selected2 == _false && selected3 == _o){
        selected2 = _x;
      }else if(selected4 == _o && selected5 == _false && selected6 == _o){
        selected5 = _x;
      }else if(selected7 == _o && selected8 == _false && selected9 == _o){
        selected8 = _x;
      }else if(selected1 == _false && selected2 == _o && selected3 == _o){
        selected1 = _x;
      }else if(selected4 == _false && selected5 == _o && selected6 == _o){
        selected4 = _x;
      }else if(selected7 == _false && selected8 == _o && selected9 == _o){
        selected7 = _x;
      }
      //Try to stop the game from killing the game if all vertical columns have 1 to kill
      else if(selected1 == _o && selected4 == _o && selected7 == _false){
        selected7 = _x;
      }else if(selected2 == _o && selected5 == _o && selected8 == _false){
        selected8 = _x;
      }else if(selected3 == _o && selected6 == _o && selected9 == _false){
        selected9 = _x;
      }else if(selected1 == _o && selected4 == _false && selected7 == _o){
        selected4 = _x;
      }else if(selected2 == _o && selected5 == _false && selected8 == _o){
        selected5 = _x;
      }else if(selected3 == _o && selected6 == _false && selected9 == _o){
        selected6 = _x;
      }else if(selected1 == _false && selected4 == _o && selected7 == _o){
        selected1 = _x;
      }else if(selected2 == _false && selected5 == _o && selected8 == _o){
        selected2 = _x;
      }else if(selected3 == _false && selected6 == _o && selected9 == _o){
        selected3 = _x;
      }
      //Try to stop the game from killing the game if all slanted columns have 1 to kill
      else if(selected1 == _o && selected5 == _o && selected9 == _false){
        selected9 = _x;
      }else if(selected1 == _o && selected5 == _false && selected9 == _o){
        selected5 = _x;
      }else if(selected1 == _false && selected5 == _o && selected9 == _o){
        selected1 = _x;
      }else if(selected3 == _o && selected5 == _o && selected7 == _false){
        selected7 = _x;
      }else if(selected3 == _o && selected5 == _false && selected7 == _o){
        selected5 = _x;
      }else if(selected3 == _false && selected5 == _o && selected7 == _o){
        selected3 = _x;
      }else if(selected1 == _false && selected2 == _false && selected3 == _false && selected4 == _false && selected5 == _false && selected6 == _false && selected7 == _false && selected8 == _false && selected9 == _false){
        int select = Random().nextInt(9) + 1;
        switch(select){
          case 1: selected1 = _x; break;
          case 2: selected2 = _x; break;
          case 3: selected3 = _x; break;
          case 4: selected4 = _x; break;
          case 5: selected5 = _x; break;
          case 6: selected6 = _x; break;
          case 7: selected7 = _x; break;
          case 8: selected8 = _x; break;
          case 9: selected9 = _x; break;
          case 10: selected5 = _x; break;
        }
      } else if(selected1 == _false && selected2 == _false && selected3 == _false && selected4 == _false && selected5 == _o && selected7 == _false && selected8 == _false && selected9 == _false){
        int select = Random().nextInt(50) + 1;
        if(select <= 10){
          selected1 = _x;
        }else if(select <= 20){
          selected3 = _x;
        }else if(select <= 30){
          selected9 = _x;
        }else{
          selected7 = _x;
        }
      }

      else if(selected5 == _false && selected7 == _o){
        selected5 = _x;
      }else if(selected5 == _false && selected3 == _o){
        selected5 = _x;
      }else if(selected5 == _false && selected9 == _o){
        selected5 = _x;
      }else if(selected5 == _false && selected1 == _o){
        selected5 = _x;
      }
      else if(selected5 == _o && selected1 == _o && selected3 == _false){
        selected3 = _x;
      }else if(selected5 == _o && selected7 == _o && selected3 == _false){
        selected3 = _x;
      }else if(selected5 == _o && selected9 == _o && selected3 == _false){
        selected3 = _x;
      } else if(selected5 == _o && selected3 == _o && selected1 == _false){
        selected1 = _x;
      }else if(selected5 == _o && selected7 == _o && selected1 == _false){
        selected1 = _x;
      }else if(selected5 == _o && selected9 == _o && selected1 == _false){
        selected1 = _x;
      } else if(selected5 == _o && selected3 == _o && selected7 == _false){
        selected7 = _x;
      }else if(selected5 == _o && selected1 == _o && selected7 == _false){
        selected7 = _x;
      }else if(selected5 == _o && selected9 == _o && selected7 == _false){
        selected7 = _x;
      } else if(selected5 == _o && selected3 == _o && selected9 == _false){
        selected9 = _x;
      }else if(selected5 == _o && selected1 == _o && selected9 == _false){
        selected9 = _x;
      }else if(selected5 == _o && selected7 == _o && selected9 == _false){
        selected9 = _x;
      } else if(selected1 == _x && selected3 == _false){
        selected3 = _x;
      }else if(selected1 == _x && selected3 == _x && selected5 == _false){
        selected5 = _x;
      }else if(selected1 == _x && selected7 == _false){
        selected7 = _x;
      }else if(selected1 == _x && selected7 == _x && selected5 == _false){
        selected5 = _x;
      }else if(selected7 == _x && selected9 == _false){
        selected9 = _x;
      }else if(selected7 == _x && selected9 == _x && selected5 == _false){
        selected5 = _x;
      }else if(selected3 == _x && selected9 == _false){
        selected3 = _x;
      }else if(selected3 == _x && selected9 == _x && selected5 == _false){
        selected5 = _x;
      }
      //Kill the game by doing move 1, phase 2
      else if(selected1 == _false && selected3 == _x){
        selected1 = _x;
      }else if(selected1 == _x && selected3 == _x && selected5 == _false){
        selected5 = _x;
      }else if(selected1 == _false && selected7 == _x){
        selected1 = _x;
      }else if(selected1 == _x && selected7 == _x && selected5 == _false){
        selected5 = _x;
      }else if(selected7 == _false && selected9 == _x){
        selected7 = _x;
      }else if(selected7 == _x && selected9 == _x && selected5 == _false){
        selected5 = _x;
      }else if(selected3 == _false && selected9 == _x){
        selected3 = _x;
      }else if(selected3 == _x && selected9 == _x && selected5 == _false){
        selected5 = _x;
      }

      //Kill the game by making move 2, phase 1
      else if(selected1 == _x && selected3 == _x && selected5 != _false && selected7 == _false){
        selected7 = _x;
      }else if(selected1 == _x && selected3 == _false && selected5 != _false && selected7 == _x){
        selected3 = _x;
      }else if(selected1 == _false && selected3 == _x && selected5 != _false && selected7 == _x){
        selected1 = _x;
      }
      //Kill the game by making move 2, phase 2
      else if(selected9 == _x && selected3 == _x && selected5 != _false && selected7 == _false){
        selected7 = _x;
      }else if(selected9 == _x && selected3 == _false && selected5 != _false && selected7 == _x){
        selected3 = _x;
      }else if(selected9 == _false && selected3 == _x && selected5 != _false && selected7 == _x){
        selected9 = _x;
      }
      //Kill the game by making move 2, phase 3
      else if(selected9 == _x && selected1 == _x && selected5 != _false && selected7 == _false){
        selected7 = _x;
      }else if(selected9 == _x && selected1 == _false && selected5 != _false && selected7 == _x){
        selected1 = _x;
      }else if(selected9 == _false && selected1 == _x && selected5 != _false && selected7 == _x){
        selected9 = _x;
      }
      //Kill the game by making move 2, phase 4
      else if(selected9 == _x && selected1 == _x && selected5 != _false && selected3 == _false){
        selected3 = _x;
      }else if(selected9 == _x && selected1 == _false && selected5 != _false && selected3 == _x){
        selected1 = _x;
      }else if(selected9 == _false && selected1 == _x && selected5 != _false && selected3 == _x){
        selected9 = _x;
      }else if(selected1 != _x && selected3 != _x && selected7 != _x && selected4 == _false){
        selected4 = _x;
      }else if(selected1 != _x && selected7 != _x && selected9 != _x && selected4 == _false){
        selected4 = _x;
      }else if(selected1 != _x && selected3 != _x && selected9 != _x && selected4 == _false){
        selected4 = _x;
      }else if(selected4 != _x && selected3 != _x && selected9 != _x && selected4 == _false){
        selected4 = _x;
      }else if(selected8 == _false && selected7 != _x && selected9 == _false){
        selected8 = _x;
      }else if(selected5 == _false){
        selected5 = _x;
      }else if(selected2 == _false){
        selected2 = _x;
      }else if(selected1 == _false){
        selected1 = _x;
      }else if(selected4 == _false){
        selected4 = _x;
      }else if(selected5 == _false){
        selected5 = _x;
      }else if(selected6 == _false){
        selected6 = _x;
      }else if(selected7 == _false){
        selected7 = _x;
      }else if(selected9 == _false){
        selected9 = _x;
      }else if(selected8 == _false){
        selected8 = _x;
      }
      processing = false;
      var result = _checkIfCheck();
      if(result['computer-win']){
        computerVictory();
      }else if(result['ties']){
        _ties();
      }else if(result['play-win']){
        playerVictory();
      }
      _();

    });
  }

  _(){
    update();
  }

  Future<void> setupCoin(coin) async{
    loading = true;
    update();
    Response response = await ticTacTokRepo.saveGameCoins(coin, _win);
    if (response.statusCode == 200) {
      errorWithServer = false;
    } else {
      errorWithServer = true;
    }
    loading = false;
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
