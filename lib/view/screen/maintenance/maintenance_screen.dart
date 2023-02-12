import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/route_helper.dart';
import '../../../util/images.dart';

class MaintenanceScreen extends StatefulWidget{
  const MaintenanceScreen({Key key}) : super(key: key);

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  @override
  void initState() {
    // TODO: implement initState
    observer.analytics.logScreenView(screenClass: 'MaintenanceScreen', screenName: 'Maintenance');
    observer.analytics.setCurrentScreen(screenName: 'MaintenanceScreen');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(onPressed: ()=>Get.offAllNamed(RouteHelper.getSplashRoute()), icon: const Icon(Icons.refresh, color: Colors.white,), label: Text('establish_connection'.tr, style: const TextStyle(color: Colors.white),)),
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
                Center(child: Image.asset(Images.maintenance),),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(.5),
                    borderRadius: BorderRadius.circular(100)
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                  child: Text('under_maintenance'.tr),
                ),
                const SizedBox(height: 20,),
                Text('under_maintenance_info'.tr, textAlign: TextAlign.center, style: TextStyle(
                  fontSize: 15, color: Theme.of(context).disabledColor
                ),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}