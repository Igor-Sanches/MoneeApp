import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetization/data/model/response/game_model.dart';

import '../data/api/api_checker.dart';
import '../data/repository/games_repo.dart';

class GamesController extends GetxController implements GetxService {
  final GamesRepo gamesRepo;
  GamesController({@required this.gamesRepo});

  List<Game> _gamesList = [];
  List<int> _offsetList = [];
  GameModel _gameModel;
  bool _isLoading = true;
  bool _paginate = false;
  int _pageSize;
  int _offset = 1;

  List<Game> get gamesList => _gamesList;
  GameModel get gameModel => _gameModel;
  bool get isLoading => _isLoading;
  bool get paginate => _paginate;
  int get pageSize => _pageSize;
  int get offset => _offset;

  Future<void> getGames(int offset, bool notify) async {
    _offset = offset;
    if(offset == 1 || _gamesList == null) {
      _gamesList = null;
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
      Response response = await gamesRepo.getGames(offset);
      _isLoading = false;
      if (response.statusCode == 200) {
        if (offset == 1) {
          _gamesList = [];
        }
        var games = GameModel.fromJson(response.body['data']).games;
        _gamesList.addAll(games);
        _pageSize = GameModel.fromJson(response.body['data']).totalSize;
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