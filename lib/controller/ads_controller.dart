import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../data/api/api_checker.dart';
import '../data/model/response/ads_model.dart';
import '../data/repository/ads_repo.dart';
import '../helper/helpers.dart';
import '../helper/route_helper.dart';
import '../util/images.dart';
import '../util/songs.dart';
import '../view/base/custom_snackbar.dart';

class AdsController extends GetxController implements GetxService {
  final AdsRepo adsRepo;
  AdsController({@required this.adsRepo});
  RewardedInterstitialAd rewardedinterstitialAd;
  int maxRewardedInterstitialFailedLoadAttempts = 0;
  int _numRewardedInterstitialLoadAttempts = 0;
  bool isRewardedOpen = false;
  bool isLogin = false;
  bool isTimeDisabled = true;

  List<Ads> _adsList = [];
  List<int> _offsetList = [];
  AdsModel _adModel;
  bool _isLoading = true;
  bool _paginate = false;
  int _pageSize;
  int _offset = 1;

  List<Ads> get adsList => _adsList;
  AdsModel get adModel => _adModel;
  bool get isLoading => _isLoading;
  bool get paginate => _paginate;
  int get pageSize => _pageSize;
  int get offset => _offset;

  Future<void> setupCoin(coin, id) async{
    Get.context.loaderOverlay.show();
    Response response = await adsRepo.putCoin(coin, id);
    Get.context.loaderOverlay.hide();
    if(response.statusCode == 200){
      var result = response.body['data'];
      if(result['all_view']){
        _dialog('max_all_view'.tr);
      }else{
        Get.toNamed(RouteHelper.getAwardRoute(
            coin,
            'happy'.tr,
            'msg_ad_award'.tr,
            true
        ));
        getGames(offset, true);
      }
    }else{
      _dialog('no_connection'.tr);
    }
  }

  _dialog(msg){
    Get.dialog(AlertDialog(
      backgroundColor: const Color(0xFF010836),
      title: Text('warning'.tr, style: const TextStyle(
          color: Colors.green
      ),),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10,),
          Center(
            child: Text(msg, style: const TextStyle(
                color: Colors.white
            ),),
          ),
        ],
      ),
      actions: [TextButton(onPressed: ()=>Get.back(), child: Text('close'.tr, style: const TextStyle(
          color: Colors.red
      ),),)],
    ));
  }

  Future<void> getGames(int offset, bool notify) async {
    _offset = offset;
    if(offset == 1 || _adsList == null) {
      _adsList = null;
      _offset = 1;
      _offsetList = [];
      if(notify) {
        try{
          update();
        }catch(x){

        }
      }
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      Response response = await adsRepo.getGames(offset);
      _isLoading = false;
      if (response.statusCode == 200) {
        if (offset == 1) {
          _adsList = [];
        }
        isLogin = response.body['data']['login'];
        if(!isLogin){
          _paginate = false;
          update();
          return;
        }
        var ads = AdsModel.fromJson(response.body['data']).ads;
        _adsList.addAll(ads);
        _pageSize = AdsModel.fromJson(response.body['data']).totalSize;
        _paginate = false;
        update();
      }else if(response.statusCode == 500){
        _adsList = [];
        isLogin = false;
        _paginate = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if(_paginate) {
        _paginate = false;
        update();
      }
    }
  }

  void setOffset(int offSet) {
    _offset = offSet;
  }

  void showFoodBottomLoader() {
    _paginate = true;
    update();

  }

  void startAdCall(Ads adModel) {
    isRewardedOpen = false;
    isTimeDisabled = false;
    RewardedInterstitialAd.load(
        adUnitId: adModel.idAd,
        request: const AdRequest(),
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            isTimeDisabled = true;
            rewardedinterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
            rewardedinterstitialAd.setImmersiveMode(true);
            if(!isRewardedOpen){
              _showAdCall(adModel);
              isRewardedOpen = true;
            }
          },
          onAdFailedToLoad: (LoadAdError error) {
            Get.context.loaderOverlay.hide();
            showCustomSnackBar('couldnt_save_your_reward_because_of_the_ad'.tr);
            _numRewardedInterstitialLoadAttempts += 1;
            rewardedinterstitialAd = null;
            // if (_numRewardedInterstitialLoadAttempts < maxRewardedInterstitialFailedLoadAttempts) {
            //   startAdCall(ad);
            // }
            update();
          },
        ));
    Timer.periodic(const Duration(seconds: 15), (timer) {
      timer.cancel();
      if(!isTimeDisabled){
        showCustomSnackBar('timer_current'.tr);
        update();
        isTimeDisabled = true;
      }
    });
  }

  void _showAdCall(Ads adModel) {
    if (rewardedinterstitialAd == null) {
      Get.context.loaderOverlay.hide();
      return;
    }
    rewardedinterstitialAd.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) {
        isTimeDisabled = true;
      },
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
          int coin = Random().nextInt(int.parse(adModel.coin));
          setupCoin(coin, adModel.id);
        }).onError((error, stackTrace) {
      Get.context.loaderOverlay.hide();
    });
    rewardedinterstitialAd = null;
  }
}