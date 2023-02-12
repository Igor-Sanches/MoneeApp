import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/api/api_checker.dart';
import '../data/model/response/user_model.dart';
import '../data/repository/ranking_repo.dart';

class RankingController extends GetxController implements GetxService {
  final RankingRepo rankingRepo;
  RankingController({@required this.rankingRepo});

  List<User> _usersList = [];
  List<int> _offsetList = [];
  UserModel _adModel;
  bool _isLoading = true;
  bool _paginate = false;
  int _pageSize;
  int _offset = 1;

  List<User> get usersList => _usersList;
  UserModel get adModel => _adModel;
  bool get isLoading => _isLoading;
  bool get paginate => _paginate;
  int get pageSize => _pageSize;
  int get offset => _offset;

  Future<void> getRanking(int offset, bool notify) async {
    _offset = offset;
    if(offset == 1 || _usersList == null) {
      _usersList = null;
      _offset = 1;
      _offsetList = [];
      if(notify) {
        try{
          update();
        }catch(x){

        }
      }
    }
    if (!_offsetList.contains(offset)) {
      _offsetList.add(offset);
      Response response = await rankingRepo.getGames(offset);
      _isLoading = false;
      if (response.statusCode == 200) {
        if (offset == 1) {
          _usersList = [];
        }
        var ads = UserModel.fromJson(response.body['data']).users;
        _usersList.addAll(ads);
        _pageSize = UserModel.fromJson(response.body['data']).totalSize;
        _paginate = false;
        update();
      } else {
        ApiChecker.checkApi(response);
      }
    } else {
      if(_paginate) {
        _paginate = false;
        update();
      }
    }
  }

  void setOffset(int offSet) {
    _offset = offSet;
  }

  void showFoodBottomLoader() {
    _paginate = true;
    update();

  }

}