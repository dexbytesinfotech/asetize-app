import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:asetize/core/util/utils.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey.shade900,
    primaryColor: Colors.black,
    textTheme: const TextTheme(
      // headline1: TextStyle(color: Colors.orange),
      // headline2: TextStyle(color: Colors.orange),
      // headline3: TextStyle(color: Colors.orange),
      // headline4: TextStyle(color: Colors.orange),
      // headline5: TextStyle(color: Colors.orange),
      // headline6: TextStyle(color: Colors.orange),
      // subtitle1: TextStyle(color: Colors.orange),
      // subtitle2: TextStyle(color: Colors.orange),
      // bodyText1: TextStyle(color: Colors.brown),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    // colorScheme: ColorScheme.dark(),
    // textTheme: TextTheme(caption: TextStyle(color: Colors.blue)),
    // primaryTextTheme: TextTheme(caption: TextStyle(color: Colors.blue)),
    appBarTheme: const AppBarTheme(color: AppColors.appBgColor2),
    iconTheme: IconThemeData(color: Colors.purple.shade200, opacity: 0.8),
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.black,
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.orange),
      displayMedium: TextStyle(color: Colors.orange),
      displaySmall: TextStyle(color: Colors.orange),
      headlineMedium: TextStyle(color: Colors.orange),
      headlineSmall: TextStyle(color: Colors.orange),
      titleLarge: TextStyle(color: Colors.orange),
      titleMedium: TextStyle(color: Colors.orange),
      titleSmall: TextStyle(color: Colors.orange),
      bodyLarge: TextStyle(color: Colors.brown),
      bodyMedium: TextStyle(color: Colors.black),
      bodySmall: TextStyle(color: Colors.orange),
      labelLarge: TextStyle(color: Colors.orange),
      labelSmall: TextStyle(color: Colors.orange),
    ),
    // colorScheme: ColorScheme.light(),
    // textTheme: TextTheme(caption: TextStyle(color: Colors.teal)),
    // primaryTextTheme: TextTheme(caption: TextStyle(color: Colors.teal)),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.white,
      titleTextStyle: TextStyle(color: Colors.black),
    ),
    iconTheme: const IconThemeData(color: Colors.red, opacity: 0.8),
  );
}
