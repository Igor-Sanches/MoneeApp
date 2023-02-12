import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../util/dimensions.dart';
import '../../util/styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool backButton;
  final Function onBackPressed;
  final bool showCart;
  bool searchButton;
  final String leadingIcon;
  CustomAppBar({Key key, @required this.title, this.backButton = true, this.onBackPressed, this.showCart = false, this.leadingIcon, this.searchButton = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title, style: robotoRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).textTheme.bodyText1.color)),
      centerTitle: true,
      leading: backButton ? IconButton(
        icon: leadingIcon != null ? Image.asset(leadingIcon, height: 22, width: 22) : const Icon(Icons.arrow_back_ios),
        color: Theme.of(context).textTheme.bodyLarge.color,
        onPressed: () => onBackPressed != null ? onBackPressed() : Navigator.pop(context),
      ) : const SizedBox(),
      backgroundColor: Theme.of(context).cardColor,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size(Get.width, GetPlatform.isDesktop ? 70 : 50);
}
