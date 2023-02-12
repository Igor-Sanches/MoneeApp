import 'dart:async';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/localization_controller.dart';
import '../../../controller/splash_controller.dart';
import '../../../helper/helpers.dart';
import '../../../helper/route_helper.dart';
import '../../../util/app_constants.dart';
import '../../../util/images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  StreamSubscription<ConnectivityResult> _onConnectivityChanged;

  @override
  void initState() {
    super.initState();

    bool firstTime = true;
    _onConnectivityChanged = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if(!firstTime) {
        bool isNotConnected = result != ConnectivityResult.wifi && result != ConnectivityResult.mobile;
        isNotConnected ? const SizedBox() : ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isNotConnected ? Colors.red : Colors.green,
          duration: Duration(seconds: isNotConnected ? 6000 : 3),
          content: Text(
            isNotConnected ? 'no_connection'.tr : 'connected'.tr,
            textAlign: TextAlign.center,
          ),
        ));
        if(!isNotConnected) {
          _route();
        }
      }
      firstTime = false;
    });

    _route();
  }

  @override
  void dispose() {
    super.dispose();
    _onConnectivityChanged.cancel();
  }

  void _route() {
    Get.find<SplashController>().getConfigData().then((isSuccess) async{
      if(isSuccess) {
        if (Get.find<AuthController>().isLoggedIn()) {
          Get.find<AuthController>().updateToken();
        }
        Timer(const Duration(seconds: 1), () async {
          var configModel = Get.find<SplashController>().configModel;
          if(configModel.topicFirebase.isNotEmpty){
            FirebaseMessaging.instance.subscribeToTopic(configModel.topicFirebase);
          }
          var languageApp = Get.find<SplashController>().getLanguage();
          if(!languageApp){
            var localizationController = Get.find<LocalizationController>();
            if(configModel.languageApp == 'option_user'){
              var languages = AppConstants.languages;
              if(languages.length > 1){
                Get.offNamed(RouteHelper.getLanguageRoute());
              }else{
                localizationController.setLanguageSetup(true);
                Get.offAllNamed(RouteHelper.getSplashRoute());
              }
            }else{
              var split = configModel.languageApp.split('_');
              var codeLanguage = split[0];
              var codeCountry = split[1];
              var languages = AppConstants.languages;
              var result = languages.where((element) => element.languageCode == codeLanguage && element.countryCode == codeCountry);
              if(result.isNotEmpty){
                localizationController.setLanguage(Locale(
                  codeLanguage, codeCountry
                ));
                localizationController.setLanguageSetup(true);
                Get.offAllNamed(RouteHelper.getSplashRoute());
              }else{
                if(languages.length > 1){
                  Get.offNamed(RouteHelper.getLanguageRoute());
                }else{
                  localizationController.setLanguageSetup(true);
                  Get.offAllNamed(RouteHelper.getSplashRoute());
                }
              }
            }
          }else{
            if(configModel.maintenance){
              Get.offNamed(RouteHelper.getMaintenanceRoute());
            }
            else{
              String minimumVersion = configModel.getVersionBuild;
              var isUpdate = await Helpers.isVersionForUpdate(int.parse(minimumVersion));
              if(isUpdate){
                Get.offNamed(RouteHelper.getUpdateRoute());
              }else{
                if(Platform.isAndroid) {
                  if(configModel.inPlayStore){
                    var isPlayStore = await Helpers.isPlayStore();
                    if (isPlayStore) {
                      _goInit();
                    } else {
                      Get.offNamed(RouteHelper.getUnknownSourceRoute());
                    }
                  }else {
                    _goInit();
                  }
                }else{
                  _goInit();
                }
              }
            }
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>().initSharedData();

    return Scaffold(
      key: _globalKey,
      backgroundColor: Theme.of(context).primaryColor,
      body: GetBuilder<SplashController>(builder: (splashController) {
        return Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50)
                ),
                child: Center(
                  child: Image.asset(Images.logo_icon),
                ),
              ),
            ),
            SizedBox(
              height: double.maxFinite,
              width: double.maxFinite,
              child: Shimmer.fromColors(
                baseColor: const Color(0x00092202),
                highlightColor: const Color(0x22F5F0D6),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.red
                  ),
                  height: double.maxFinite,
                  width: double.maxFinite,
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  void _goInit() async{
    Get.offNamed(RouteHelper.getInitialRoute());
  }
}
