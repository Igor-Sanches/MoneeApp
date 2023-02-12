import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService{
  static BannerAdListener listenerBanner = BannerAdListener(
    onAdLoaded: (ad) => print('onAdLoaded'),
    onAdFailedToLoad: (ad, error) => print('error ${error.message}'),
    onAdOpened: (ad) => print('banner iniciado'),
    onAdClosed: (ad) => print('banner fechado')
  );

}