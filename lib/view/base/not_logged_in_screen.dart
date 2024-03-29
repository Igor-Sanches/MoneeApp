import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/route_helper.dart';
import '../../util/images.dart';
import '../../util/styles.dart';
import 'custom_button.dart';

class NotLoggedInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min, children: [

          SizedBox(height: 30),
          Image.asset(
            Images.guest,
            width: MediaQuery.of(context).size.height*0.25,
            height: MediaQuery.of(context).size.height*0.25,
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.01),

          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Center(
              child: Text(
                'sorry'.tr,
                style: robotoBold.copyWith(fontSize: MediaQuery.of(context).size.height*0.023, color: Theme.of(context).primaryColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.01),

          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: Center(
              child:
              Text(
                'you_are_not_logged_in'.tr,
                style: robotoRegular.copyWith(fontSize: MediaQuery.of(context).size.height*0.0175, color: Theme.of(context).disabledColor),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*0.04),

          SizedBox(
            width: 200,
            child: CustomButton(buttonText: 'login_to_continue'.tr, height: 40, onPressed: () {
              Get.toNamed(RouteHelper.getSignInRoute(RouteHelper.main));
            }),
          ),

        ]),
      ),
    );
  }
}
