import 'package:get/get.dart';

import '../../../controller/splash_controller.dart';

class AdsModel{
  int totalSize;
  String limit;
  int offset;
  List<Ads> ads;

  AdsModel( {
    this.totalSize ,
    this.limit ,
    this.offset ,
    this.ads
  });

  AdsModel.fromJson(Map<String, dynamic> json) {
    totalSize = json['total_size'];
    limit = json['limit'].toString();
    offset = (json['offset'] != null && json['offset'].toString().trim().isNotEmpty) ? int.parse(json['offset'].toString()) : null;
    if (json['ads'] != null) {
      ads = [];
      json['ads'].forEach((v) {
        ads.add(Ads.fromJson(v));
      });
    }
  }
}

class Ads{
  String id;
  String name;
  String image;
  String idAd;
  int viewsDay;
  int viewHere;
  int totalViews;
  String coin;

  Ads.fromJson(json){
    id = json['id'];
    name = json['name'];
    image = json['image'];
    idAd = json['id_ad'];
    viewsDay = json['views_day'];
    viewHere = json['view_here'];
    totalViews = json['total_views']??0;
    coin = json['coin'];
  }

  String get imagePath => '${Get.find<SplashController>().configModel.pathImageAd}/$image';

  Map<String, dynamic> toMap() {
    return {
      'id':id,
      'name':name
    };
  }
}