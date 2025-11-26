import '../../../imports.dart';

class AppTextStyle{

  TextStyle appBarTitleStyle({ Color? color, double? fontSize, fontFamily, fontWeight}) {
    return TextStyle(
      letterSpacing: 1.5,
      color: color ?? Colors.black,
      fontSize: fontSize ?? 18,
      fontFamily: fontFamily ?? "Roboto",
      fontWeight: fontWeight ?? FontWeight.w500,
    );
  }
  TextStyle tabTextStyle(
      {Color? texColor,
        double? fontSize,
        fontFamily,
        fontWeight,
        bool isItalic = false}) =>
      TextStyle(
        fontSize: fontSize ?? 14,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? FontWeight.w500,
      );

  TextStyle noDataTextStyle(
      {Color? color,
        double? fontSize,
        fontFamily,
        fontWeight,
        bool isItalic = false}) =>
      TextStyle(
        color: color ?? Colors.grey,
        fontSize: fontSize ?? 14,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.regular400,
      );

  TextStyle errorTextStyle(
      {Color? color,
        double? fontSize,
        fontFamily,
        fontWeight,
        bool isItalic = false}) =>
      TextStyle(
        color: color ?? Colors.red,
        fontSize: fontSize ?? 14,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? FontWeight.normal,
      );

// appTextStyle.appNormalTextStyle(),
  TextStyle appNormalTextStyle({ Color? color, double? fontSize, fontFamily, fontWeight}) {
    return TextStyle(
      color: color ?? Colors.black,
      fontSize: fontSize ?? 16,
      fontFamily: fontFamily ?? "Roboto",
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }
  // appTextStyle.appNormalSmallTextStyle(),
  TextStyle appNormalSmallTextStyle({ Color? color, double? fontSize, fontFamily, fontWeight}) {
    return TextStyle(
      color: color ?? Colors.black,
      fontSize: fontSize ?? 14,
      fontFamily: fontFamily ?? "Roboto",
      fontWeight: fontWeight ?? FontWeight.normal,
    );
  }
  // appTextStyle.appLargeTitleStyle(),
  TextStyle appLargeTitleStyle({ Color? color, double? fontSize, fontFamily, fontWeight}) {
    return TextStyle(
      color: color ?? Colors.black,
      fontSize: fontSize ?? 18,
      fontFamily: fontFamily ?? "Roboto",
      fontWeight: fontWeight ?? FontWeight.w500,
    );
  }
  // appTextStyle.appTitleStyle(),
  TextStyle appTitleStyle({ Color? color, double? fontSize, fontFamily, fontWeight}) {
    return TextStyle(
      color: color ?? Colors.black,
      fontSize: fontSize ?? 16,
      fontFamily: fontFamily ?? "Roboto",
      fontWeight: fontWeight ?? FontWeight.w500,
    );
  }

  TextStyle appTitleStyle2({ Color? color, double? fontSize, fontFamily, fontWeight}) {
    return TextStyle(
      color: color ?? Colors.black,
      fontSize: fontSize ?? 16,
      fontFamily: fontFamily ?? "Roboto",
      fontWeight: fontWeight ?? FontWeight.w600,
    );
  }

  TextStyle appTenancyTitleStyle({ Color? color, double? fontSize, fontFamily, fontWeight}) {
    return TextStyle(
      color: color ?? Colors.black,
      fontSize: fontSize ?? 17,
      fontFamily: fontFamily ?? "Roboto",
      fontWeight: fontWeight ?? FontWeight.w500,
    );
  }
//appTextStyle.appSubTitleStyle(),
  TextStyle appSubTitleStyle({ Color? color, double? fontSize, fontFamily, fontWeight}) {
    return TextStyle(
      color: color ?? Colors.black,
      fontSize: fontSize ?? 14,
      fontFamily: fontFamily ?? "Roboto",
      fontWeight: fontWeight ?? FontWeight.w300,
    );
  }

  TextStyle appSubTitleStyle2({ Color? color, double? fontSize, fontFamily, fontWeight}) {
    return TextStyle(
      color: color ?? Colors.grey.shade600,
      fontSize: fontSize ?? 14,
      fontFamily: fontFamily ?? "Roboto",
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }

  TextStyle appSubTitleStyle3({ Color? color, double? fontSize, fontFamily, fontWeight}) {
    return TextStyle(
      color: color ?? Colors.grey.shade800,
      fontSize: fontSize ?? 14,
      fontFamily: fontFamily ?? "Roboto",
      fontWeight: fontWeight ?? FontWeight.w400,
    );
  }


  TextStyle floatingActionButtonStyle({ Color? color, double? fontSize, fontFamily, fontWeight}) {
    return TextStyle(
      color: color ?? Colors.white,
      fontSize: fontSize ?? 16,
      fontFamily: fontFamily ?? "Roboto",
      fontWeight: fontWeight ?? FontWeight.w300,
    );
  }



  TextStyle appSubTitleValueStyle({ Color? color, double? fontSize, fontFamily, fontWeight}) {
    return TextStyle(
      color: color ?? Colors.black,
      fontSize: fontSize ?? 14,
      fontFamily: fontFamily ?? "Roboto",
      fontWeight: fontWeight ?? FontWeight.w500,
    );
  }
  TextStyle buttonTextStyle1(
      {Color? texColor,
        double? fontSize,
        fontFamily,
        fontWeight,
        bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 16,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.bold700,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);
  TextStyle userNameTextStyle(
      {Color? texColor,
        double? fontSize,
        fontFamily,
        fontWeight,
        bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? const Color(0xFF252525),
        fontSize: fontSize ?? 14.5,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.regular400,
      );

}

AppTextStyle appTextStyle = AppTextStyle();