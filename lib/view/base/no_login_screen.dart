import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../helper/route_helper.dart';
import '../../util/dimensions.dart';
import '../../util/styles.dart';
import 'custom_button.dart';

class NoLoginScreen extends StatefulWidget {
  final String image;

  const NoLoginScreen({Key key, this.image}) : super(key: key);

  @override
  State<NoLoginScreen> createState() => _NoLoginScreenState();
}

class _NoLoginScreenState extends State<NoLoginScreen> {
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
              widget.image,
              width: MediaQuery.of(context).size.height*0.22, height: MediaQuery.of(context).size.height*0.22,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.03),

            Text(
              'no_login'.tr,
              style: robotoMedium.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Theme.of(context).disabledColor),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: MediaQuery.of(context).size.height*0.04),

            SizedBox(
              width: 200,
              child: CustomButton(buttonText: 'login_to_continue'.tr, height: 40, onPressed: () {
                Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
              }),
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
