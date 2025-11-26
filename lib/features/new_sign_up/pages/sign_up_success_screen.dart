import 'package:flutter/material.dart';
import 'package:asetize/core/core.dart';
import '../../presentation/widgets/basic_view_container/container_first.dart';
import 'new_login_with_email_screen.dart';

class SignupSuccessScreen extends StatefulWidget {
  const SignupSuccessScreen({super.key});

  @override
  _SignupSuccessScreenState createState() => _SignupSuccessScreenState();
}

class _SignupSuccessScreenState extends State<SignupSuccessScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true); // Repeats the animation back and forth

    // Define the scale animation
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: true,
        isFixedDeviceHeight: true,
        isListScrollingNeed: true,
        isOverLayStatusBar: false,
        bottomSafeArea: true,
        appBarHeight: 56,
        containChild: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _animation.value,
                    child: child,
                  );
                },
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 100,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                AppString.thankYouForSigningUp,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
              AppString.welcomeMessage,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      SlideLeftRoute(
                          widget:  const NewLoginWithEmail()));
                },
                child: const Text(
                 AppString.goToLoginScreen,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.buttonBgColor3,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  }
}
