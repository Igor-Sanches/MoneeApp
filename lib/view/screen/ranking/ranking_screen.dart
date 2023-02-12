import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:get/get.dart';
import 'package:monetization/util/images.dart';
import 'package:monetization/util/songs.dart';
import 'package:monetization/util/styles.dart';

import '../../../controller/auth_controller.dart';
import '../../../controller/ranking_controller.dart';
import '../../../helper/helpers.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/dimensions.dart';
import '../../base/no_data_screen.dart';
import '../../base/ranking_view.dart';

class RankingScreen extends StatefulWidget{
  const RankingScreen({Key key}) : super(key: key);


  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    Get.find<RankingController>().getRanking(1, true);

    scrollController?.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<RankingController>().usersList != null
          && !Get.find<RankingController>().paginate) {
        int pageSize = (Get.find<RankingController>().pageSize / 10).ceil();
        if (Get.find<RankingController>().offset < pageSize) {
          Get.find<RankingController>().setOffset(Get.find<RankingController>().offset+1);
          Get.find<RankingController>().showFoodBottomLoader();
          Get.find<RankingController>().getRanking(Get.find<RankingController>().offset, false);
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('ranking'.tr, style: const TextStyle(color: Colors.black),),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(onPressed: ()=> Get.find<RankingController>().getRanking(1, true), icon: const Icon(Icons.refresh, color: Colors.black,)),
          GetBuilder<AuthController>(builder: (authController) {
            return GetBuilder<RankingController>(builder: (orderController) {
              return (authController.userModel != null) ? FlutterSwitch(
                width: 75, height: 30, valueFontSize: 12, showOnOff: true,
                activeText: 'online'.tr, inactiveText: 'offline'.tr, activeColor: Theme.of(context).primaryColor,
                value: authController.userModel.onlineRanking, onToggle: (bool isActive){
              }
              ) : const SizedBox();
            });
          }),
          const SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
        ],
      ),
      body: SafeArea(
        child: GetBuilder<RankingController>(builder: (controller){
          return RefreshIndicator(
              onRefresh: () async {
                await controller.getRanking(1, true);
              },
              child: controller.usersList != null ? controller.usersList.isNotEmpty ? Column(
                children: [
                  Expanded(child: Scrollbar(
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      slivers: [
                        SliverToBoxAdapter(child: Center(child: SizedBox(
                          width: Dimensions.WEB_MAX_WIDTH,
                          child: Column(children: [
                            ListTile(
                              title: Text('ranking_list'.tr),
                              subtitle: Text('ranking_list_info'.tr),
                            ),
                            RankingView(
                              users: controller.usersList,
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_SMALL : 0,
                              ),
                            ),
                            controller.paginate ? const Center(child: Padding(
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
              ) : NoDataScreen(text: 'no_users'.tr, image: Images.no_ranking) : Helpers.loading()
          );
        },),
      ),
    );
  }

}