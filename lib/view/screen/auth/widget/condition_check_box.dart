import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/auth_controller.dart';
import '../../../../helper/route_helper.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class ConditionCheckBox extends StatelessWidget {
  final AuthController authController;
  const ConditionCheckBox({@required this.authController});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Checkbox(
        activeColor: Theme.of(context).primaryColor,
        value: authController.acceptTerms,
        onChanged: (bool isChecked) => authController.toggleTerms(),
      ),
      Text('i_agree_with'.tr, style: robotoRegular),
      InkWell(
        onTap: () => Get.toNamed(RouteHelper.getHtmlRoute('terms-and-condition')),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
          child: Text('terms_conditions'.tr, style: robotoMedium.copyWith(color: Colors.blue)),
        ),
      ),
    ]);
  }
}
