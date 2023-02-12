import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:monetization/data/model/response/game_model.dart';
import 'package:monetization/view/base/custom_snackbar.dart';
import 'package:shimmer/shimmer.dart';

import '../../helper/route_helper.dart';
import '../../util/dimensions.dart';
import '../../util/images.dart';

class GamesView extends StatelessWidget {
  final List<Game> games;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String noDataText;
  final bool noHeard;
  const GamesView({Key key,
    @required
    this.games,
    this.isScrollable = false,
    this.shimmerLength = 20,
    this.padding = const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
    this.noDataText, this.noHeard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isNull = true;
    int length = 0;
    isNull = games == null;
    if(!isNull) {
      length = games.length;
    }

    return ListView.builder(
      itemCount: length,
      key: UniqueKey(),
      shrinkWrap: isScrollable ? false : true,
      physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
      padding: padding,
      itemBuilder: (c, index){
        Game game = games.elementAt(index);
         return InkWell(
           onTap: (){
             if(game.tag == 'tic_tac_toe'){
               Get.toNamed(RouteHelper.getTicTacToeGame(game.banner));
             }else if(game.tag == 'scratch_and_win'){
               Get.toNamed(RouteHelper.getScratchAndWinGame(game.banner));
             }else if(game.tag == 'lucky_table'){
               Get.toNamed(RouteHelper.getLuckyTableGame(game.banner));
             }else if(game.tag == 'playing_card'){
               Get.toNamed(RouteHelper.getPlayingCardGame(game.banner));
             }else if(game.tag == 'spin_to_win'){
               Get.toNamed(RouteHelper.getSpinToWinGame(game.banner));
             }
           },
           child: Padding(
               padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
               child: Card(
                 surfaceTintColor: Colors.white,
                 elevation: 3,
                 shape: RoundedRectangleBorder(
                     borderRadius: BorderRadius.circular(10)
                 ),
                 child: Padding(
                   padding: const EdgeInsets.fromLTRB(13, 10, 13, 10),
                   child: Row(children: [
                     Container(
                       height: 70,
                       width: 70,
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(100),
                           image: DecorationImage(
                               image: NetworkImage(game.imagePath)
                           )
                       ),
                     ),
                     const SizedBox(width: 10,),
                     Expanded(child: Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(game.name, style: const TextStyle(
                             fontSize: 18
                         ),),
                         Text(game.description, style: const TextStyle(
                             fontSize: 12
                         ),),
                         Row(children: [
                           Icon(Icons.visibility, size: 18, color: Theme.of(context).disabledColor,),
                           const SizedBox(width: 5,),
                           Text('${game.view??0}', style: TextStyle(
                               color: Theme.of(context).disabledColor
                           ),),
                           const SizedBox(width: 20,),
                           Icon(Icons.account_balance_outlined, size: 18, color: Theme.of(context).disabledColor,),
                           const SizedBox(width: 5,),
                           Text('${game.victories??0}', style: TextStyle(
                               color: Theme.of(context).disabledColor
                           ),)
                         ],)
                       ],
                     ))
                   ],),
                 ),
               )
           ),
         );
      },
    );

  }
}
