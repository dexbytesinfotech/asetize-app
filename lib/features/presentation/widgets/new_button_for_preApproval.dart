import 'package:flutter/material.dart';

class CommonElevatedIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon icon;
  final String label;
  final TextStyle textStyle;
  final Color backgroundColor;
  final Color borderColor;
  final Color foregroundColor;

  const CommonElevatedIconButton({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.label,
    required this.textStyle,
    required this.backgroundColor,
    required this.borderColor,
    required this.foregroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon,
      label: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: textStyle,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: borderColor,
            width: 0.5,
          ),
        ),
      ),
    );
  }
}
