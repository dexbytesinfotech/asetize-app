import 'package:flutter/material.dart';
import 'package:asetize/features/presentation/widgets/device_app_bars/bottom_bar_safe_area.dart';
import 'package:asetize/features/presentation/widgets/device_app_bars/status_bar.dart';
import 'package:asetize/features/presentation/widgets/scroll_behavior.dart';

class ContainerDashboard extends StatelessWidget {
  final Color appBackgroundColor;
  final Color? bottomBarSafeAreaColor;
  final Color? statusBarColor;
  final Widget containChild; // if it true than
  final Widget? appBar; // if it true than
  final Widget bottomMenuView; // if it true than
  final double
      appBarHeight; // if it true than   custom height appBarHeight>0, no app bar appBarHeight < 0, Default system appBar height  appBarHeight == 0
  final double
      bottomMenuHeight; // if it true than   custom height appBarHeight>0, no app bar appBarHeight < 0, Default system appBar height  appBarHeight == 0
  final BuildContext contextCurrentView; // if it true than
  final bool isOverLayStatusBar; // if it true than

  const ContainerDashboard(
      {Key? key,
      required this.contextCurrentView,
      required this.containChild,
      required this.bottomMenuView,
      this.bottomBarSafeAreaColor,
      this.appBackgroundColor = Colors.white,
      this.statusBarColor,
      this.appBar,
      this.appBarHeight = 0,
      this.bottomMenuHeight = 0,
      this.isOverLayStatusBar = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // double remainingViewFullHeight = calculateHeight(context: context);
    double bottomMenuHeight = calculateBottomMenuHeight();
    // bool isKeyBoardOpen = false;

    //Set status bar and bottom sef area color
    Color? statusBarColor = this.statusBarColor;
    Color? bottomBarSafeAreaColor = this.bottomBarSafeAreaColor;

    //Set status bar and bottom sef area color
    statusBarColor ??= appBackgroundColor;
    bottomBarSafeAreaColor ??= appBackgroundColor;

    // Main view return according to Scroll need condition
    Widget returnSubMainView(
        {ScrollPhysics scrollPhysics = const ClampingScrollPhysics()}) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return IntrinsicHeight(child: containChild);
        },
      );
    }

    // Main view return according to Scroll need condition
    Widget returnMainView() {
      return returnSubMainView();
    }

    return Scaffold(
      backgroundColor: appBackgroundColor,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: true,
        top: false,
        // maintainBottomViewPadding: true,
        child: Column(
          children: [
            isOverLayStatusBar
                ? Container(
                    height: 0,
                  )
                : StatusBar(statusBarColor: statusBarColor),
            AppBarViewDashboard(
                appBar: appBar, appBarHeight: calculateAppBarHeight()),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ScrollConfiguration(
                      behavior: MyBehavior(), child: returnMainView()),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: bottomMenuHeight,
                      child: BottomMenuViewDashboard(
                          bottomMenuView: bottomMenuView,
                          bottomMenuHeight: bottomMenuHeight),
                    ),
                  ),
                ],
              ),
            ),
            BottomBarSafeArea(bottomBarSafeAreaColor: bottomBarSafeAreaColor),
          ],
        ),
      ),
    );
  }

  double calculateHeight({required BuildContext context}) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double fullScreenSize = mediaQueryData.size.height;
    double remainingViewFullHeight = fullScreenSize;

    double statusBarHeight =
        isOverLayStatusBar ? 0 : mediaQueryData.padding.top;
    double bottomBarSafeAreaHeight = mediaQueryData.padding.bottom;

    double appBarHeight = calculateAppBarHeight();

    remainingViewFullHeight = fullScreenSize -
        (statusBarHeight + bottomBarSafeAreaHeight + appBarHeight);

    return remainingViewFullHeight;
  }

  double calculateAppBarHeight() {
    double appBarHeight = 0;
    //User define height
    if (this.appBarHeight > 0) {
      appBarHeight = this.appBarHeight;
    }
    // No appBar height
    else if (this.appBarHeight < 0) {
      appBarHeight = 0;
    }
    //Default system appBar height
    else if (this.appBarHeight == 0) {
      appBarHeight = kToolbarHeight;
    }
    return appBarHeight;
  }

  double calculateBottomMenuHeight() {
    double bottomMenuHeight = 0;
    //User define height
    if (this.bottomMenuHeight > 0) {
      bottomMenuHeight = this.bottomMenuHeight;
    }
    // No appBar height
    else if (this.bottomMenuHeight < 0) {
      bottomMenuHeight = 0;
    }
    //Default system appBar height
    else if (this.bottomMenuHeight == 0) {
      bottomMenuHeight = kBottomNavigationBarHeight;
    }
    return bottomMenuHeight;
  }
}

class AppBarViewDashboard extends StatelessWidget {
  final double appBarHeight;
  final Widget? appBar;
  const AppBarViewDashboard({Key? key, this.appBarHeight = 0, this.appBar})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double appBarHeight = this.appBarHeight;
    // MediaQueryData mediaQueryData = MediaQuery.of(context);
    return SizedBox(
      height: appBarHeight,
      child: PreferredSize(
          preferredSize: Size(double.infinity, appBarHeight),
          child: (appBar == null || appBarHeight == 0)
              ? Container(
                  height: appBarHeight,
                  color: Colors.blue,
                  child: const Text(
                    "custom height appBarHeight>0, no app bar appBarHeight < 0, Default system appBar height  appBarHeight == 0",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                )
              : appBar!),
    );
  }
}

class BottomMenuViewDashboard extends StatelessWidget {
  final double bottomMenuHeight;
  final Widget? bottomMenuView;
  const BottomMenuViewDashboard(
      {Key? key, this.bottomMenuHeight = 0, this.bottomMenuView})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double bottomMenuHeight = this.bottomMenuHeight;
    // MediaQueryData mediaQueryData = MediaQuery.of(context);
    return SizedBox(
      height: bottomMenuHeight,
      child: PreferredSize(
          preferredSize: Size(double.infinity, bottomMenuHeight),
          child: (bottomMenuView == null || bottomMenuHeight == 0)
              ? Container(
                  height: bottomMenuHeight,
                  color: Colors.blue,
                  child: const Text(
                    "custom height appBarHeight>0, no app bar appBarHeight < 0, Default system appBar height  appBarHeight == 0",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                )
              : bottomMenuView!),
    );
  }
}
