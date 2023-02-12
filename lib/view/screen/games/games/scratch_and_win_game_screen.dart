import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:scratcher/scratcher.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../controller/scratch_and_win_controller.dart';
import '../../../../helper/helpers.dart';
import '../../../../util/admob_service.dart';
import '../../../../util/images.dart';
import '../../../base/no_game_screen.dart';
import '../../../base/not_logged_in_screen.dart';

class ScratchAndWinGameScreen extends StatefulWidget{
  final String banner;
  const ScratchAndWinGameScreen({Key key, this.banner}) : super(key: key);

  @override
  State<ScratchAndWinGameScreen> createState() => _ScratchAndWinGameScreenState();
}

class _ScratchAndWinGameScreenState extends State<ScratchAndWinGameScreen> {
  final bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();
  BannerAd _bannerAdLarge;

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
    Get.find<ScratchAndWinController>().interstitialAd?.dispose();
    Get.find<ScratchAndWinController>().rewardedAd?.dispose();
    Get.find<ScratchAndWinController>().rewardedinterstitialAd?.dispose();
  }

  @override
  void initState() {
    _createBannerLarge();
    Get.find<ScratchAndWinController>().connectWithServe();
    Get.find<ScratchAndWinController>().startData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0939),
      appBar: AppBar(
        title: Text('scratch_and_win'.tr),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: !_isLoggedIn ? NotLoggedInScreen() : GetBuilder<ScratchAndWinController>(builder: (controller){
          return  controller.loading ? Helpers.loading() : !controller.initAd ? Helpers.loading() : controller.errorWithServer ? const NoGameScreen() :
          LoaderOverlay(
            useDefaultLoading: false,
            overlayWidget: Center(
              child: Helpers.loading(),
            ),
            overlayOpacity: 0.8,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40,),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('scratch_and_win_desc1'.tr, textAlign: TextAlign.center, style: TextStyle(
                          fontSize: 15, color: Theme.of(context).disabledColor
                      ),),
                      const SizedBox(width: 10,),
                      Image.asset(Images.logo, width: 20, height: 20,),
                    ],
                  ),
                  Text('scratch_and_win_desc2'.tr, textAlign: TextAlign.center, style: TextStyle(
                      fontSize: 15, color: Theme.of(context).disabledColor
                  ),),
                  const SizedBox(height: 50,),
                  Center(
                    child: Card(
                      color: const Color(0xFF010836),
                      surfaceTintColor: Colors.white,
                      elevation: 10,
                      child: SizedBox(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Scratcher(
                                  brushSize: 30,
                                  threshold: 50,
                                  color: Colors.grey[300],
                                  onChange: (value) =>controller.onChange(1, 'scratch_1'),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    height: 90,
                                    width: 90,
                                    color: Colors.blueGrey,
                                    child: Image.asset(controller.scratch_1),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Scratcher(
                                  brushSize: 30,
                                  threshold: 50,
                                  color: Colors.grey[300],
                                  onChange: (value) =>controller.onChange(2, 'scratch_2'),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    height: 90,
                                    width: 90,
                                    color: Colors.blueGrey,
                                    child: Image.asset(controller.scratch_2),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Scratcher(
                                  brushSize: 30,
                                  threshold: 50,
                                  color: Colors.grey[300],
                                  onChange: (value) =>controller.onChange(3, 'scratch_3'),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    height: 90,
                                    width: 90,
                                    color: Colors.blueGrey,
                                    child: Image.asset(controller.scratch_3),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Scratcher(
                                  brushSize: 30,
                                  threshold: 50,
                                  color: Colors.grey[300],
                                  onChange: (value) =>controller.onChange(4, 'scratch_4'),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    height: 90,
                                    width: 90,
                                    color: Colors.blueGrey,
                                    child: Image.asset(controller.scratch_4),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Scratcher(
                                  brushSize: 30,
                                  threshold: 50,
                                  color: Colors.grey[300],
                                  onChange: (value) =>controller.onChange(5, 'scratch_5'),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    height: 90,
                                    width: 90,
                                    color: Colors.blueGrey,
                                    child: Image.asset(controller.scratch_5),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Scratcher(
                                  brushSize: 30,
                                  threshold: 50,
                                  color: Colors.grey[300],
                                  onChange: (value) =>controller.onChange(6, 'scratch_6'),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    height: 90,
                                    width: 90,
                                    color: Colors.blueGrey,
                                    child: Image.asset(controller.scratch_6),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Scratcher(
                                  brushSize: 30,
                                  threshold: 50,
                                  color: Colors.grey[300],
                                  onChange: (value) =>controller.onChange(7, 'scratch_7'),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    height: 90,
                                    width: 90,
                                    color: Colors.blueGrey,
                                    child: Image.asset(controller.scratch_7),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Scratcher(
                                  brushSize: 30,
                                  threshold: 50,
                                  color: Colors.grey[300],
                                  onChange: (value) =>controller.onChange(8, 'scratch_8'),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    height: 90,
                                    width: 90,
                                    color: Colors.blueGrey,
                                    child: Image.asset(controller.scratch_8),
                                  ),
                                ),
                                const SizedBox(width: 10,),
                                Scratcher(
                                  brushSize: 30,
                                  threshold: 50,
                                  color: Colors.grey[300],
                                  onChange: (value) =>controller.onChange(9, 'scratch_9'),
                                  child: Container(
                                    padding: const EdgeInsets.all(20),
                                    height: 90,
                                    width: 90,
                                    color: Colors.blueGrey,
                                    child: Image.asset(controller.scratch_9),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50,),

                  Center(
                    child: Text('scratch_and_win'.tr, style: const TextStyle(
                        fontSize: 20, color: Colors.white
                    ),),
                  ),
                  const SizedBox(height: 20,),
                  Scratcher(
                    brushSize: 30,
                    threshold: 50,
                    color: Colors.grey[300],
                    onThreshold: () => controller.onThreshold(),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      height: 120,
                      width: 120,
                      color: Colors.blueGrey,
                      child: Center(
                        child: Text(controller.coinWin, style: const TextStyle(
                            fontSize: 40, color: Colors.pinkAccent
                        ),),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30,),
                  if (_bannerAdLarge != null)
                    SizedBox(
                        height: _bannerAdLarge.size.height.toDouble(),
                        width: _bannerAdLarge.size.width.toDouble(),
                        child: AdWidget(ad: _bannerAdLarge)),

                ],
              ),
            ),
          );
        },),
      ),
    );
  }
}