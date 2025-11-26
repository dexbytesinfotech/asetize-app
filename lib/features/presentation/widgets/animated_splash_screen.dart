import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';

enum SplashType { simpleSplash, backgroundScreenReturn }
enum SplashTransition { fadeScale, slide, scale, rotation, size, fade, decorated }

class AnimatedSplashScreen extends StatefulWidget {
  final PageTransitionType transitionType;
  final SplashTransition splashTransition;
  final Future Function()? function;
  final Animatable? customTween;
  final Color backgroundColor;
  final Widget? nextScreen;
  final SplashType type;
  final bool centered;
  final bool disableNavigation;
  final dynamic splash;
  final Widget? backgroundView;
  final int duration;
  final Curve curve;
  final Duration? animationDuration;
  final double? splashIconSize;
  final String? nextRoute;

  const AnimatedSplashScreen({
    Key? key,
    this.transitionType = PageTransitionType.fade,
    this.splashTransition = SplashTransition.fadeScale,
    this.function,
    this.customTween,
    this.backgroundColor = Colors.white,
    required this.nextScreen,
    this.type = SplashType.simpleSplash,
    this.centered = true,
    this.disableNavigation = false,
    required this.splash,
    this.backgroundView,
    this.duration = 2500,
    this.curve = Curves.easeInOut,
    this.animationDuration,
    this.splashIconSize,
    this.nextRoute,
  }) : super(key: key);

  @override
  State<AnimatedSplashScreen> createState() => _AnimatedSplashScreenState();
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  static const defaultAnimDuration = Duration(milliseconds: 1000);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.animationDuration ?? defaultAnimDuration,
    );

    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);

    _controller.forward().whenComplete(() => _navigate());
  }

  Future<void> _navigate() async {
    await Future.delayed(Duration(milliseconds: widget.duration));
    final screen = widget.type == SplashType.backgroundScreenReturn
        ? await widget.function?.call()
        : (widget.nextRoute ?? widget.nextScreen);

    if (widget.disableNavigation || screen == null) return;

    if (!mounted) return;

    if (screen is String) {
      context.go(screen);
    } else {
      Navigator.of(context).pushReplacement(PageTransition(
        type: widget.transitionType,
        child: screen,
        alignment: Alignment.center,
        duration: widget.animationDuration ?? defaultAnimDuration,
      ));
    }
  }

  Widget _buildTransition(Widget child) {
    switch (widget.splashTransition) {
      case SplashTransition.fadeScale:
        return FadeTransition(
          opacity: _animation,
          child: ScaleTransition(scale: _animation, child: child),
        );
      case SplashTransition.slide:
        return SlideTransition(
          position: Tween<Offset>(begin: Offset(0, 1), end: Offset.zero)
              .animate(_animation),
          child: child,
        );
      case SplashTransition.scale:
        return ScaleTransition(scale: _animation, child: child);
      case SplashTransition.rotation:
        return RotationTransition(turns: _animation, child: child);
      case SplashTransition.size:
        return SizeTransition(sizeFactor: _animation, child: child);
      case SplashTransition.fade:
        return FadeTransition(opacity: _animation, child: child);
      case SplashTransition.decorated:
        final decorationAnimation = (widget.customTween ??
            DecorationTween(
              begin: BoxDecoration(color: Colors.transparent),
              end: BoxDecoration(color: Colors.black12),
            ))
            .animate(_controller); // <- This ensures it's Animation<Decoration>

        return DecoratedBoxTransition(
          decoration: decorationAnimation as Animation<Decoration>,
          child: child,
        );
      default:
        return FadeTransition(opacity: _animation, child: child);
    }
  }

  Widget _buildSplashWidget() {
    final size = widget.splashIconSize ??
        MediaQuery.of(context).size.shortestSide * 0.25;

    Widget splashContent;

    if (widget.splash is String && widget.splash.contains('[n]')) {
      splashContent = Image.network(
        widget.splash.replaceAll('[n]', ''),
        height: size,
      );
    } else if (widget.splash is String) {
      splashContent = Image.asset(widget.splash, height: size);
    } else if (widget.splash is IconData) {
      splashContent = Icon(widget.splash, size: size);
    } else if (widget.splash is Widget) {
      splashContent = SizedBox(height: size, child: widget.splash);
    } else {
      splashContent = SizedBox(height: size);
    }

    return _buildTransition(widget.centered
        ? Center(child: splashContent)
        : splashContent);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: widget.backgroundView == null
          ? _buildSplashWidget()
          : Stack(
        fit: StackFit.expand,
        children: [
          widget.backgroundView!,
          _buildSplashWidget(),
        ],
      ),
    );
  }
}
