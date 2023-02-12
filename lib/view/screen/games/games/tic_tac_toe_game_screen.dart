import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monetization/controller/tic_tac_tok_controller.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../helper/helpers.dart';
import '../../../../util/admob_service.dart';
import '../../../base/no_game_screen.dart';
import '../../../base/not_logged_in_screen.dart';

class TicTacToeGameScreen extends StatefulWidget{
  final String banner;
  const TicTacToeGameScreen({Key key, this.banner}) : super(key: key);

  @override
  State<TicTacToeGameScreen> createState() => _TicTacToeGameScreenState();
}

class _TicTacToeGameScreenState extends State<TicTacToeGameScreen> {
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
    Get.find<TicTacToeController>().interstitialAd?.dispose();
    Get.find<TicTacToeController>().rewardedAd?.dispose();
    Get.find<TicTacToeController>().rewardedinterstitialAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _createBannerLarge();
    Get.find<TicTacToeController>().connectWithServe();
    Get.find<TicTacToeController>().startData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0939),
      appBar: AppBar(
        title: Text('tic_tac_toe_game'.tr),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: !_isLoggedIn ? NotLoggedInScreen() : GetBuilder<TicTacToeController>(builder: (controller){
          return controller.loading ? Helpers.loading() : !controller.initAd ? Helpers.loading() : controller.errorWithServer ? const NoGameScreen() :
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
                  Text('tic_tac_toe_game_desc'.tr, textAlign: TextAlign.center, style: TextStyle(
                      fontSize: 15, color: Theme.of(context).disabledColor
                  ),),
                  const SizedBox(height: 50,),
                  RichText(text: TextSpan(
                      children: [
                        TextSpan(
                            text: 'V: ${controller.victories}',
                            style: const TextStyle(color: Colors.green)
                        ),
                        const TextSpan(
                            text: '  --  '
                        ),
                        TextSpan(
                            text: 'E: ${controller.ties}',
                            style: const TextStyle(color: Colors.yellow)
                        ),
                        const TextSpan(
                            text: '  --  '
                        ),
                        TextSpan(
                            text: 'D: ${controller.defeats}',
                            style: const TextStyle(color: Colors.red)
                        ),
                      ]
                  )),
                  const SizedBox(height: 20,),

                  Center(
                    child: Card(
                      color: const Color(0xFF010836),
                      surfaceTintColor: Colors.white,
                      elevation: 10,
                      child: SizedBox(
                        height: 220,
                        width: 220,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                        child: SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: Center(
                                            child: Text(controller.selected1 == 'false' ? '' : controller.selected1 =='O' ? 'O' : 'X', style: TextStyle(color: controller.gameOver && !controller.victoryGame['selected1'] ? Colors.grey : controller.selected1 == 'X' ? const Color(0xFFF9C947) : const Color(0xFFEC4CC2), fontSize: 50),),
                                          ),
                                        ),
                                        onTap: () => controller.goSelect(1)
                                    ),
                                    Container(
                                      height: 70,
                                      width: 1,
                                      color: const Color(0xFFEC59BD),
                                    ),
                                    InkWell(
                                        child: SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: Center(
                                            child: Text(controller.selected2 == 'false' ? '' : controller.selected2 =='O' ? 'O' : 'X', style: TextStyle(color: controller.gameOver && !controller.victoryGame['selected2'] ? Colors.grey : controller.selected2 == 'X' ? const Color(0xFFF9C947) : const Color(0xFFEC4CC2), fontSize: 50),),
                                          ),
                                        ),
                                        onTap: () => controller.goSelect(2)
                                    ),
                                    Container(
                                      height: 70,
                                      width: 1,
                                      color: const Color(0xFFEC59BD),
                                    ),
                                    InkWell(
                                        child: SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: Center(
                                            child: Text(controller.selected3 == 'false' ? '' : controller.selected3 =='O' ? 'O' : 'X', style: TextStyle(color: controller.gameOver && !controller.victoryGame['selected3'] ? Colors.grey : controller.selected3 == 'X' ? const Color(0xFFF9C947) : const Color(0xFFEC4CC2), fontSize: 50),),
                                          ),
                                        ),
                                        onTap: () => controller.goSelect(3)
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 1,
                                  width: 210,
                                  color: const Color(0xFFEC59BD),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                        child: SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: Center(
                                            child: Text(controller.selected4 == 'false' ? '' : controller.selected4 =='O' ? 'O' : 'X', style: TextStyle(color: controller.gameOver && !controller.victoryGame['selected4'] ? Colors.grey : controller.selected4 == 'X' ? const Color(0xFFF9C947) : const Color(0xFFEC4CC2), fontSize: 50),),
                                          ),
                                        ),
                                        onTap: () => controller.goSelect(4)
                                    ),
                                    Container(
                                      height: 70,
                                      width: 1,
                                      color: const Color(0xFFEC59BD),
                                    ),
                                    InkWell(
                                        child: SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: Center(
                                            child: Text(controller.selected5 == 'false' ? '' : controller.selected5 =='O' ? 'O' : 'X', style: TextStyle(color: controller.gameOver && !controller.victoryGame['selected5'] ? Colors.grey :  controller.selected5 == 'X' ? const Color(0xFFF9C947) : const Color(0xFFEC4CC2), fontSize: 50),),
                                          ),
                                        ),
                                        onTap: () => controller.goSelect(5)
                                    ),
                                    Container(
                                      height: 70,
                                      width: 1,
                                      color: const Color(0xFFEC59BD),
                                    ),
                                    InkWell(
                                        child: SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: Center(
                                            child: Text(controller.selected6 == 'false' ? '' : controller.selected6 =='O' ? 'O' : 'X', style: TextStyle(color: controller.gameOver && !controller.victoryGame['selected6'] ? Colors.grey : controller.selected6 == 'X' ? const Color(0xFFF9C947) : const Color(0xFFEC4CC2), fontSize: 50),),
                                          ),
                                        ),
                                        onTap: () => controller.goSelect(6)
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 1,
                                  width: 210,
                                  color: const Color(0xFFEC59BD),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                        child: SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: Center(
                                            child: Text(controller.selected7 == 'false' ? '' : controller.selected7 =='O' ? 'O' : 'X', style: TextStyle(color: controller.gameOver && !controller.victoryGame['selected7'] ? Colors.grey : controller.selected7 == 'X' ? const Color(0xFFF9C947) : const Color(0xFFEC4CC2), fontSize: 50),),
                                          ),
                                        ),
                                        onTap: () => controller.goSelect(7)
                                    ),
                                    Container(
                                      height: 70,
                                      width: 1,
                                      color: const Color(0xFFEC59BD),
                                    ),
                                    InkWell(
                                        child: SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: Center(
                                            child: Text(controller.selected8 == 'false' ? '' : controller.selected8 =='O' ? 'O' : 'X', style: TextStyle(color: controller.gameOver && !controller.victoryGame['selected8'] ? Colors.grey : controller.selected8 == 'X' ? const Color(0xFFF9C947) : const Color(0xFFEC4CC2), fontSize: 50),),
                                          ),
                                        ),
                                        onTap: () => controller.goSelect(8)
                                    ),
                                    Container(
                                      height: 70,
                                      width: 1,
                                      color: const Color(0xFFEC59BD),
                                    ),
                                    InkWell(
                                        child: SizedBox(
                                          height: 70,
                                          width: 70,
                                          child: Center(
                                            child: Text(controller.selected9 == 'false' ? '' : controller.selected9 =='O' ? 'O' : 'X', style: TextStyle(color: controller.gameOver && !controller.victoryGame['selected9'] ? Colors.grey : controller.selected9 == 'X' ? const Color(0xFFF9C947) : const Color(0xFFEC4CC2), fontSize: 50),),
                                          ),
                                        ),
                                        onTap: () => controller.goSelect(9)
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30,),
                  if(!controller.gameOver && !controller.start)
                    Center(
                      child: Text(controller.computerStartsTheGame ? 'computer_start'.tr : 'player_start'.tr, style: TextStyle(color: Colors.white60),),
                    ),

                  if(controller.start)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          controller.startGame();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color(
                              0xFFEC59BD)),
                          shadowColor: MaterialStateProperty.all(const Color(
                              0xFFFF10B2)),
                        ),
                        child: Text('start'.tr, style: const TextStyle(
                            color: Colors.white
                        ),),
                      ),
                    ),

                  if(controller.gameOver && !controller.start)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          controller.startNewGame();
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(const Color(
                              0xFFEC59BD)),
                          shadowColor: MaterialStateProperty.all(const Color(
                              0xFFFF10B2)),
                        ),
                        child: Text('play_try'.tr, style: const TextStyle(
                            color: Colors.white
                        ),),
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