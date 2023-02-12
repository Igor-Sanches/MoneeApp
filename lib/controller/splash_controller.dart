import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/api/api_checker.dart';
import '../data/api/api_client.dart';
import '../data/model/response/config_model.dart';
import '../data/repository/splash_repo.dart';
import '../util/html_type.dart';
import '../view/base/custom_snackbar.dart';

class SplashController extends GetxController implements GetxService {
  final SplashRepo splashRepo;
  SplashController({@required this.splashRepo});

  ConfigModel _configModel;
  bool _firstTimeConnectionCheck = true;
  bool _hasConnection = true;
  int _moduleIndex = 0;
  Map<String, dynamic> _data = {};
  String _htmlText;
  bool _isLoading = false;
  int _selectedModuleIndex = 0;

  ConfigModel get configModel => _configModel;
  DateTime get currentTime => DateTime.now();
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  bool get hasConnection => _hasConnection;
  int get moduleIndex => _moduleIndex;
  String get htmlText => _htmlText;
  bool get isLoading => _isLoading;
  int get selectedModuleIndex => _selectedModuleIndex;

  void selectModuleIndex(int index) {
    _selectedModuleIndex = index;
    update();
  }

  Future<bool> getConfigData() async {
    _hasConnection = true;
    _moduleIndex = 0;
    Response response = await splashRepo.getConfigData();
    bool _isSuccess = false;
    if(response.statusCode == 200) {
      if((response.body['auth'] ?? '') == 'api_rest'){
        ApiChecker.checkApi(response);
        if(response.statusText == ApiClient.noInternetMessage) {
          _hasConnection = false;
        }
        _isSuccess = false;
      }else{
        _data = response.body['data'];
        _configModel = ConfigModel.fromJson(_data);
        _isSuccess = true;
      }
    }else {
      ApiChecker.checkApi(response);
      if(response.statusText == ApiClient.noInternetMessage) {
        _hasConnection = false;
      }
      _isSuccess = false;
    }
    update();
    return _isSuccess;
  }

  void initSharedData() {
    splashRepo.initSharedData();
  }

  bool showIntro() {
    return splashRepo.showIntro();
  }

  void disableIntro() {
    splashRepo.disableIntro();
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }

  void setModuleIndex(int index) {
    _moduleIndex = index;
    update();
  }

  Future<void> getHtmlText(HtmlType htmlType) async {
    _htmlText = null;
    Response response = await splashRepo.getHtmlText(htmlType);
    if (response.statusCode == 200) {
      if(htmlType == HtmlType.SHIPPING_POLICY || htmlType == HtmlType.CANCELATION || htmlType == HtmlType.REFUND){
        _htmlText = response.body['value'];
      }else{
        _htmlText = response.body;
      }

      if(_htmlText != null && _htmlText.isNotEmpty) {
        _htmlText = _htmlText.replaceAll('href=', 'target="_blank" href=');
      }else {
        _htmlText = '';
      }
    } else {
      ApiChecker.checkApi(response);
    }
    update();
  }

  bool getLanguage() {
    return splashRepo.getLanguage();
  }

  getLocale() {
    return splashRepo.getLanguageLocale();
  }

  void setNotification(Map<String, dynamic> data) {
    splashRepo.setNotification(data);
  }

  getNotification() {
    return splashRepo.getNotification();
  }

  void removeNotification() {
    splashRepo.removeNotification();
  }

}
