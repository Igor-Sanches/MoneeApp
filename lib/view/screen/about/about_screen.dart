import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetization/util/images.dart';
import 'package:monetization/util/songs.dart';
import 'package:monetization/util/styles.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../helper/helpers.dart';

class AboutScreen extends StatefulWidget{
  const AboutScreen({Key key}) : super(key: key);


  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String version = '...';

  @override
  void initState() {
    // TODO: implement initState
    _versionApp().then((value) {
      version = value;
      setState(() {

      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50,),
                Image.asset(Images.about_company, height: 100,),
                const SizedBox(height: 20,),
                Text('app_name'.tr, style: robotoMedium.copyWith(
                    fontSize: 17
                ),),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text('about_app'.tr, style: robotoMedium.copyWith(
                      fontSize: 14
                  ), textAlign: TextAlign.center,),
                ),
                const SizedBox(height: 20,),
                TextButton(onPressed: (){}, child: Text('${'version'.tr}: $version')),
                const SizedBox(height: 50,),
              ],
            ),
          )
        ),
      ),
    );
  }

  Future<String> _versionApp() async{
    PackageInfo info = await PackageInfo.fromPlatform();
    return info.version;
  }
}