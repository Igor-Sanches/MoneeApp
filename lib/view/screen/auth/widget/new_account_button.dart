import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/route_helper.dart';
import '../../../../util/styles.dart';

class NewAccountButton extends StatelessWidget {
  const NewAccountButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size(1, 40),
      ),
      onPressed: () {
        Get.toNamed(RouteHelper.getSignUpRoute());
      },
      child: RichText(text: TextSpan(children: [
        TextSpan(text: '${'no_account'.tr} ', style: robotoBold.copyWith(color: Colors.black)),
        TextSpan(text: 'register_new_account'.tr, style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
      ])),
    );
  }
}
