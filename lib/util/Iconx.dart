import 'package:flutter/material.dart';

class Iconx {
  static const String wheel = 'assets/icons/wheel.png';
  static const String wallet = 'assets/icons/wallet.png';
  static const String game = 'assets/icons/game.png';
  static const String home = 'assets/icons/home.png';
  static const String video = 'assets/icons/video.png';
  static const String user = 'assets/icons/user.png';
  static const String share = 'assets/icons/share.png';
  static const String font_size = 'assets/icons/font_size.png';
  static const String favorite_selected = 'assets/icons/favorite_selected.png';
  static const String filter = 'assets/icons/filter.png';
  static const String setting = 'assets/icons/setting.png';
  static const String info = 'assets/icons/Info.png';
  static const String ranking = 'assets/icons/ranking.png';
  static const String contact_us = 'assets/icons/contact_us.png';
  static const String rate = 'assets/icons/rate.png';
  static const String ref = 'assets/icons/ref.png';

  static withWidget(String icon, {double size = 24}){
    return Image.asset(icon, width: size,);
  }
}
