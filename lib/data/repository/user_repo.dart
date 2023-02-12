import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monetization/data/model/response/user_model.dart';

import '../../util/app_constants.dart';
import '../api/api_client.dart';

class UserRepo {
  final ApiClient apiClient;
  UserRepo({@required this.apiClient});

  Future<Response> getUserInfo() async {
    return await apiClient.getData(AppConstants.USER_INFO_URI);
  }

  Future<Response> updateProfile(User userInfoModel, XFile data, String token) async {
    Map<String, String> body = {};
    body.addAll(<String, String>{
      'name': userInfoModel.name, 'email': userInfoModel.email
    });
    return await apiClient.postMultipartData(AppConstants.UPDATE_PROFILE_URI, body, [MultipartBody('image', data)]);
  }

  Future<Response> changePassword(User userInfoModel) async {
    return await apiClient.postData(AppConstants.UPDATE_PROFILE_URI, {'name': userInfoModel.name,
      'email': userInfoModel.email, 'password': userInfoModel.password});
  }

  Future<Response> deleteUser() async {
    return await apiClient.deleteData(AppConstants.USER_REMOVE);
  }

}