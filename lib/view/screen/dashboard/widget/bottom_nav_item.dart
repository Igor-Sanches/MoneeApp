import 'package:flutter/material.dart';

class BottomNavItem extends StatelessWidget {
  final String iconData;
  final Function onTap;
  final bool isSelected;
  const BottomNavItem({Key key, @required this.iconData, this.onTap, this.isSelected = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        icon: isSelected ? Image.asset(iconData, color: Theme.of(context).primaryColor, colorBlendMode: BlendMode.srcIn, width: 25,) : Image.asset(iconData, width: 25),
        onPressed: onTap,
      ),
    );
  }
}
