import 'package:flutter/material.dart';
import 'package:asetize/core/util/utils.dart';

class AppStyle {
  /////////// ********  App Theme *****/////////
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      color: Colors.white,
      /* iconTheme: IconThemeData(
        color: Colors.black,
      ),*/
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      onPrimary: AppColors.primaryColor,
      //primaryVariant: AppColors.primaryColor,
      secondary: Colors.red,
    ),

    /* iconTheme: IconThemeData(
      color: AppColors.iconColor[100],
    ),*/
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        color: Colors.black,
        fontSize: 20.0,
      ),
      headlineMedium: TextStyle(
        color: Colors.black,
        fontSize: 18.0,
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
      color: Colors.black,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    colorScheme: const ColorScheme.light(
      primary: Colors.black,
      onPrimary: Colors.black,
      //primaryVariant: Colors.black,
      secondary: Colors.red,
    ),
    iconTheme: const IconThemeData(
      color: Colors.white54,
    ),
    textTheme: const TextTheme(
      // headlineLarge: TextStyle(
      //   color: Colors.white,
      //   fontSize: 20.0,
      // ),
      headlineMedium: TextStyle(
        color: Colors.white70,
        fontSize: 18.0,
      ),
    ),
  );

  /////////// ********  App Theme *****/////////

  TextStyle titleStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor1,
          fontSize: fontSize ?? 14.5,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle subTitleStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textSubHeading,
          fontSize: fontSize ?? 11,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle hStyle1(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 6,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.bold700,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);
  TextStyle hStyle2(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 8,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.bold700,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle hStyle3(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 10,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.bold700,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle hStyle4(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 11,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.bold700,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle hStyle5(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 12,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle hStyle6(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 13,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle hStyle7(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 14,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle hStyle8(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 15,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);
  TextStyle hStyle9(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 16,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);
  TextStyle hStyle10(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 17,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle hStyle11(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 18,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle hStyle12(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 20,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle hStyle13(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 22,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle hStyle14(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 36,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle inputTextStyle1(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 22,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle inputTextStyle2(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 22,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle inputTextStyle3(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 22,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle appBarT1Style(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.appBarTextColor,
          fontSize: fontSize ?? 20,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.bold700,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle appBarT2Style(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.appBarTextColor,
          fontSize: fontSize ?? 24,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.bold700,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle notificationSheetTitleStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 17,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.semiBold600,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle swipeButtonStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.buttonTextColor2,
          fontSize: fontSize ?? 16,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.medium500,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

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

  TextStyle buttonTextStyle2(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textNormalColor,
          fontSize: fontSize ?? 14,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.semiBold600,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle errorStyle(
          {Color? texColor, double? fontSize, fontFamily, fontWeight}) =>
      TextStyle(
        color: texColor ?? Colors.red,
        fontSize: fontSize ?? 10,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.regular400,
      );
  TextStyle error1Style(
          {Color? texColor, double? fontSize, fontFamily, fontWeight}) =>
      TextStyle(
        color: texColor ?? Colors.red,
        fontSize: fontSize ?? 12,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.regular400,
      );

  TextStyle privacyPolicyWithUnderlineStyle1(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          decorationThickness: 1.5,
          decoration: TextDecoration.underline,
          color: texColor ?? AppColors.primaryColor,
          fontWeight: appFonts.light300,
          fontSize: 14,
          fontFamily: appFonts.defaultFont2,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle privacyPolicyWithUnderlineStyle2(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          decorationThickness: 1.5,
          decoration: TextDecoration.underline,
          color: texColor ?? AppColors.primaryColor,
          fontWeight: appFonts.light300,
          fontSize: 14,
          fontFamily: appFonts.defaultFont2,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle counterTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? AppColors.textNormalColor1,
        fontSize: fontSize ?? 13,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.regular400,
      );

  List<BoxShadow> shadow = <BoxShadow>[
    const BoxShadow(color: Color(0xfff8f8f8), blurRadius: 10, spreadRadius: 15),
  ];

  final selectedImageGradient = const LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF8351FE),
      Color(0xFFFF5A5F),
    ],
  );

  buttonNameStyle(
          {Color? texColor, double? fontSize, fontFamily, fontWeight}) =>
      TextStyle(
        color: texColor ?? AppColors.textNormalColor,
        fontSize: fontSize ?? 14,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.regular400,
      );

  TextStyle cardNumberTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? AppColors.textNormalColor,
        fontSize: fontSize ?? 16,
        fontFamily: fontFamily ?? appFonts.defaultFont2,
        fontWeight: fontWeight ?? appFonts.extraBold800,
      );

  TextStyle cardHolderNameTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? AppColors.textNormalColor,
        fontSize: fontSize ?? 16,
        fontFamily: fontFamily ?? appFonts.defaultFont2,
        fontWeight: fontWeight ?? appFonts.medium500,
      );

  TextStyle amountTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? AppColors.black,
        fontSize: fontSize ?? 16,
        fontFamily: fontFamily ?? appFonts.defaultFont2,
        fontWeight: fontWeight ?? appFonts.medium500,
      );

  TextStyle onBoardingTitleStyle(
          {Color? texColor,
          double? fontSize,
          double? height,
          double? letterSpacing,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          height: height ?? 1.2,
          letterSpacing: letterSpacing ?? 1,
          color: texColor ?? AppColors.textNormalColor1,
          fontSize: fontSize ?? 14.5,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle texFieldPlaceHolderStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? AppColors.textFiledPlaceHolderTextColor,
        fontSize: fontSize ?? 14,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.light300,
      );

  TextStyle texFieldPlaceHolderNewStyle(
      {Color? texColor,
        double? fontSize,
        fontFamily,
        fontWeight,
        bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? AppColors.textFiledPlaceHolderTextColor,
        fontSize: fontSize ?? 14,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.regular400,
      );

  TextStyle hintTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? AppColors.grey,
        fontSize: fontSize ?? 16,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.light300,
      );

  TextStyle textFieldTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? AppColors.black,
        fontSize: fontSize ?? 15.5,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.medium500,
      );

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

  TextStyle userJobTitleTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? const Color(0xFF575757),
        fontSize: fontSize ?? 11,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.regular400,
      );

  TextStyle likedCountTextTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? const Color(0xFF575757),
        fontSize: fontSize ?? 16,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.regular400,
      );

  TextStyle belowPostTextTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? const Color(0xFF252525),
        fontSize: fontSize ?? 13,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.light300,
      );

  TextStyle postTextTextStyle(
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

  TextStyle imageSelectTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? AppColors.textSubTextColor,
        fontSize: fontSize ?? 13.5,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.light300,
      );

  TextStyle photoBottomSheetTitleStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? AppColors.textNormalColor1,
        fontSize: fontSize ?? 16.5,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.semiBold600,
      );

  TextStyle containerLeftTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textSubHeading,
          fontSize: fontSize ?? 14.5,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.regular400,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

  TextStyle containerRightTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
          color: texColor ?? AppColors.textSubHeading,
          fontSize: fontSize ?? 15,
          fontFamily: fontFamily ?? appFonts.defaultFont,
          fontWeight: fontWeight ?? appFonts.medium500,
          fontStyle: isItalic ? FontStyle.italic : FontStyle.normal);

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

  TextStyle leaveHistoryTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? const Color(0xFF252525),
        fontSize: fontSize ?? 15,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.regular400,
      );

  TextStyle leaveDetailTitleTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? Colors.grey.shade500,
        fontSize: fontSize ?? 12,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.regular400,
      );

  TextStyle leaveDetailSubTitleTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? Colors.black,
        fontSize: fontSize ?? 14,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.medium500,
      );

  TextStyle noDataTextStyle(
          {Color? texColor,
          double? fontSize,
          fontFamily,
          fontWeight,
          bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? Colors.grey,
        fontSize: fontSize ?? 14,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.regular400,
      );


  TextStyle highlightTextStyle(
      {Color? texColor,
        double? fontSize,
        fontFamily,
        fontWeight,
        bool isItalic = false}) =>
      TextStyle(
        color: texColor ?? AppColors.appBlueColor,
        fontSize: fontSize ?? 15,
        fontFamily: fontFamily ?? appFonts.defaultFont,
        fontWeight: fontWeight ?? appFonts.medium500,
      );
}

AppStyle appStyles = AppStyle();
