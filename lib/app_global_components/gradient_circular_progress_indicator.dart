import 'package:flutter/material.dart';
import 'dart:math' as math;

class GradientCircularView extends StatelessWidget {
  final double strokeWidth;
  final Gradient gradient;

  const GradientCircularView({
    Key? key,
    this.strokeWidth = 4.0,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(strokeWidth * 2),
      painter: _GradientCircularProgressPainter(
        strokeWidth: strokeWidth,
        gradient: gradient,
      ),
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  final double strokeWidth;
  final Gradient gradient;

  _GradientCircularProgressPainter({
    required this.strokeWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    const sweepAngle = 2 * math.pi;

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class GradientCircularProgressIndicator extends StatefulWidget {
  final double strokeWidth;
  final int? speed;
  final Gradient? gradient;
  const GradientCircularProgressIndicator({
    Key? key,
    this.strokeWidth = 4.0,
    this.speed = 500,
    this.gradient = const LinearGradient(
      colors: [Colors.blue, Colors.green, Colors.yellow],
    ),
  }) : super(key: key);

  @override
  State createState() => _GradientCircularProgressIndicatorState();
}

class _GradientCircularProgressIndicatorState
    extends State<GradientCircularProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.speed!),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: GradientCircularView(
        strokeWidth: widget.strokeWidth,
        gradient: widget.gradient!,
      ),
    );
  }
}
