import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helper/route_helper.dart';
import '../../../../util/Iconx.dart';
import '../../../../util/dimensions.dart';
import '../../../../util/images.dart';

class DrawerWidget extends StatelessWidget{
  final GlobalKey<ScaffoldState> scaffoldKey;

  DrawerWidget({Key key, @required this.scaffoldKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(
            children: [
              Card(
                elevation: 10,
                child: SizedBox(
                  width: context.width, height: 175,
                  child: Center(child: Image.asset(Images.bg_header, height: 175, width: Dimensions.WEB_MAX_WIDTH, fit: BoxFit.fill)),
                ),
              ),
              ListTile(
                  title: Text('ranking'.tr),
                  leading: Image.asset(Iconx.ranking, width: 24,),
                  onTap: () {
                    close();
                    Get.toNamed(RouteHelper.getRankingRoute());
                  }
              ),
              ListTile(
                  title: Text('contact_us'.tr),
                  leading: Image.asset(Iconx.contact_us, width: 24,),
                  onTap: () {
                    close();
                  }
              ),
              ListTile(
                  title: Text('rate'.tr),
                  leading: Image.asset(Iconx.rate, width: 24,),
                  onTap: () {
                    close();
                  }
              ),
              ListTile(
                  title: Text('share_app'.tr),
                  leading: Image.asset(Iconx.share, width: 24,),
                  onTap: () {
                    close();
                  }
              ),
              ListTile(
                  title: Text('invite_friend'.tr),
                  leading: Image.asset(Iconx.ref, width: 24,),
                  trailing: Container(
                    padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(.4),
                      borderRadius: BorderRadius.circular(50)
                    ),
                    child: Text('Bônus', style: TextStyle(color: Colors.red),),
                  ),
                  onTap: () {
                    close();
                  }
              ),

            ],
          )),
          Container(
            height: 1,
            width: 220,
            color: Colors.grey,
          ),
          ListTile(
              title: Text('profile'.tr),
              leading: Image.asset(Iconx.user, width: 24,),
              onTap: () {
                close();
              }
          ), ListTile(
            title: Text('about'.tr),
            leading: Image.asset(Iconx.info, width: 24,),
              onTap: () {
                close();
                Get.toNamed(RouteHelper.getAboutRoute());
              }
          ),
        ],
      ),
    );
  }

  void close() {
    scaffoldKey.currentState.closeDrawer();
  }

}