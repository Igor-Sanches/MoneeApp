import 'dart:io';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:store_checker/store_checker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';

class Helpers{

  static Future<bool> isVersionForUpdate(serverVersion)async{
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String buildNumber = packageInfo.buildNumber;
    return int.parse(buildNumber) < serverVersion;
  }

  static Future<bool> isPlayStore()async {
    Source installationSource = await StoreChecker.getSource;

    bool isStore = false;
    switch (installationSource) {
      case Source.IS_INSTALLED_FROM_PLAY_STORE:
        isStore = true;
        break;
      case Source.IS_INSTALLED_FROM_LOCAL_SOURCE:
      case Source.IS_INSTALLED_FROM_AMAZON_APP_STORE:
      case Source.IS_INSTALLED_FROM_HUAWEI_APP_GALLERY:
      case Source.IS_INSTALLED_FROM_SAMSUNG_GALAXY_STORE:
      case Source.IS_INSTALLED_FROM_SAMSUNG_SMART_SWITCH_MOBILE:
      case Source.IS_INSTALLED_FROM_XIAOMI_GET_APPS:
      case Source.IS_INSTALLED_FROM_OPPO_APP_MARKET:
      case Source.IS_INSTALLED_FROM_VIVO_APP_STORE:
      case Source.IS_INSTALLED_FROM_OTHER_SOURCE:
      case Source.IS_INSTALLED_FROM_APP_STORE:
      case Source.IS_INSTALLED_FROM_TEST_FLIGHT:
      case Source.UNKNOWN:
        isStore = false;
        break;
    }
    return isStore;
  }

  static Future<String> getSourceApp() async{
    Source installationSource = await StoreChecker.getSource;
    return installationSource.name;
  }

  static Future<void> playSound(song)async{
    await Vibration.hasVibrator();
    try{
      Vibration.vibrate(duration: 200);
    // ignore: empty_catches
    } catch (e) {}
    try{
      AssetsAudioPlayer.newPlayer().open(
        Audio(song),
        autoStart: true,
        showNotification: true,
      );
    }catch(e){
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  static Widget loading() {
    int type = Random().nextInt(20) + 1;
    Widget widget = Center(
      child: LoadingAnimationWidget.twistingDots(
        leftDotColor: const Color(0xFFEF6937),
        rightDotColor: const Color(0xFFEA3799),
        size: 90,
      ),
    );
    switch(type){
      case 1:
        widget = Center(
          child: LoadingAnimationWidget.twistingDots(
            leftDotColor: const Color(0xFFEF6937),
            rightDotColor: const Color(0xFFEA3799),
            size: 90,
          ),
        );
        break;
      case 2:
        widget = Center(
          child: LoadingAnimationWidget.threeArchedCircle(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 3:
        widget = Center(
          child: LoadingAnimationWidget.threeRotatingDots(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 4:
        widget = Center(
          child: LoadingAnimationWidget.twoRotatingArc(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 5:
        widget = Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 6:
        widget = Center(
          child: LoadingAnimationWidget.hexagonDots(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 7:
        widget = Center(
          child: LoadingAnimationWidget.fallingDot(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 8:
        widget = Center(
          child: LoadingAnimationWidget.dotsTriangle(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 9:
        widget = Center(
          child: LoadingAnimationWidget.discreteCircle(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 10:
        widget = Center(
          child: LoadingAnimationWidget.bouncingBall(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 11:
        widget = Center(
          child: LoadingAnimationWidget.beat(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 12:
        widget = Center(
          child: LoadingAnimationWidget.flickr(
            size: 90, leftDotColor: const Color(0xFFEF6937), rightDotColor: const Color(
              0xFFEC4080),
          ),
        );
        break;
      case 13:
        widget = Center(
          child: LoadingAnimationWidget.halfTriangleDot(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 14:
        widget = Center(
          child: LoadingAnimationWidget.horizontalRotatingDots(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 15:
        widget = Center(
          child: LoadingAnimationWidget.inkDrop(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 16:
        widget = Center(
          child: LoadingAnimationWidget.newtonCradle(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 17:
        widget = Center(
          child: LoadingAnimationWidget.prograssiveDots(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 18:
        widget = Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 19:
        widget = Center(
          child: LoadingAnimationWidget.stretchedDots(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
      case 20:
        widget = Center(
          child: LoadingAnimationWidget.waveDots(
            size: 90, color: const Color(0xFFEF6937),
          ),
        );
        break;
    }

    return widget;
  }

  static String getCoin(String coin) {
    if(coin == '0'){
      return 'no_coin'.tr;
    }
    if(coin == '1'){
      return 'one_coin'.tr;
    }
    return '$coin ${'coins'.tr}';
  }
}
