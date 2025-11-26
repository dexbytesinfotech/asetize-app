import 'package:flutter/material.dart';

class GradientLinearView extends StatelessWidget {
  final double strokeWidth;
  final Gradient gradient;
  final double progress;

  const GradientLinearView({
    Key? key,
    this.strokeWidth = 4.0,
    required this.gradient,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, strokeWidth),
      painter: _GradientLinearProgressPainter(
        strokeWidth: strokeWidth,
        gradient: gradient,
        progress: progress,
      ),
    );
  }
}

class _GradientLinearProgressPainter extends CustomPainter {
  final double strokeWidth;
  final Gradient gradient;
  final double progress;

  _GradientLinearProgressPainter({
    required this.strokeWidth,
    required this.gradient,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    size = Size(size.width + 100, size.height);
    final rect = Offset.zero & Size(size.width * progress, size.height);
    final paint = Paint()
      ..shader = gradient.createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class GradientLinearProgressIndicator extends StatefulWidget {
  final double strokeWidth;
  final int speed;
  final List<Color> colors;

  const GradientLinearProgressIndicator({
    Key? key,
    this.strokeWidth = 4.0,
    this.speed = 1500,
    this.colors = const [Colors.blue, Colors.green, Colors.yellow],
  }) : super(key: key);

  @override
  State createState() => _GradientLinearProgressIndicatorState();
}

class _GradientLinearProgressIndicatorState
    extends State<GradientLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<Color> _colors;

  @override
  void initState() {
    super.initState();
    _colors = widget.colors;

    _controller = AnimationController(
      duration: Duration(milliseconds: widget.speed),
      vsync: this,
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    // Set up a listener to swap colors at the halfway point of the animation
    _animation.addListener(() {
      if (_animation.value > 0.5 && _colors != _colors.reversed.toList()) {
        setState(() {
          _colors = _colors.reversed.toList();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        // Update the gradient with the (potentially) swapped colors
        final gradient = LinearGradient(
          colors: _colors,
        );
        return GradientLinearView(
          strokeWidth: widget.strokeWidth,
          gradient: gradient,
          progress: _animation.value,
        );
      },
    );
  }
}
