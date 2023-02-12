import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../util/styles.dart';

class AlreadyHaveAnAccountButton extends StatelessWidget {
  const AlreadyHaveAnAccountButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        minimumSize: const Size(1, 40),
      ),
      onPressed: () {
        Get.back();
      },
      child: RichText(text: TextSpan(children: [
        TextSpan(text: '${'already_have_an_account'.tr} ', style: robotoBold.copyWith(color: Colors.black)),
        TextSpan(text: 'enter'.tr, style: robotoBold.copyWith(color: Theme.of(context).primaryColor)),
      ])),
    );
  }
}
