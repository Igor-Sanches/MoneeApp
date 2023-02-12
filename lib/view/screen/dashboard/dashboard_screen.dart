import 'dart:async';
import 'dart:io';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../../controller/splash_controller.dart';
import '../../../helper/helpers.dart';
import '../../../helper/route_helper.dart';
import '../../../util/Iconx.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../ads/ads_screen.dart';
import '../games/games/tic_tac_toe_game_screen.dart';
import '../games/games_screen.dart';
import 'widget/bottom_nav_item.dart';
import 'widget/drawer_widget.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  final Map<String, dynamic> body;
  const DashboardScreen({Key key, @required this.pageIndex, this.body}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with WidgetsBindingObserver {
  PageController _pageController;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int _pageIndex = 0;
  bool isFilterEnabled = true;
  List<Widget> _screens;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final bool _canExit = GetPlatform.isWeb ? true : false;
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  ShapeBorder bottomBarShape = const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(25)),
  );
  SnakeBarBehaviour snakeBarStyle = SnakeBarBehaviour.floating;
  EdgeInsets padding = const EdgeInsets.all(12);

  SnakeShape snakeShape = SnakeShape.circle;

  bool showSelectedLabels = false;
  bool showUnselectedLabels = false;

  Color unselectedColor = Colors.blueGrey;

  Gradient selectedGradient =
  const LinearGradient(colors: [Colors.red, Colors.amber]);
  Gradient unselectedGradient =
  const LinearGradient(colors: [Colors.red, Colors.blueGrey]);

  Color containerColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    _pageIndex = widget.pageIndex;
    _pageController = PageController(initialPage: widget.pageIndex);
    _screens = [
      const AdsScreen(),
      const GamesScreen(),
      const SizedBox(),
    ];

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
    observer.analytics.logScreenView(screenClass: 'DashboardScreen', screenName: 'Dashboard');
    observer.analytics.setCurrentScreen(screenName: 'DashboardScreen');

  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: Center(
            child: Helpers.loading(),
          ),
          overlayOpacity: 0.8,
        child: Scaffold(
          key: _scaffoldKey,
          drawerEnableOpenDragGesture: false,
          backgroundColor: const Color(0xFFF3F4FB),
          drawer: DrawerWidget(scaffoldKey: _scaffoldKey,),
          appBar: AppBar(
            title: Text(nameToolBar()),
            backgroundColor: const Color(0xFFF3F4FB),
            iconTheme: const IconThemeData(
                color: Colors.black
            ),
            titleTextStyle: const TextStyle(color: Colors.black),
            elevation: 0,
            actions: [
              Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Center(
                  child: Image.asset(Images.logo),
                ),
              )
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          extendBody: true,
          bottomNavigationBar: AnimatedNotchBottomBar(
            pageController: _pageController,
            color: Colors.white,
            showLabel: false,
            notchColor: Theme.of(context).primaryColor,
            bottomBarItems: [
              BottomBarItem(
                inActiveItem: Image.asset(Iconx.home),
                activeItem: Image.asset(Iconx.home, color: Theme.of(context).cardColor, colorBlendMode: BlendMode.srcIn, width: 25,),
                itemLabel: 'home'.tr,
              ),
              BottomBarItem(
                inActiveItem: Image.asset(Iconx.game),
                activeItem: Image.asset(Iconx.game, color: Theme.of(context).cardColor, colorBlendMode: BlendMode.srcIn, width: 25,),
                itemLabel: 'games'.tr,
              ),
              BottomBarItem(
                inActiveItem: Image.asset(Iconx.wallet),
                activeItem: Image.asset(Iconx.wallet, color: Theme.of(context).cardColor, colorBlendMode: BlendMode.srcIn, width: 25,),
                itemLabel: 'wallet'.tr,
              ),
            ],
            onTap: (index) {
              /// control your animation using page controller
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeIn,
              );
            },
          ),
          body: WillPopScope(
            onWillPop: () async {
              if (_pageIndex != 0) {
                _setPage(0);
                return false;
              } else {
                if(_canExit) {
                  return true;
                }else {

                  Get.dialog(AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Center(child: Text('Deseja realmente sair?'),),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(child: TextButton(
                                style: ButtonStyle(
                                  foregroundColor: MaterialStateProperty.all(Colors.black),
                                  backgroundColor: MaterialStateProperty.all(Colors.grey[300]),
                                ),
                                onPressed: () => Get.back(),
                                child: const Text('NÃO')
                            )),
                            const SizedBox(width: 20,),
                            Expanded(child: TextButton(
                                style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty.all(Colors.black),
                                    backgroundColor: MaterialStateProperty.all(Colors.grey[300])
                                ),
                                onPressed: () {
                                  exit(0);
                                },
                                child: const Text('SIM')
                            ))
                          ],
                        ),
                        const SizedBox(height: 10,),
                      ],
                    ),
                  ));
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  //   content: Text('back_press_again_to_exit'.tr, style: const TextStyle(color: Colors.white)),
                  //   behavior: SnackBarBehavior.floating,
                  //   backgroundColor: Colors.green,
                  //   duration: const Duration(seconds: 2),
                  //   margin: const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  // ));
                  // _canExit = true;
                  // Timer(const Duration(seconds: 2), () {
                  //   _canExit = false;
                  // });
                  return false;
                }
              }
            },
            child: AnimatedContainer(
              color: containerColor,
              duration: const Duration(seconds: 1),
              child: Stack(
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _screens.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _screens[index];
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
      isFilterEnabled = _pageIndex == 0 || _pageIndex == 2;
    });
  }

  String nameToolBar() {
    String name = 'app_name';
    switch(_pageIndex){
      case 0: name = 'home'; break;
      case 1: name = 'games'; break;
      case 2: name = 'wallet'; break;
    }
    return name.tr;
  }

}
