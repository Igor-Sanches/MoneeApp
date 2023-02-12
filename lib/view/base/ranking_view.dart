import 'package:flutter/material.dart';

import '../../data/model/response/user_model.dart';
import '../../util/dimensions.dart';

class RankingView extends StatelessWidget {
  final List<User> users;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  final int shimmerLength;
  final String noDataText;
  final bool noHeard;
  final Function(User user) onTap;
  const RankingView({Key key,
    @required
    this.users,
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
    isNull = users == null;
    if(!isNull) {
      length = users.length;
    }

    return ListView.builder(
      itemCount: length,
      key: UniqueKey(),
      shrinkWrap: isScrollable ? false : true,
      physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
      padding: padding,
      itemBuilder: (c, index){
        User user = users.elementAt(index);
         return InkWell(
           onTap: (){
             onTap(user);
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
