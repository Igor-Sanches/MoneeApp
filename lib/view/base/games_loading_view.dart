import 'package:flutter/material.dart';

import '../../util/dimensions.dart';

class GamesLoadingView extends StatelessWidget {
  final bool inNews;
  final EdgeInsetsGeometry padding;
  final bool isScrollable;
  const GamesLoadingView({Key key,
    @required
    this.inNews,
    this.isScrollable = false,
    this.padding = const EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      key: UniqueKey(),
      shrinkWrap: isScrollable ? false : true,
      physics: isScrollable ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
      padding: padding,
      itemBuilder: (c, index){
        return Text('');
      },
    );
  }
}
