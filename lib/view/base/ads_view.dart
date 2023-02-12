import 'package:flutter/material.dart';
import 'package:monetization/data/model/response/ads_model.dart';

import '../../util/dimensions.dart';

class AdsView extends StatelessWidget {
  final List<Ads> ads;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String noDataText;
  final bool noHeard;
  final Function(Ads ad) onTap;
  const AdsView({Key key,
    @required
    this.ads,
    this.onTap,
    this.isScrollable = false,
    this.shimmerLength = 20,
    this.padding = const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
    this.noDataText, this.noHeard = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isNull = true;
    int length = 0;
    isNull = ads == null;
    if(!isNull) {
      length = ads.length;
    }

    return ListView.builder(
      itemCount: length,
      key: UniqueKey(),
      shrinkWrap: isScrollable ? false : true,
      physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
      padding: padding,
      itemBuilder: (c, index){
        Ads ad = ads.elementAt(index);
         return InkWell(
           onTap: (){
             onTap(ad);
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
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         decoration: BoxDecoration(
                           image: DecorationImage(
                             image: NetworkImage(ad.imagePath),
                             fit: BoxFit.fill
                           ),
                         ),
                         height: 150,
                         width: double.maxFinite,
                         child: const Center(
                           child: Icon(Icons.play_arrow, size: 100, color: Colors.white,),
                         ),
                       ),
                       const SizedBox(height: 10,),
                       Text(ad.name, style: const TextStyle(
                           fontSize: 16
                       ),),
                       const SizedBox(height: 10,),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Icon(Icons.visibility, size: 18, color: Theme.of(context).disabledColor,),
                           const SizedBox(width: 5,),
                           Text('${ad.viewHere}/${ad.viewsDay}', style: TextStyle(
                               color: Theme.of(context).disabledColor
                           ),),
                           const SizedBox(width: 20,),

                           Icon(Icons.visibility, size: 18, color: Theme.of(context).disabledColor,),
                           const SizedBox(width: 5,),
                           Text('${ad.totalViews??0}', style: TextStyle(
                               color: Theme.of(context).disabledColor
                           ),),

                         ],
                       )
                     ],
                   ),
                 ),
               )
           ),
         );
      },
    );

  }
}
