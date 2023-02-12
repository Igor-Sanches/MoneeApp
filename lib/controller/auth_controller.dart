import 'package:image_picker/image_picker.dart';
import 'package:monetization/data/model/response/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/model/response/response_model.dart';
import '../data/repository/auth_repo.dart';
import '../util/app_constants.dart';
import 'user_controller.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;
  AuthController({@required this.authRepo}) {
   _notification = authRepo.isNotificationActive();
  }

  bool _isLoading = false;
  bool _notification = true;
  bool _acceptTerms = true;
  XFile _pickedImage;
  bool get isLoading => _isLoading;
  bool get notification => _notification;
  bool get acceptTerms => _acceptTerms;
  XFile get pickedImage => _pickedImage;

  User get userModel => authRepo.getUserModel();

  Future<ResponseModel> registration(name, zipcode, phone, email, password, referCode) async {
    _isLoading = true;
    update();
    var device = await AppConstants.dataDevice();
    Response response = await authRepo.registration(name, zipcode, phone, email, password, referCode, device['os'], device['device_info']);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
        authRepo.saveUserToken(response.body['data']["token"], User.fromJson(response.body['data']["user"]));
        await authRepo.updateToken();
        Get.find<UserController>().getUserInfo();
      responseModel = ResponseModel(true, response.body['data']["token"]);
    } else if(response.statusCode == 403){
      responseModel = ResponseModel(false, response.body['data']['message'].toString().tr);
    }  else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<ResponseModel> login(String email, String password) async {
    _isLoading = true;
    update();
    var device = await AppConstants.dataDevice();
    Response response = await authRepo.login(email: email, password: password, os: device['os'], deviceInfo: device['device_info']);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body['data']['token'], User.fromJson(response.body['data']["user"]));
      await authRepo.updateToken();
      Get.find<UserController>().getUserInfo();
      responseModel = ResponseModel(true, '${response.body['data']['is_phone_verified']}${response.body['token']}');
    } else if(response.statusCode == 403){
      responseModel = ResponseModel(false, response.body['data']['message'].toString().tr);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  Future<void> updateToken() async {
    await authRepo.updateToken();
  }

  Future<ResponseModel> verifyToken(String email) async {
    _isLoading = true;
    update();
    Response response = await authRepo.verifyToken(email, _verificationCode);
    ResponseModel responseModel;
    if (response.statusCode == 200) {
      responseModel = ResponseModel(true, response.body["message"]);
    } else {
      responseModel = ResponseModel(false, response.statusText);
    }
    _isLoading = false;
    update();
    return responseModel;
  }

  String _verificationCode = '';

  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query) {
    _verificationCode = query;
    update();
  }

  bool _isActiveRememberMe = false;

  bool get isActiveRememberMe => _isActiveRememberMe;

  void toggleTerms() {
    _acceptTerms = !_acceptTerms;
    update();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  bool clearSharedAddress() {
    return authRepo.clearSharedAddress();
  }

  void saveUserNumberAndPassword(String number, String password, String countryCode) {
    authRepo.saveUserNumberAndPassword(number, password, countryCode);
  }

  String getUserEmail() {
    return authRepo.getUserEmail() ?? "";
  }

  String getUserCountryCode() {
    return authRepo.getUserCountryCode() ?? "";
  }

  String getUserPassword() {
    return authRepo.getUserPassword() ?? "";
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  bool setNotificationActive(bool isActive) {
    _notification = isActive;
    authRepo.setNotificationActive(isActive);
    update();
    return _notification;
  }

  void pickImage(bool isRemove) async {
    if(isRemove) {
      _pickedImage = null;
    }else {
      _pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
      update();
    }
  }

  // bool _checkIfValidMarker(LatLng tap, List<LatLng> vertices) {
  //   int intersectCount = 0;
  //   for (int j = 0; j < vertices.length - 1; j++) {
  //     if (_rayCastIntersect(tap, vertices[j], vertices[j + 1])) {
  //       intersectCount++;
  //     }
  //   }
  //
  //   return ((intersectCount % 2) == 1); // odd = inside, even = outside;
  // }

  // bool _rayCastIntersect(LatLng tap, LatLng vertA, LatLng vertB) {
  //   double aY = vertA.latitude;
  //   double bY = vertB.latitude;
  //   double aX = vertA.longitude;
  //   double bX = vertB.longitude;
  //   double pY = tap.latitude;
  //   double pX = tap.longitude;
  //
  //   if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
  //     return false; // a and b can't both be above or below pt.y, and a or
  //     // b must be east of pt.x
  //   }
  //
  //   double m = (aY - bY) / (aX - bX); // Rise over run
  //   double bee = (-aX) * m + aY; // y = mx + b
  //   double x = (pY - bee) / m; // algebra is neat!
  //
  //   return x > pX;
  // }

}