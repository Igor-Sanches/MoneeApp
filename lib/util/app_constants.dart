import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';

import '../data/model/response/language_model.dart';
import 'images.dart';

class AppConstants {
  static const String APP_NAME = 'Bolsa Familia News';
  static const double APP_VERSION = 1.7;

  static const String BASE_URL = 'https://719a-2804-3048-4100-3a1-84-da27-9ef-89b4.sa.ngrok.io';
  static const String CONFIG_URI = '/api/config/app';
  static const String GAMES_URI = '/api/games/list';
  static const String LOGIN_URI = '/api/auth/login';
  static const String REGISTER_URI = '/api/auth/register';
  static const String TOKEN_URI = '/api/user/token-update';
  static const String VERIFY_TOKEN_URI = '/api/auth/verify-token';
  static const String USER_INFO_URI = '/api/user/info';
  static const String UPDATE_PROFILE_URI = '/api/user/update';
  static const String USER_REMOVE = '/api/user/delete';
  static const String GAME_TIC_TAC_TOE = '/api/user/game/tic-tac-toe';
  static const String GAME_LUCKY_TABLE = '/api/user/game/lucky-table';
  static const String GAME_PLAYING_CARD = '/api/user/game/playing-card';
  static const String GAME_SPIN_TO_WIN = '/api/user/game/spin-to-win';
  static const String TIC_TAC_TOE_CONNECTION_URI = '/api/games/tic-tac-toe';
  static const String GAME_SCRATCH_AND_WIN = '/api/user/game/scratch-and-win';
  static const String SCRATCH_AND_WIN_CONNECTION_URI = '/api/games/scratch-and-win';
  static const String LUCKY_TABLE_CONNECTION_URI = '/api/games/lucky-table';
  static const String PLAYING_CARD_CONNECTION_URI = '/api/games/playing-card';
  static const String SPIN_TO_WIN_CONNECTION_URI = '/api/games/spin-to-win';
  static const String LIST_ADS_URI = '/api/user/ads/list';
  static const String PUT_COIN_AD_URI = '/api/user/ads/put-coin';
  static const String LIST_RANKING_URI = '/api/user/ranking';

  // Shared Key
  static const String THEME = 'MultiplosDelivery_theme';
  static const String TOKEN = 'cNTRSDOAWoBoBlUkJPJr0KI58WrbZXH3e5nvlhcL0zFJwMRUsa6Jc2CirFyDmizyjPncL0hQRB3B0AuXLQ7dxVm8iBVuGGiu62tu';
  static const String COUNTRY_CODE = 'MultiplosDelivery_country_code';
  static const String LANGUAGE_CODE = 'MultiplosDelivery_language_code';
  static const String CART_LIST = 'MultiplosDelivery_cart_list';
  static const String USER_PASSWORD = 'MultiplosDelivery_user_password';
  static const String USER_ADDRESS = 'MultiplosDelivery_user_address';
  static const String USER_EMAIL = 'MultiplosDelivery_user_email';
  static const String USER_COUNTRY_CODE = 'MultiplosDelivery_user_country_code';
  static const String NOTIFICATION = 'MultiplosDelivery_notification';
  static const String SEARCH_HISTORY = 'MultiplosDelivery_search_history';
  static const String INTRO = 'MultiplosDelivery_intro';
  static const String NOTIFICATION_COUNT = 'MultiplosDelivery_notification_count';
  static const String LANGUAGE = 'language_key';
  static const String NOTIFICTION_DATA = 'notification_data';

  static const String TOPIC = 'all_zone_customer';
  static const String ZONE_ID = 'zoneId';
  static const String MODULE_ID = 'moduleId';
  static const String LOCALIZATION_KEY = 'X-localization';
  static const String LATITUDE = 'latitude';
  static const String LONGITUDE = 'longitude';

  static const String TIC_TAC_TOE_VICTORIES = 'tic_tac_toe_victories';
  static const String TIC_TAC_TOE_TIES = 'tic_tac_toe_ties';
  static const String TIC_TAC_TOE_DEFEATS = 'tic_tac_toe_defeats';

  // Delivery Tips
  static List<int> tips = [0, 5, 10, 15, 20, 30, 50];

  static List<LanguageModel> languages = [
    LanguageModel(imageUrl: Images.language, languageName: 'Português', countryCode: 'BR', languageCode: 'pt'),
    LanguageModel(imageUrl: Images.language, languageName: 'English', countryCode: 'US', languageCode: 'en'),
    // LanguageModel(imageUrl: Images.arabic, languageName: 'عربى', countryCode: 'SA', languageCode: 'ar'),
  ];

  static Future<Map<String, dynamic>> dataDevice()async{
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    String os = GetPlatform.isAndroid ? 'android' : 'ios';
    Map<String, dynamic> data = {};
    if(GetPlatform.isAndroid){
      var dataAndroid = await deviceInfo.androidInfo;
      data['model'] = dataAndroid.model;
      data['brand'] = dataAndroid.brand;
      data['os_version'] = dataAndroid.version.release;
      data['manufacturer'] = dataAndroid.manufacturer;
    }else{
      var dataIOS = await deviceInfo.iosInfo;
      data['model'] = dataIOS.model;
      data['brand'] = dataIOS.name;
      data['machine'] = dataIOS.utsname.machine;
      data['os_version'] = dataIOS.systemVersion;
      data['manufacturer'] = 'Apple';
    }
    return {
      'os':os,
      'device_info':data
    };
  }

}
