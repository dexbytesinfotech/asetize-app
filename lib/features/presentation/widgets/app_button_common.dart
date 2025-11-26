import 'package:asetize/imports.dart';

import 'common_button.dart';

class AppButton extends StatefulWidget {
  final backCallback, buttonName;
  final Color buttonBorderColor;
  final TextStyle? textStyle;
  final Color? buttonColor;
  final bool isShowIcon;
  final String? icon;
  final Size? iconSize;
  final IconData? flutterIcon;
  final double? buttonHeight;
  final double? borderRadius;
  final double? buttonWidth;
  final Color? iconColor; // ✅ New property for icon color
  final Color? loaderColor;
  final bool isDisable;
  final bool checkForTablet;

  final bool isLoader;
  const AppButton(
      {Key? key,
        this.backCallback,
        this.buttonName,
        this.buttonColor,
        this.buttonHeight,
        this.loaderColor,
        this.buttonWidth,
        this.flutterIcon, // ✅ add in constructor
        this.checkForTablet = true,
        this.isShowIcon = false,
        this.iconColor = Colors.white,// ✅ Default white

        this.icon,
        this.textStyle,
        this.buttonBorderColor = Colors.transparent,
        this.iconSize,
        this.borderRadius,
        this.isLoader = false,
        this.isDisable = false})
      : super(key: key);

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  @override
  Widget build(BuildContext context) {
    return CommonButton(
      isDisable: widget.isDisable,
      buttonHeight: widget.buttonHeight ?? 50,
      buttonWidth: widget.buttonWidth,
      buttonName: widget.buttonName,
      buttonColor: widget.buttonColor ?? AppColors.textBlueColor,
      buttonBorderRadius: widget.borderRadius ??  5,
      textStyle: widget.textStyle ?? appStyles.buttonTextStyle1(),
      backCallback: widget.backCallback,
      isBottomMarginRequired: false,
      isShowIcon: widget.isShowIcon,
      iconColor: widget.iconColor,
      flutterIcon: widget.flutterIcon ,
      iconSize: widget.iconSize,
      buttonBorderColor: widget.buttonBorderColor ,
      icon: widget.icon,
      loaderColor:widget. loaderColor,
      checkForTablet: widget.checkForTablet,
      isLoader: widget.isLoader,
    );
  }
}
