import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

//Fade Transaction
class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;

  SlideRightRoute({required this.widget})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(-1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final fadeTween = CurveTween(curve: Curves.easeIn);

      return SlideTransition(
        position: animation.drive(tween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}

class BottomUpTransition extends PageRouteBuilder {
  final Widget widget;

  BottomUpTransition({required this.widget})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => widget,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 0.25);
      const end = Offset.zero;
      const curve = Curves.fastOutSlowIn;

      final slideTween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final fadeTween = CurveTween(curve: Curves.easeIn);

      return SlideTransition(
        position: animation.drive(slideTween),
        child: FadeTransition(
          opacity: animation.drive(fadeTween),
          child: child,
        ),
      );
    },
  );
}

class SlideLeftRoute extends PageRouteBuilder {
  final Widget widget;

  SlideLeftRoute({required this.widget})
      : super(
    pageBuilder: (_, __, ___) => widget,
    transitionsBuilder: (_, animation, __, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: Curves.easeInOut));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

class FadeRoute extends PageRouteBuilder {
  final Widget widget;

  FadeRoute({required this.widget})
      : super(
    pageBuilder: (_, __, ___) => widget,
    transitionsBuilder: (_, animation, __, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

class SlideDownFadeRoute extends PageRouteBuilder {
  final Widget widget;

  SlideDownFadeRoute({required this.widget})
      : super(
    pageBuilder: (_, __, ___) => widget,
    transitionsBuilder: (_, animation, __, child) {
      final slide = Tween(begin: Offset(0, -0.5), end: Offset.zero)
          .chain(CurveTween(curve: Curves.easeOutCubic));
      final fade = CurveTween(curve: Curves.easeIn);

      return SlideTransition(
        position: animation.drive(slide),
        child: FadeTransition(
          opacity: animation.drive(fade),
          child: child,
        ),
      );
    },
  );
}

