import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import '../device_app_bars/bottom_bar_safe_area.dart';
import '../device_app_bars/status_bar.dart';
import '../scroll_behavior.dart';

class ContainerFirst extends StatelessWidget {
  final Color appBackgroundColor;
  final Color? bottomBarSafeAreaColor;
  final bool bottomSafeArea;
  final Color? statusBarColor;
  final bool resizeToAvoidBottomInset;
  final Widget containChild;
  final bool isListScrollingNeed; // Child scroll enabling but single child not
  final bool isFixedDeviceHeight; // if it true than
  final bool isSingleChildScrollViewNeed; // if it true than
  final Widget? appBar; // if it true than
  final double appBarHeight;
  final Widget? bottomMenuView;
  // if it true than   custom height appBarHeight>0, no app bar appBarHeight < 0, Default system appBar height  appBarHeight == 0
  final bool scrollingOnKeyboardOpen; // if it true than
  final BuildContext contextCurrentView; // if it true than
  final bool isOverLayStatusBar; // if it true than
  final bool isOverLayAppBar; // if it true than
  final bool reverse;
  final double bottomSafeAreaHeight;
  final ScrollController? controller;
  ScrollController? appBarScrollController;
  ContainerFirst(
      {Key? key,
        required this.contextCurrentView,
        required this.containChild,
        this.bottomBarSafeAreaColor,
        this.appBackgroundColor =  const Color(0xFFF5F5F5),//const Color(0xFFf9fafb),
        this.statusBarColor,
        this.isFixedDeviceHeight = true,
        this.isOverLayStatusBar = false,
        this.isListScrollingNeed = false,
        this.isOverLayAppBar = false,
        this.bottomSafeAreaHeight = -1,
        this.scrollingOnKeyboardOpen = true,
        this.appBar,
        this.resizeToAvoidBottomInset = true,
        this.appBarHeight = 56,
        this.isSingleChildScrollViewNeed = true,
        this.reverse = true,
        this.bottomSafeArea = false,
        this.controller,
        this.appBarScrollController,
        this.bottomMenuView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double remainingViewFullHeight = calculateHeight(context: context);
    bool isKeyBoardOpen = false;
    // Check if keyboard opened or not
    /*try {
      isKeyBoardOpen =
          KeyboardVisibilityProvider.isKeyboardVisible(contextCurrentView);
      print("Keyboard open status $isKeyBoardOpen");
    } catch (e) {
      print(e);
    }*/
    //Set status bar and bottom sef area color
    Color? statusBarColor = this.appBackgroundColor;
    Color? appBackgroundColor = this.appBackgroundColor;
    Color? bottomBarSafeAreaColor = this.bottomBarSafeAreaColor;

    //Set status bar and bottom sef area color
    //appBackgroundColor = Colors.white;
    statusBarColor ??= appBackgroundColor;
    bottomBarSafeAreaColor ??= appBackgroundColor;

    // Main view return according to Scroll need condition
    Widget returnSubMainView(
        {ScrollPhysics scrollPhysics = const ClampingScrollPhysics(),
          double remainingViewFullHeight = -1}) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              isListScrollingNeed
                  ? ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: remainingViewFullHeight > 0
                      ? remainingViewFullHeight
                      : viewportConstraints.minHeight,
                ),
                child: Container(
                    color: appBackgroundColor,
                    child:
                    containChild) /*IntrinsicHeight(child: Container(color:appBackgroundColor,child: containChild))*/,
              )
                  : SingleChildScrollView(
                physics: scrollPhysics,
                controller: controller,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: remainingViewFullHeight > 0
                        ? remainingViewFullHeight
                        : viewportConstraints.minHeight,
                  ),
                  child: Container(
                      color: appBackgroundColor,
                      child:
                      containChild) /*IntrinsicHeight(child: Container(color:appBackgroundColor,child: containChild))*/,
                ),
              ),
              bottomMenuView ??
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: IntrinsicHeight(
                      child: BottomView(
                          bottomMenuView: bottomMenuView, bottomMenuHeight: -1),
                    ),
                  ),
            ],
          );
        },
      );
    }

    // Main view return according to Scroll need condition
    Widget returnMainView() {
      if (isSingleChildScrollViewNeed && !isFixedDeviceHeight) {
        return returnSubMainView() /*SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: containChild,
        )*/
        ;
      } else if (!isSingleChildScrollViewNeed && !isFixedDeviceHeight) {
        return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
          isKeyBoardOpen = isKeyboardVisible;
          // print("Keyboard open status $isKeyBoardOpen");
          return returnSubMainView(
              scrollPhysics: scrollingOnKeyboardOpen
                  ? (isKeyBoardOpen
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics())
                  : const NeverScrollableScrollPhysics());
        }); /*SingleChildScrollView(
          physics: scrollingOnKeyboardOpen
              ? (isKeyBoardOpen
                  ? ClampingScrollPhysics()
                  : NeverScrollableScrollPhysics())
              : NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 100,
              )
            ],
          ),
        )*/
      } else if (!isSingleChildScrollViewNeed && isFixedDeviceHeight) {
        return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
          isKeyBoardOpen = isKeyboardVisible;
          // print("Keyboard open status $isKeyBoardOpen");
          return returnSubMainView(
              scrollPhysics: scrollingOnKeyboardOpen
                  ? (isKeyBoardOpen
                  ? const ClampingScrollPhysics()
                  : const NeverScrollableScrollPhysics())
                  : const NeverScrollableScrollPhysics(),
              remainingViewFullHeight: remainingViewFullHeight);
        })

        /*ConstrainedBox(
          constraints: BoxConstraints(maxHeight: remainingViewFullHeight),
          child:
          SingleChildScrollView(
            physics: scrollingOnKeyboardOpen
                ? (isKeyBoardOpen
                    ? ClampingScrollPhysics()
                    : NeverScrollableScrollPhysics())
                : NeverScrollableScrollPhysics(),
            child: containChild,
          ),
        )*/
        ;
      } else {
        return returnSubMainView(
            remainingViewFullHeight:
            remainingViewFullHeight) /*ConstrainedBox(
          constraints: BoxConstraints(maxHeight: remainingViewFullHeight),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: containChild,
          ),
        )*/
        ;
      }
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: appBackgroundColor,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        body: SafeArea(
          bottom: bottomSafeArea,
          top: false,
          // maintainBottomViewPadding: true,
          child: isOverLayAppBar
              ? Column(
            children: [
              isOverLayStatusBar
                  ? Container(
                height: 0,
              )
                  : StatusBar(statusBarColor: statusBarColor),
              isOverLayAppBar
                  ? Container()
                  : AppBarView(
                  appBar: appBar,
                  appBarHeight: calculateAppBarHeight()),
              Expanded(
                child: Stack(
                  children: [
                    ScrollConfiguration(
                        behavior: MyBehavior(), child: returnMainView()),
                    !isOverLayAppBar
                        ? Container()
                        : AppBarView(
                        appBar: appBar,
                        appBarHeight: calculateAppBarHeight())
                  ],
                ),
              ),
              BottomBarSafeArea(
                  bottomBarSafeAreaColor: bottomBarSafeAreaColor),
            ],
          )
              : Column(
            children: [
              isOverLayStatusBar
                  ? Container(
                height: 0,
              )
                  : StatusBar(statusBarColor: statusBarColor),


              AnimatedBuilder(
                animation: appBarScrollController ?? ScrollController(),
                builder: (context, child) {
                  return AnimatedContainer(
                    curve: Curves.fastLinearToSlowEaseIn,
                    duration: Duration(milliseconds: 950),
                    height: appBarHeight == -1 ?0:appBarHeight,
                    child: child,
                  );
                },
                child: Wrap(
                  children: [
                    AppBarView(
                        appBar: appBar, appBarHeight: calculateAppBarHeight())
                  ],
                ),
              ),
              Expanded(
                child: ScrollConfiguration(
                    behavior: MyBehavior(), child: returnMainView()),
              ),
              BottomBarSafeArea(
                bottomBarSafeAreaColor: bottomBarSafeAreaColor,customHeight: bottomSafeAreaHeight,),
            ],
          ),
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

    double appBarHeight = isOverLayAppBar ? 0 : calculateAppBarHeight();

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
}

class AppBarView extends StatelessWidget {
  final double appBarHeight;
  final Widget? appBar;
  const AppBarView({Key? key, this.appBarHeight = 0, this.appBar})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double appBarHeight = this.appBarHeight;
    return Container(
      color: Colors.white,
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

class BottomView extends StatelessWidget {
  final double bottomMenuHeight;
  final Widget? bottomMenuView;
  const BottomView({Key? key, this.bottomMenuHeight = 0, this.bottomMenuView})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double bottomMenuHeight = 0;
    // MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Container(
      child: (bottomMenuView == null)
          ? Container(height: bottomMenuHeight)
          : bottomMenuView!,
    );
  }
}
