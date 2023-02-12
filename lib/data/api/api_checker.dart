import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../helper/route_helper.dart';
import '../../view/base/custom_snackbar.dart';

class ApiChecker {
  static void checkApi(Response response, {int status: 1}) {
    if(response.statusCode == 401) {
      Get.find<AuthController>().clearSharedData();
      Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
    }else {
      if(response.statusCode != 404){
        showCustomSnackBar(response.statusText);
      }
    }
  }
}
