// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:asetize/core/core.dart';

class LoadingWidget2 {
  static endLoadingWidget(BuildContext context) {
    Navigator.pop(context);
  }

  static startLoadingWidget(
    BuildContext context, {
    bool useRootNavigator = false,
    double loaderSize = 25,
  }) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: useRootNavigator,
        builder: (BuildContext context) {
          return Center(
            child: SizedBox(
              height: loaderSize,
              width: loaderSize,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color?>(AppColors.appBlue),
              ),
            ),
          );
        });
  }

  //It is simple transparent bg loader user for any view not like popup loader
  static loadViewWidget(
          {double loaderSize = 25,
          double strokeWidth = 2.0,
          double squareSize = 50}) =>
      Center(
        child: SizedBox.fromSize(
          size: Size.square(squareSize),
          child: (Platform.isIOS || Platform.isMacOS)
              ? Center(
                  child: SizedBox(
                    height: loaderSize,
                    width: loaderSize,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color?>(AppColors.appBlue),
                      strokeWidth: strokeWidth,
                    ),
                  ),
                )
              : Center(
                  child: SizedBox(
                    height: loaderSize,
                    width: loaderSize,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color?>(AppColors.appBlue),
                      strokeWidth: strokeWidth,
                    ),
                  ),
                ),
        ),
      );

  static loadViewNotificationWidget(
          {double loaderSize = 50, double strokeWidth = 0.5}) =>
      Center(
        child: SizedBox.fromSize(
          size: Size.square(30),
          child: (Platform.isIOS || Platform.isMacOS)
              ? Center(
                  child: SizedBox(
                    height: loaderSize,
                    width: loaderSize,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color?>(AppColors.appBlue),
                      strokeWidth: strokeWidth,
                    ),
                  ),
                )
              : Center(
                  child: SizedBox(
                    height: loaderSize,
                    width: loaderSize,
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color?>(AppColors.appBlue),
                      strokeWidth: strokeWidth,
                    ),
                  ),
                ),
        ),
      );
}
