import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:scratcher/scratcher.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../controller/lucky_table_controller.dart';
import '../../../../helper/helpers.dart';
import '../../../../util/admob_service.dart';
import '../../../base/no_game_screen.dart';
import '../../../base/not_logged_in_screen.dart';

class LuckyTableGameScreen extends StatefulWidget{
  final String banner;
  const LuckyTableGameScreen({Key key, this.banner}) : super(key: key);

  @override
  State<LuckyTableGameScreen> createState() => _LuckyTableGameScreenState();
}

class _LuckyTableGameScreenState extends State<LuckyTableGameScreen> {
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
    _bannerAdLarge?.dispose();
    Get.find<LuckyTableController>().interstitialAd?.dispose();
    Get.find<LuckyTableController>().rewardedAd?.dispose();
    Get.find<LuckyTableController>().rewardedinterstitialAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _createBannerLarge();
    Get.find<LuckyTableController>().connectWithServe();
    Get.find<LuckyTableController>().startData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0939),
      appBar: AppBar(
        title: Text('lucky_table'.tr),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: !_isLoggedIn ? NotLoggedInScreen() : GetBuilder<LuckyTableController>(builder: (controller){
          return controller.loading ? Helpers.loading() : !controller.initAd ? Helpers.loading() : controller.errorWithServer ? const NoGameScreen() :
          LoaderOverlay(
            useDefaultLoading: false,
              overlayWidget: Center(
                child: Helpers.loading(),
              ),
              overlayOpacity: 0.8,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40,),
                  Text('lucky_table_desc'.tr, textAlign: TextAlign.center, style: TextStyle(
                      fontSize: 15, color: Theme.of(context).disabledColor
                  ),),
                  const SizedBox(height: 20,),
                  if(controller.luckyTableDay)
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
                  const SizedBox(height: 30,),
                  Center(
                      child: Column(
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
                                onChange: (value) =>controller.onChange(controller.scratch_1),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_1}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Scratcher(
                                brushSize: 30,
                                threshold: 50,
                                color: Colors.grey[300],
                                onChange: (value) =>controller.onChange(controller.scratch_2),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_2}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Scratcher(
                                brushSize: 30,
                                threshold: 50,
                                color: Colors.grey[300],
                                onChange: (value) =>controller.onChange(controller.scratch_3),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_3}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Scratcher(
                                brushSize: 30,
                                threshold: 50,
                                color: Colors.grey[300],
                                onChange: (value) =>controller.onChange(controller.scratch_4),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_4}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
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
                                onChange: (value) =>controller.onChange(controller.scratch_5),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_5}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Scratcher(
                                brushSize: 30,
                                threshold: 50,
                                color: Colors.grey[300],
                                onChange: (value) =>controller.onChange(controller.scratch_6),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_6}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Scratcher(
                                brushSize: 30,
                                threshold: 50,
                                color: Colors.grey[300],
                                onChange: (value) =>controller.onChange(controller.scratch_7),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_7}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Scratcher(
                                brushSize: 30,
                                threshold: 50,
                                color: Colors.grey[300],
                                onChange: (value) =>controller.onChange(controller.scratch_8),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_8}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
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
                                onChange: (value) =>controller.onChange(controller.scratch_9),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_9}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Scratcher(
                                brushSize: 30,
                                threshold: 50,
                                color: Colors.grey[300],
                                onChange: (value) =>controller.onChange(controller.scratch_10),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_10}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Scratcher(
                                brushSize: 30,
                                threshold: 50,
                                color: Colors.grey[300],
                                onChange: (value) =>controller.onChange(controller.scratch_11),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_11}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Scratcher(
                                brushSize: 30,
                                threshold: 50,
                                color: Colors.grey[300],
                                onChange: (value) =>controller.onChange(controller.scratch_12),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_12}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
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
                                onChange: (value) =>controller.onChange(controller.scratch_13),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_13}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Scratcher(
                                brushSize: 30,
                                threshold: 50,
                                color: Colors.grey[300],
                                onChange: (value) =>controller.onChange(controller.scratch_14),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_14}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Scratcher(
                                brushSize: 30,
                                threshold: 50,
                                color: Colors.grey[300],
                                onChange: (value) =>controller.onChange(controller.scratch_15),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_15}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10,),
                              Scratcher(
                                brushSize: 30,
                                threshold: 50,
                                color: Colors.grey[300],
                                onChange: (value) =>controller.onChange(controller.scratch_16),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(100)
                                  ),
                                  child: Center(
                                    child: Text('${controller.scratch_16}', style: const TextStyle(color: Colors.white, fontSize: 25),),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 30,),
                          if (_bannerAdLarge != null)
                            SizedBox(
                                height: _bannerAdLarge.size.height.toDouble(),
                                width: _bannerAdLarge.size.width.toDouble(),
                                child: AdWidget(ad: _bannerAdLarge)),
                        ],
                      )
                  ),
                ],
              ),
            )
          );
        },),
      ),
    );
  }

}