import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:monetization/controller/tic_tac_tok_controller.dart';
import 'package:monetization/util/images.dart';

import '../../util/dimensions.dart';
import '../../util/styles.dart';

class NoGameScreen extends StatefulWidget {
  const NoGameScreen({Key key}) : super(key: key);

  @override
  State<NoGameScreen> createState() => _NoGameScreenState();
}

class _NoGameScreenState extends State<NoGameScreen> {
  BannerAd _bannerAd;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: Padding(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [

            Image.asset(
              Images.no_games,
              width: MediaQuery.of(context).size.height*0.22, height: MediaQuery.of(context).size.height*0.22,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.03),

            Text(
              'no_connection_with_game'.tr,
              style: robotoMedium.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Theme.of(context).disabledColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.03),
            Center(
              child: TextButton(
                onPressed: () => Get.find<TicTacToeController>().connectWithServe(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(const Color(
                      0xFFEC59BD)),
                  shadowColor: MaterialStateProperty.all(const Color(
                      0xFFFF10B2)),
                ),
                child: Text('try_again'.tr, style: const TextStyle(
                    color: Colors.white
                ),),
              ),
            ),
          ]),
        )),
        if (_bannerAd != null)
          SizedBox(
              height: _bannerAd.size.height.toDouble(),
              width: _bannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bannerAd))

      ],
    );
  }
}
