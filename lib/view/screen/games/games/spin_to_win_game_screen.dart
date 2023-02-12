import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monetization/view/base/custom_snackbar.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../controller/spin_to_win_controller.dart';
import '../../../../helper/helpers.dart';
import '../../../../util/admob_service.dart';
import '../../../base/no_game_screen.dart';
import '../../../base/not_logged_in_screen.dart';

class SpinToWindScreen extends StatefulWidget{
  final String banner;
  const SpinToWindScreen({Key key, this.banner}) : super(key: key);

  @override
  State<SpinToWindScreen> createState() => _SpinToWindScreenState();
}

class _SpinToWindScreenState extends State<SpinToWindScreen> {
  StreamController<int> selected = StreamController<int>();
  final bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
  BannerAd _bannerAdLarge;
  bool spinInit = false;

  void _createBannerLarge() {
    _bannerAdLarge = BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: widget.banner,
        listener: AdMobService.listenerBanner,
        request: const AdRequest()
    )..load();
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAdLarge?.dispose();
    Get.find<SpinToWinController>().interstitialAd?.dispose();
    Get.find<SpinToWinController>().rewardedAd?.dispose();
    Get.find<SpinToWinController>().rewardedinterstitialAd?.dispose();
    selected.close();
  }

  @override
  void initState() {
    spinInit = false;
    _createBannerLarge();
    Get.find<SpinToWinController>().connectWithServe();
    Get.find<SpinToWinController>().startData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0939),
      appBar: AppBar(
        title: Text('spin_to_win'.tr),
      ),
      body: !_isLoggedIn ? NotLoggedInScreen() : GetBuilder<SpinToWinController>(builder: (controller){
        return  controller.loading ? Helpers.loading() : !controller.initAd ? Helpers.loading() : controller.errorWithServer ? const NoGameScreen() :
        LoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: Center(
            child: Helpers.loading(),
          ),
          overlayOpacity: 0.8,
          child: GestureDetector(
            onTap: () {
              if(controller.spinToWinDay){
                showCustomSnackBar('game_day_info'.tr);
                return;
              }
              setState(() {
                selected.add(
                    controller.positionSpin
                );
              });
            },
            child: Column(
              children: [
                const SizedBox(height: 40,),
                Text('spin_to_win_desc'.tr, textAlign: TextAlign.center, style: TextStyle(
                    fontSize: 15, color: Theme.of(context).disabledColor
                ),),
                const SizedBox(height: 10,),
                if(controller.spinToWinDay)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: Text('spin_to_win_desc_day'.tr, textAlign: TextAlign.center, style: TextStyle(
                          fontSize: 15, color: Theme.of(context).disabledColor
                      ),),
                    ),
                  ),
                Expanded(
                    child: FortuneWheel(
                      selected: selected.stream,
                      animateFirst: false,
                      onSelectedItem: (item){
                        controller.setupGame(item);
                      },
                      items: [
                        for (var it in controller.items) FortuneItem(child: Text(it)),
                      ],
                    )
                ),
              ],
            ),
          ),
        );
      },),
    );
  }
}
