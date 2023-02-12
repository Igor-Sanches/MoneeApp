import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monetization/helper/helpers.dart';
import 'package:playing_cards/playing_cards.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../controller/playing_card_controller.dart';
import '../../../../util/admob_service.dart';
import '../../../../util/images.dart';
import '../../../base/no_game_screen.dart';
import '../../../base/not_logged_in_screen.dart';

class PlayingCardScreen extends StatefulWidget{
  final String banner;
  const PlayingCardScreen({Key key, this.banner}) : super(key: key);

  @override
  State<PlayingCardScreen> createState() => _PlayingCardScreenState();
}

class _PlayingCardScreenState extends State<PlayingCardScreen> {
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
    Get.find<PlayingCardController>().interstitialAd?.dispose();
    Get.find<PlayingCardController>().rewardedAd?.dispose();
    Get.find<PlayingCardController>().rewardedinterstitialAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _createBannerLarge();
    Get.find<PlayingCardController>().connectWithServe();
    Get.find<PlayingCardController>().startData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0939),
      appBar: AppBar(
        title: Text('playing_card'.tr),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: !_isLoggedIn ? NotLoggedInScreen() : GetBuilder<PlayingCardController>(builder: (controller){
          return controller.loading ? Helpers.loading() : !controller.initAd ? Helpers.loading() : controller.errorWithServer ? const NoGameScreen() : LoaderOverlay(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('card_desc'.tr, textAlign: TextAlign.center, style: TextStyle(
                          fontSize: 15, color: Theme.of(context).disabledColor
                      ),),
                      const SizedBox(width: 10,),
                      Image.asset(Images.heart, height: 30,),
                    ],
                  ),
                  const SizedBox(height: 50,),
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
                              const SizedBox(width: 20,),
                              Expanded(
                                  child: InkWell(
                                    onTap: () => controller.cardSelected(controller.card1, 1),
                                    child: PlayingCardView(card: PlayingCard(controller.card1, CardValue.ace), showBack: !controller.showCard1, style: myCardStyles),
                                  )
                              ),
                              Expanded(
                                  child: InkWell(
                                    onTap: () => controller.cardSelected(controller.card2, 2),
                                    child: PlayingCardView(card: PlayingCard(controller.card2, CardValue.ace), showBack: !controller.showCard2, style: myCardStyles),
                                  )
                              ),
                              const SizedBox(width: 20,),
                            ],
                          ),
                          const SizedBox(height: 10,),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(width: 20,),
                              Expanded(
                                  child: InkWell(
                                    onTap: () => controller.cardSelected(controller.card3, 3),
                                    child: PlayingCardView(card: PlayingCard(controller.card3, CardValue.ace), showBack: !controller.showCard3, style: myCardStyles),
                                  )
                              ),
                              Expanded(
                                  child: InkWell(
                                    onTap: () => controller.cardSelected(controller.card4, 4),
                                    child: PlayingCardView(card: PlayingCard(controller.card4, CardValue.ace), showBack: !controller.showCard4, style: myCardStyles),
                                  )
                              ),
                              const SizedBox(width: 20,),
                            ],
                          ),
                          const SizedBox(height: 10,),
                        ],
                      )
                  ),
                  const SizedBox(height: 20,),
                  if(controller.gameOver)
                    Center(
                      child: TextButton(
                        onPressed: () {
                          controller.startData();
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
      )
    );
  }

  PlayingCardViewStyle myCardStyles = PlayingCardViewStyle(suitStyles: {
    Suit.spades: SuitStyle(
        builder: (context) => const FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(
            "♠",
            style: TextStyle(fontSize: 30),
          ),
        ),
        style: TextStyle(color: Colors.grey[800])),
    Suit.hearts: SuitStyle(
        builder: (context) => const FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(
            "♥",
            style: TextStyle(fontSize: 30),
          ),
        ),
        style: const TextStyle(color: Colors.red)),
    Suit.diamonds: SuitStyle(
        builder: (context) => const FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(
            "♦",
            style: TextStyle(fontSize: 30),
          ),
        ),
        style: const TextStyle(color: Colors.red)),
    Suit.clubs: SuitStyle(
        builder: (context) => const FittedBox(
          fit: BoxFit.fitHeight,
          child: Text(
            "♣",
            style: TextStyle(fontSize: 30),
          ),
        ),
        style: TextStyle(color: Colors.grey[800])),
    Suit.joker: SuitStyle(
        builder: (context) => Container()),
  });
}