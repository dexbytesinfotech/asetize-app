import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class StatusBar extends StatelessWidget {
  final double customHeight;
  final Color? statusBarColor;
  const StatusBar({Key? key, this.customHeight = -1, this.statusBarColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    double customHeight = this.customHeight;
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    //Set status bar height
    if (customHeight == -1) {
      customHeight = mediaQueryData.padding.top;
    }
    //Set back ground color
/*    Color? statusBarColor =
        this.statusBarColor ??!isDarkMode?Colors.black:Colors.white;*/
    return Container(
      width: double.infinity,
      height: customHeight,
      color: statusBarColor ?? (!isDarkMode ? Colors.white : Color(0xFF121212)),
    );
  }
}

class OtpStatusBar extends StatelessWidget {
  final double customHeight;
  final Color? statusBarColor;
  const OtpStatusBar({Key? key, this.customHeight = -1, this.statusBarColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    double customHeight = this.customHeight;
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    //Set status bar height
    if (customHeight == -1) {
      customHeight = mediaQueryData.padding.top;
    }
    //Set back ground color
    Color? statusBarColor = this.statusBarColor ?? Colors.white;
    return Container(
      width: double.infinity,
      height: customHeight,
      color: statusBarColor,
    );
  }
}
