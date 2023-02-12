import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:monetization/helper/helpers.dart';

import '../../../controller/games_controller.dart';
import '../../../helper/responsive_helper.dart';
import '../../../util/dimensions.dart';
import '../../../util/images.dart';
import '../../base/games_loading_view.dart';
import '../../base/games_view.dart';
import '../../base/no_data_screen.dart';

class GamesScreen extends StatefulWidget{
  const GamesScreen({Key key}) : super(key: key);

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    Get.find<GamesController>().getGames(1, true);

    scrollController?.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent
          && Get.find<GamesController>().gamesList != null
          && !Get.find<GamesController>().paginate) {
        int pageSize = (Get.find<GamesController>().pageSize / 10).ceil();
        if (Get.find<GamesController>().offset < pageSize) {
          Get.find<GamesController>().setOffset(Get.find<GamesController>().offset+1);
          Get.find<GamesController>().showFoodBottomLoader();
          Get.find<GamesController>().getGames(Get.find<GamesController>().offset, false);
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
        body: GetBuilder<GamesController>(builder: (adsController){
          return RefreshIndicator(
              onRefresh: () async {
                await adsController.getGames(1, true);
              },
              child: adsController.gamesList != null ? adsController.gamesList.isNotEmpty ? Column(
                children: [
                  Expanded(child: Scrollbar(
                    child: CustomScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: scrollController,
                      slivers: [
                        SliverToBoxAdapter(child: Center(child: SizedBox(
                          width: Dimensions.WEB_MAX_WIDTH,
                          child: Column(children: [
                            GamesView(
                              games: adsController.gamesList,
                              padding: EdgeInsets.symmetric(
                                vertical: ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_SMALL : 0,
                              ),
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
              ) : NoDataScreen(text: 'no_games'.tr, image: Images.no_games) : Helpers.loading()
          );
        })
    );
  }
}