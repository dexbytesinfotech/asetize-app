import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

enum ScreenSlideTransitionType { rToL, lToR }

//Fade Transaction
class SlideRightRoute extends CupertinoPageRoute {
  final Widget? widget;
  SlideRightRoute({this.widget})
      : super(builder: (BuildContext context) => widget!);
  // OPTIONAL IF YOU WISH TO HAVE SOME EXTRA ANIMATION WHILE ROUTING
  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1, end: 1).animate(animation),
      child: widget,
      //alignment: Alignment.center,
    );
  }
}

class BottomUpTransition extends PageRouteBuilder {
  final Widget? widget;
  BottomUpTransition({this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget!;
        });
  static final Tween<Offset> easeInOut = Tween<Offset>(
    begin: const Offset(0, 0),
    end: Offset.zero,
  );
  static final Animatable<double> _fastOutSlowInTween =
      CurveTween(curve: Curves.fastOutSlowIn);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return SlideTransition(
      position: animation.drive(easeInOut.chain(_fastOutSlowInTween)),
      // TODO(ianh): tell the transform to be un-transformed for hit testing
      child: FadeTransition(
        opacity: animation.drive(_easeInTween),
        child: widget,
      ),
    );
  }
}

class TransitionsBuilder {
  static Widget Function(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) goRouteTransitionsBuilder(
          {ScreenSlideTransitionType? screenSlideTransitionType =
              ScreenSlideTransitionType.rToL}) =>
      (context, animation, secondaryAnimation, child) {
        Cubic curve = Curves.easeInOut;
        switch (screenSlideTransitionType) {
          case ScreenSlideTransitionType.rToL:
            curve = curve;
            break;
          case ScreenSlideTransitionType.lToR:
            curve = curve;
            break;
          default:
            curve = curve;
            break;
        }

        return SlideTransition(
          position: animation.drive(
            Tween(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: child,
        );
      };

  static goRoutePageBuilder(
          {required Widget child,
          ScreenSlideTransitionType? screenSlideTransitionType =
              ScreenSlideTransitionType.rToL}) =>
      (BuildContext context, GoRouterState state) {
        // return SlideRightRoute(widget: const AboutApp());
        return CustomTransitionPage(
          key: state.pageKey,
          child: child,
          transitionsBuilder: goRouteTransitionsBuilder(
              screenSlideTransitionType: screenSlideTransitionType),
        );
      };
}
