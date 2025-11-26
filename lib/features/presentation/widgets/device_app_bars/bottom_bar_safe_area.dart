import 'package:flutter/material.dart';

class BottomBarSafeArea extends StatelessWidget {
  final double customHeight;
  final Color? bottomBarSafeAreaColor;
  const BottomBarSafeArea(
      {Key? key, this.customHeight = -1, this.bottomBarSafeAreaColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double customHeight = this.customHeight;
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    //Set status bar height
    if (customHeight == -1) {
      customHeight = mediaQueryData.padding.bottom;
    }
    //Set back ground color
    Color? bottomBarSafeAreaColor =
        this.bottomBarSafeAreaColor ?? Colors.blueGrey;
    return Container(
      width: double.infinity,
      height: customHeight,
      color: bottomBarSafeAreaColor,
    );
  }
}
