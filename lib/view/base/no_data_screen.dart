import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../util/dimensions.dart';
import '../../util/styles.dart';

class NoDataScreen extends StatefulWidget {
  final String text;
  final String image;

  const NoDataScreen({Key key, @required this.text, this.image}) : super(key: key);

  @override
  State<NoDataScreen> createState() => _NoDataScreenState();
}

class _NoDataScreenState extends State<NoDataScreen> {
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
              widget.text,
              style: robotoMedium.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Theme.of(context).disabledColor),
              textAlign: TextAlign.center,
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
