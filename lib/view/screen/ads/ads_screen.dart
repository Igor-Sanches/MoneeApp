import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:monetization/helper/helpers.dart';
import 'package:monetization/helper/route_helper.dart';

import '../../../controller/ads_controller.dart';
import '../../../controller/auth_controller.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/ads_view.dart';
import '../../base/no_data_screen.dart';
import '../../base/no_login_screen.dart';

class AdsScreen extends StatefulWidget{
  const AdsScreen({Key key}) : super(key: key);

  @override
  State<AdsScreen> createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  final ScrollController scrollController = ScrollController();
  final bool _isLoggedIn = Get.find<AuthController>().isLoggedIn();

  @override
  void initState() {
    // TODO: implement initState
    Get.find<AdsController>().isLogin = _isLoggedIn;
    Get.find<AdsController>().getGames(1, true);

    scrollController?.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<AdsController>().adsList != null
          && !Get.find<AdsController>().paginate) {
        int pageSize = (Get.find<AdsController>().pageSize / 10).ceil();
        if (Get.find<AdsController>().offset < pageSize) {
          Get.find<AdsController>().setOffset(Get.find<AdsController>().offset+1);
          Get.find<AdsController>().showFoodBottomLoader();
          Get.find<AdsController>().getGames(Get.find<AdsController>().offset, false);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF3F4FB),
        body: GetBuilder<AdsController>(builder: (adsController){
          return RefreshIndicator(
            onRefresh: () async {
              await adsController.getGames(1, true);
            },
            child: adsController.isLogin ? adsController.adsList != null ? adsController.adsList.isNotEmpty ? Column(
              children: [
                Expanded(child: Scrollbar(
                  child: CustomScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    controller: scrollController,
                    slivers: [
                      SliverToBoxAdapter(child: Center(child: SizedBox(
                        width: Dimensions.WEB_MAX_WIDTH,
                        child: Column(children: [
                          AdsView(
                            ads: adsController.adsList,
                            padding: EdgeInsets.symmetric(
                              vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_SMALL : 0,
                            ),
                            onTap: (ad){
                              context.loaderOverlay.show();
                              adsController.startAdCall(ad);
                            },
                          ),
                          adsController.paginate ? const Center(child: Padding(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            child: CircularProgressIndicator(),
                          )) : const SizedBox(),
                          const SizedBox(height: 100,)
                        ]),
                      ))),
                    ],
                  ),
                )),
              ],
            ) : NoDataScreen(text: 'no_ads'.tr, image: Images.no_ads) : Helpers.loading() : const NoLoginScreen(image: Images.no_login),
          );
        })
    );
  }
}