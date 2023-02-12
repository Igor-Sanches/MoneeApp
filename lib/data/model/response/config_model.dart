import 'dart:io';

class ConfigModel{
  String infoEditor;
  String privacyPolicy;
  String topicFirebase;
  String versionAppIos;
  String versionAppAndroid;
  String idAppIos;
  String linkMoreAppsAndroid;
  String linkMoreAppsIos;
  String packageName;
  String languageApp;
  String pathImageGame;
  String pathImageAd;
  bool inPlayStore;
  bool maintenance;
  Ads ads;

  ConfigModel.fromJson(json){
    maintenance = json['maintenance'];
    infoEditor = json['info_editor'];
    privacyPolicy = json['privacy_policy'];
    topicFirebase = json['topic_firebase'];
    versionAppAndroid = json['version_app_android'].toString();
    versionAppIos = json['version_app_ios'].toString();
    inPlayStore = json['in_play_store'];
    idAppIos = json['id_app_ios'];
    linkMoreAppsAndroid = json['link_more_apps_android'];
    linkMoreAppsIos = json['link_more_apps_ios'];
    packageName = json['package_name'];
    languageApp = json['language_app'];
    pathImageGame = json['path_image_game'];
    pathImageAd = json['path_image_ad'];

    ads = Ads.fromJson(json['ads']);
  }

  String get getVersionBuild => Platform.isAndroid ? _forVersion(versionAppAndroid) : _forVersion(versionAppIos);

  String get getMoreApps => Platform.isAndroid ? linkMoreAppsAndroid : linkMoreAppsIos;

  String get getShareInfo {
    return 'Android: https://play.google.com/store/apps/details?id=$packageName\n\nIOS: https://apps.apple.com/us/app/id$idAppIos';
  }

  String _forVersion(version){
    return '$version'.contains('.') ? '$version'.split('.')[0] : version;
  }
}

class Ads{
  Device android;
  Device ios;

  Ads.fromJson(json){
    print('jsonjson $json');
    android = Device.fromJson(json['android']);
    ios = Device.fromJson(json['ios']);
  }
}

class Device{
  String opening;
  String banner;
  String bannerExit;
  String native;
  String intersticial;

  Device.fromJson(json){
    opening = json['opening'];
    banner = json['banner'];
    bannerExit = json['banner_exit'];
    native = json['native'];
    intersticial = json['intersticial'];
  }
}