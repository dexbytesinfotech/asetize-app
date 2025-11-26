import 'package:asetize/imports.dart';

class CommonButton extends StatefulWidget {
  final backCallback, buttonName, isDisable, buttonColor;
  final bool isBottomMarginRequired;
  final Color buttonBorderColor;
  final double buttonBorderWidth;
  final double buttonBorderRadius;
  final double buttonHeight;
  final double? buttonWidth;
  final IconData? flutterIcon; // ✅ New: Flutter built-in icon
  final bool isShowIcon;
  final Color? iconColor;
  final Color? loaderColor;
  // ✅ New property for icon color

  final bool checkForTablet;
  final String? icon;
  final Size? iconSize;
  final TextStyle? textStyle;
  final bool isLoader; // New variable added

  const CommonButton(
      {Key? key,
        this.backCallback,
        this.buttonName,
        this.loaderColor,

        this.buttonBorderColor = Colors.transparent,
        this.buttonBorderWidth = 0,
        this.buttonHeight = -1,
        this.buttonWidth,
        this.iconColor = Colors.white,// ✅ Default white

  this.flutterIcon, // ✅ add in constructor
        this.textStyle,
        this.isDisable = false,
        this.isBottomMarginRequired = true,
        this.buttonColor,
        this.buttonBorderRadius = 40,
        this.isShowIcon = false,
        this.icon,
        this.checkForTablet = true,
        this.iconSize,
        this.isLoader = false}) // Initialize new variable
      : super(key: key);

  @override
  _CommonButtonState createState() => _CommonButtonState();
}

class _CommonButtonState extends State<CommonButton> {

  @override
  Widget build(BuildContext context) {

    bool isTablet = widget.checkForTablet?getIsTablet(context):false;
    Size size = MediaQuery.of(context).size;
    // print("This is the tablet $isTablet");


    bool bottomViewPadding = isSafeAreaRequired(context: context);

    Color buttonColor = widget.buttonColor ?? AppColors.appBlueColor;
    return Material(
        color: widget.isDisable ? buttonColor.withOpacity(0.4) : buttonColor,
        borderRadius: BorderRadius.circular(widget.buttonBorderRadius),
        child: InkWell(
          borderRadius: BorderRadius.circular(widget.buttonBorderRadius),
          onTap: () {
            if (!widget.isLoader) { // Prevent tap when loading
              widget.backCallback?.call();
            }
          },
          child: Container(
            margin: EdgeInsets.only(
                bottom: widget.isBottomMarginRequired
                    ? (bottomViewPadding ? 70 : 60)
                    : 0),
            width: widget.buttonWidth ?? (isTablet ?  size.width / 2.6 : double.infinity),


            height: widget.buttonHeight >= 0
                ? widget.buttonHeight
                : AppDimens().buttonHeight(),
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(widget.buttonBorderRadius),
                border: Border.all(
                  color: widget.buttonBorderColor,
                  width: widget.buttonBorderWidth,
                )),
            child: Align(
                alignment: Alignment.center,
                child: widget.isLoader // Show loader if isLoader is true
                    ?  SizedBox(
                  height: 12, // Adjust height as needed
                  width: 12,  // Adjust width as needed
                  child: CircularProgressIndicator(
                    strokeWidth: 2, // Adjust the thickness of the loader
                    valueColor: AlwaysStoppedAnimation<Color>(

                        widget.loaderColor?? Colors.white
                    ),
                  ),
                )


                    : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.isShowIcon)
                        widget.flutterIcon != null
                            ? Icon(
                          widget.flutterIcon,
                          size: widget.iconSize?.width ?? 25,
                          color: widget.iconColor ?? Colors.white, // ✅ Color applied
                        )
                            : WorkplaceIcons.iconImage(
                          imageUrl: widget.icon ?? WorkplaceIcons.backArrow,
                          imageColor: widget.iconColor ?? Colors.white, // ✅ Color applied
                          iconSize: widget.iconSize ?? const Size(25, 25),
                        ),

                      SizedBox(width: widget.isShowIcon ? 6 : 0),
          Text(
            widget.buttonName ?? '',
            style: widget.textStyle ??
                const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
            textAlign: TextAlign.center,
          ),
            ]
            ),
          ),
        )) );
  }

  bool getIsTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
          MediaQuery.of(context).size.width >= 650;
}

bool isSafeAreaRequired({required BuildContext context}) {
  double bottomViewPadding = MediaQuery.of(context).viewPadding.bottom;
  return bottomViewPadding > 0 ? true : false;
}


