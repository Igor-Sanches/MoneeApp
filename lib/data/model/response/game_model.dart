import 'package:get/get.dart';

import '../../../controller/splash_controller.dart';

class GameModel{
  int totalSize;
  String limit;
  int offset;
  List<Game> games;

  GameModel( {
    this.totalSize ,
    this.limit ,
    this.offset ,
    this.games
  });

  GameModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = (json['offset'] != null && json['offset'].toString().trim().isNotEmpty) ? int.parse(json['offset'].toString()) : null;
    if (json['games'] != null) {
      games = [];
      json['games'].forEach((v) {
        games.add(Game.fromJson(v));
      });
    }
  }
}

class Game{
  String id;
  String image;
  String name;
  String description;
  int maxCoin;
  int view;
  int victories;
  String tag;
  String banner;
  String intersticial;
  String intersticialRewarded;
  String rewarded;

  Game.fromJson(json){
    id = json['id'];
    banner = json['banner_id'];
    intersticial = json['intersticial_id'];
    intersticialRewarded = json['intersticial_rewarded_id'];
    rewarded = json['rewarded_id'];
    tag = json['tag'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    maxCoin = json['max_coin'];
    view = json['view'];
    victories = json['victories'] ?? 0;
  }

  get imagePath => '${Get.find<SplashController>().configModel.pathImageGame}/$image';
}