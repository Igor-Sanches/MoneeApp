import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetization/util/images.dart';
import 'package:monetization/util/songs.dart';
import 'package:monetization/util/styles.dart';

import '../../../helper/helpers.dart';

class AwardScreen extends StatefulWidget{
  final Map<String, dynamic> payload;
  final String coin;
  final String title;
  final String msg;
  final bool ad;
  const AwardScreen({Key key, this.payload, this.coin, this.title, this.msg, this.ad}) : super(key: key);

  @override
  State<AwardScreen> createState() => _AwardScreenState();
}

class _AwardScreenState extends State<AwardScreen> {

  @override
  void initState() {
    // TODO: implement initState
    Helpers.playSound(Songs.victory);
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
                Image.asset(_image()),
                const SizedBox(height: 20,),
                Text(widget.title, style: robotoMedium.copyWith(
                    fontSize: 17
                ),),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: Text(widget.msg, style: robotoMedium.copyWith(
                      fontSize: 14
                  ), textAlign: TextAlign.center,),
                ),
                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Text(Helpers.getCoin(widget.coin), style: robotoMedium.copyWith(
                      fontSize: 20
                  )),
                ),
                const SizedBox(height: 20,),
                TextButton(onPressed: ()=>Get.back(), child: Text('finish'.tr)),
                const SizedBox(height: 50,),
              ],
            ),
          )
        ),
      ),
    );
  }

  String _image() {
    if(widget.ad){
      return Images.award_ad;
    }
    return Images.award;
  }
}