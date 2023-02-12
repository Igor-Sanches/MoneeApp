import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:r_launch_appstore/r_launch_appstore.dart';

import '../../../controller/splash_controller.dart';
import '../../../util/images.dart';

class UpdateScreen extends StatefulWidget{
  const UpdateScreen({Key key}) : super(key: key);

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    // TODO: implement initState
    observer.analytics.logScreenView(screenClass: 'UpdateScreen', screenName: 'Update');
    observer.analytics.setCurrentScreen(screenName: 'UpdateScreen');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(onPressed: ()=> getUpdate(), icon: const Icon(Icons.download, color: Colors.white,), label: Text('update'.tr, style: const TextStyle(color: Colors.white),)),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 100,),
                Center(child: Image.asset(Images.update),),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.5),
                    borderRadius: BorderRadius.circular(100)
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Text('v: ${Get.find<SplashController>().configModel.getVersionBuild} ${'available'.tr}'),
                ),
                const SizedBox(height: 20,),
                Text('update_info'.tr, textAlign: TextAlign.center, style: TextStyle(
                  fontSize: 15, color: Theme.of(context).disabledColor
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getUpdate() async{
    var config = Get.find<SplashController>().configModel;
    if(Platform.isAndroid){
      await RLaunchAppstore().launchAndroidStore(config.packageName);
    }else{
      await RLaunchAppstore().launchIOSStore(config.idAppIos);
    }
  }
}