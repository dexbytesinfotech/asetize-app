import 'package:flutter/material.dart';

class CommonCardView extends StatelessWidget {
  final Color cardColor;
  final double elevation;
  final double borderRadius;
  final EdgeInsetsGeometry? margin;
  final Widget child;
  final BorderSide? side;


  const CommonCardView({super.key, this.cardColor = Colors.white,this.elevation = 0.5,this.borderRadius = 12,this.margin,required this.child,this.side});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: cardColor, // Set card color based on status
      elevation: elevation,
      shadowColor: cardColor,
      surfaceTintColor: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius),side: side ?? const BorderSide(width: 0,color: Colors.transparent)),
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      child: child
    );
  }
}
