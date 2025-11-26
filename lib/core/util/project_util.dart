import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_new_badger/flutter_new_badger.dart';
import 'package:intl/intl.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:asetize/core/util/utils.dart';
import 'package:asetize/core/util/api_constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vibration/vibration.dart';
// import 'package:asetize/features/presentation/widgets/alerts/error_alert.dart'; //Add this dependancy  timeago: ^2.0.22

final List<String> imageExtensions = <String>[
  "JPG",
  "PNG",
  "TIFF",
  "JPEG",
  "GIF",
  "WEBP",
  "PSD",
  "RAW",
  "BMP",
  "HEIF",
  "INDD",
  "JPEG 2000"
];

class ProjectUtil {
  static var screenSize;
  static DateTime? oldDate;
  static late DateTime startTime;

  screenSizeValue(context) {
    screenSize = MediaQuery.of(context).size;
    return screenSize;
  }

  String initials(String givenName, String familyName) {
    return ((givenName.isNotEmpty == true ? givenName[0] : "") +
        ((familyName.isNotEmpty == true ? familyName[0] : "")).toUpperCase());
  }

  String getCompareDateStr(String timestamp, String format, int index) {
    String formattedTime = "";
    try {
      if (index <= 0) {
        oldDate = null;
      }
      int time = int.parse(timestamp);
      DateTime date = DateTime.fromMillisecondsSinceEpoch(time);
      if (oldDate == null) {
        oldDate = date;
        formattedTime = DateFormat(format).format(oldDate!);
      } else {
        String formattedTimeOld = "";
        String formattedTimeCurrent = "";
        formattedTimeOld = DateFormat(format).format(oldDate!);
        formattedTimeCurrent = DateFormat(format).format(date);
        if (formattedTimeOld == formattedTimeCurrent) {
          formattedTime = "";
        } else {
          oldDate = date;
          formattedTime = DateFormat(format).format(oldDate!);
        }
      }
    } catch (e) {
      formattedTime = "";
    }
    return formattedTime;
  }

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width < 1100 &&
          MediaQuery.of(context).size.width >= 650;




  /*================== Convert time from timestamp ===================*/
  String getTime(int timestamp, String format) {
    String formattedTime = "";
    try {
      formattedTime = DateFormat(format)
          .format(DateTime.fromMicrosecondsSinceEpoch(timestamp));
    } catch (e) {
      formattedTime = "";
      printP('error in formatting $e');
    }
    return formattedTime;
  }



  String getCountDownTimer(int timestamp, String format) {
    String formattedTime = "";
    try {
      formattedTime = DateFormat(format)
          .format(DateTime.fromMicrosecondsSinceEpoch(timestamp));
    } catch (e) {
      formattedTime = "";
      printP('error in formatting $e');
    }
    return formattedTime;
  }

  //Status bar color update
  void statusBarColor(
      {Color? statusBarColor,
      Color? navigationBarColor,
      bool isAppStatusDarkBrightness = true,
      bool isNavigationBarDarkBrightness = false}) {
    if (statusBarColor == null) {
      statusBarColor = Colors.transparent;
    }
    if (navigationBarColor == null) {
      navigationBarColor = Colors.black;
    }
    if (Platform.isAndroid) {
      try {
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarIconBrightness:
              isAppStatusDarkBrightness ? Brightness.dark : Brightness.light,
          systemNavigationBarIconBrightness: isNavigationBarDarkBrightness
              ? Brightness.dark
              : Brightness.light,
          statusBarColor: statusBarColor,
          systemNavigationBarColor: navigationBarColor,
        ));
        //top bar icons));
      } catch (e) {
        print(e);
      }
    } else if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarIconBrightness:
            isAppStatusDarkBrightness ? Brightness.dark : Brightness.light,
        systemNavigationBarIconBrightness:
            isNavigationBarDarkBrightness ? Brightness.light : Brightness.dark,
        statusBarColor: statusBarColor,
        systemNavigationBarColor: navigationBarColor,
      ));
    }
  }



  void logEventTime(String eventName) {
    String formattedTime = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(DateTime.now());
    print("$eventName at: $formattedTime");
  }

  //Print message/response on logcat
  printP(String body) {
    try {
      if (!ApiConst.isProduction) {
        debugPrint(body);
      }
    } catch (e) {
      debugPrint("$e");
    }
  }

  //get first letter from string
  getFirstLetterFromName(String word) {
    var firstAndLastLetter = "NA";

    if (word.trim() != "") {
      List wordSplit = [];
      var firstLetter = "";
      var lastLetter = "";
      if (word.contains(" ")) {
        wordSplit = word.split(" ");
        try {
          firstLetter = String.fromCharCode(word.runes.first);
        } catch (e) {
          debugPrint("$e");
        }
        if (wordSplit.length > 1) {
          try {
            String lastWordString = wordSplit[1];
            lastLetter = String.fromCharCode(lastWordString.runes.first);
          } catch (e) {
            debugPrint("$e");
          }
        }
      } else {
        try {
          firstLetter = String.fromCharCode(word.runes.first);
          firstLetter = getDecodedValue(firstLetter);
        } catch (e) {
          debugPrint("$e");
        }
      }
      firstAndLastLetter = firstLetter.toString().toUpperCase() +
          lastLetter.toString().toUpperCase();
    } else {
      return firstAndLastLetter;
    }
    return firstAndLastLetter;
  }

  //get build version of app
  getVersionName() async {
    String projectVersion = "";
    /*try {
      projectVersion = await GetVersion.projectVersion;
      printP('$projectVersion');
    } catch (e) {
      projectVersion = '';
      printP('$e');
    }*/
    return projectVersion;
  }

  //get decoded format
  getDecodedValue(String value) {
    String decodedValue = value;
    try {
      decodedValue = utf8.decode(value.codeUnits);
    } catch (err) {
      printP("$err");
    }
    return decodedValue;
  }

  String getTimeAgo({required int timestamp, required String format}) {
    //Note /*
    //
    //
    // Add this dependancy
    // timeago: ^2.0.22
    //
    // */
    String formattedTime = "";
    try {
      final fifteenAgo = DateTime.fromMillisecondsSinceEpoch(timestamp);
      formattedTime = timeago.format(fifteenAgo, locale: 'en');
    } catch (e) {
      formattedTime = "";
      printP('error in formatting $e');
    }
    return formattedTime;
  }

  Color colorFromIntString({String stringColor = "0xFF6C6C6C"}) {
    Color color = Colors.blueGrey;
    try {
      color = Color(int.parse(stringColor));
    } catch (e) {
      debugPrint("$e");
    }
    return color;
  }

  //Exit from app
  Future<void> logOutFromAppUnAuthUser({context}) async {
    try {
      await PrefUtils().clearAll();
      /*  Navigator.pushAndRemoveUntil(
          context,
          SlideRightRoute(
              widget: AppScreensFilesLink().mLoginOptionScreen()),
          ModalRoute.withName(screenLoginScreen));*/
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future? removeBadge() {
    try {
      FlutterNewBadger.removeBadge();
    } catch (e) {
      debugPrint("$e");
    }
    return null;
  }

  Future? addBadge(count) {
    if (count > 0) {
      try {
        try {
          FlutterNewBadger.setBadge(count);
        } catch (e) {
          debugPrint("$e");
        }
      } catch (e) {
        debugPrint("$e");
      }
    } else {
      try {
        removeBadge();
      } catch (e) {
        debugPrint("$e");
      }
    }

    return null;
  }

  Future deviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    //IOS
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print(iosInfo);
      //Device_os_version
      PrefUtils()
          .readStr(WorkplaceNotificationConst.deviceOsVersionC)
          .then((value) {
        if (value == '') {
          PrefUtils().saveStr(WorkplaceNotificationConst.deviceOsVersionC,
              iosInfo.systemVersion);
        } else {}
      });

      //Device id
      PrefUtils().readStr(WorkplaceNotificationConst.deviceIdC).then((value) {
        if (value == '') {
          //device id
          PrefUtils().saveStr(WorkplaceNotificationConst.deviceIdC,
              iosInfo.identifierForVendor);
        } else {
          //  PrefUtils().saveStr(deviceIdC, iosInfo.identifierForVendor);
        }
      });

      //device name
      PrefUtils().readStr(WorkplaceNotificationConst.deviceNameC).then((value) {
        // if (value == '') {
        String deviceName = "";
        if(iosInfo.utsname.nodename.trim().isNotEmpty){
          deviceName = iosInfo.utsname.nodename.trim();
        }
        else{
          deviceName = iosInfo.name;
        }
          PrefUtils()
              .saveStr(WorkplaceNotificationConst.deviceNameC, deviceName);
        // } else {
        //   //  PrefUtils().saveStr(deviceNameC, androidInfo.brand);
        // }
      });

      //model
      PrefUtils()
          .readStr(WorkplaceNotificationConst.deviceModelC)
          .then((value) {
        if (value == '') {
          PrefUtils()
              .saveStr(WorkplaceNotificationConst.deviceModelC, iosInfo.model);
        } else {
          //  PrefUtils().saveStr(deviceNameC, androidInfo.brand);
        }
      });
    }
    // Android
    else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print(androidInfo);

      //device os version
      PrefUtils()
          .readStr(WorkplaceNotificationConst.deviceOsVersionC)
          .then((value) {
        if (value == '') {
          PrefUtils().saveStr(WorkplaceNotificationConst.deviceOsVersionC,
              androidInfo.version.release);
        } else {
          //  PrefUtils().saveStr(deviceOsVersionC, androidInfo.version.release);
          // print("device os: $value");
        }
      });

      //device id
      PrefUtils().readStr(WorkplaceNotificationConst.deviceIdC).then((value) {
        if (value == '') {
          PrefUtils()
              .saveStr(WorkplaceNotificationConst.deviceIdC, androidInfo.id);
        } else {
          //  PrefUtils().saveStr(deviceIdC, androidInfo.androidId);
        }
      });

      //device name
      PrefUtils().readStr(WorkplaceNotificationConst.deviceNameC).then((value) {
        String deviceName = "";
        if(androidInfo.product.trim().isNotEmpty){
          deviceName = androidInfo.product.trim();
        }
        else{
          deviceName = androidInfo.board;
        }
          PrefUtils().saveStr(
              WorkplaceNotificationConst.deviceNameC, deviceName);
        // } else {
        //   //  PrefUtils().saveStr(deviceNameC, androidInfo.brand);
        // }
      });

      //model name
      PrefUtils()
          .readStr(WorkplaceNotificationConst.deviceModelC)
          .then((value) {
        if (value == '') {
          PrefUtils().saveStr(
              WorkplaceNotificationConst.deviceModelC, androidInfo.model);
        } else {
          //  PrefUtils().saveStr(deviceNameC, androidInfo.brand);
        }
      });
    } else {}
  }

  Future<String?> checkAppVersion(
      deviceType, versionUpdatePopupCallBack, context) async {
    if (Platform.isIOS) {
      deviceType = 1;
    } else if (Platform.isAndroid) {
      deviceType = 2;
    }
    //1 for ios
    // apiRequest.checkAppVersion(deviceType: deviceType).then((result) {
    //   if (result != null) {
    //     if (result.success && result.result != null) {
    //       //Android
    //       if (deviceType == 2) {
    //         if (result.result.version != null) {
    //           String playStoreAndroidVersion = result.result.version;
    //           try {
    //             /*GetVersion.projectVersion.then((appVersion) {
    //               if (playStoreAndroidVersion != null &&
    //                   playStoreAndroidVersion != appVersion) {
    //                 versionUpdatePopupCallBack(true);
    //               } else {
    //                 versionUpdatePopupCallBack(true);
    //               }
    //             });*/
    //           } catch (e) {
    //             debugPrint('$e');
    //           }
    //         }
    //       }
    //       //Ios
    //       if (deviceType == 1) {
    //         if (result.result.version != null) {
    //           String iOSAppStoreVersion = result.result.version;
    //           try {
    //             /*GetVersion.projectCode.then((appVersion) {
    //               if (iOSAppStoreVersion != null &&
    //                   iOSAppStoreVersion != appVersion) {
    //                 versionUpdatePopupCallBack(true);
    //               } else {
    //                 versionUpdatePopupCallBack(true);
    //               }
    //             });*/
    //           } catch (e) {
    //             debugPrint("$e");
    //           }
    //         }
    //       }
    //     } else {
    //       ErrorAlert(
    //           context: context,
    //           isItForInternet: true,
    //           alertTitle: AppString.appName,
    //           message: result.msg,
    //           callBackYes: (context1) async {
    //             Navigator.pop(context1);
    //             if (result.statusCode == -2000) {
    //               exit(0);
    //               //await sharedPreferencesFile.clearAll();
    //             }
    //           });
    //     }
    //     return null;
    //   } else {
    //     return null;
    //   }
    // });
    return null;
  }

  isImageFile({required String item}) {
    bool isImageFile = false;
    try {
      isImageFile =
          imageExtensions.contains(item.split('.').last.toUpperCase());
    } catch (e) {
      debugPrint("$e");
    }
    return isImageFile;
    // return item.endsWith(".jpg");
  }

  double intToDouble(value) {
    double result = 0.0;
    try {
      result =
          value.runtimeType == int ? double.parse(value.toString()) : value;
    } catch (e) {
      print(e);
    }
    return result;
  }

  // String getUserListOfMentionsUserList({required List? mentionsUserList}){
  //   if(mentionsUserList!=null && mentionsUserList.isNotEmpty){
  //     try {
  //       String symbolToReplace = "‡";
  //       List replacementValues = mentionsUserList;
  //       int replacementIndex = 0;
  //       inputString = inputString.replaceAllMapped(
  //               RegExp(symbolToReplace),
  //                   (Match match) {
  //                 // Use the replacement value and increment the index
  //                 String replacement = '${replacementValues[replacementIndex]}';
  //                 replacementIndex++;
  //                 return replacement;
  //               },
  //             );
  //     } catch (e) {
  //       print(e);
  //     }
  //   }
  //   return inputString;
  // }
  String insertIdInMassageOfTaggedUser(
      {required String inputString, required List? mentionsUserList}) {
    if (mentionsUserList != null && mentionsUserList.isNotEmpty) {
      try {
        String symbolToReplace = "‡";
        List replacementValues = mentionsUserList;
        int replacementIndex = 0;
        inputString = inputString.replaceAllMapped(
          RegExp(symbolToReplace),
          (Match match) {
            // Use the replacement value and increment the index
            String replacement = '${replacementValues[replacementIndex]}';
            replacementIndex++;
            return replacement;
          },
        );
      } catch (e) {
        print(e);
      }
    }
    return inputString;
  }
  String getTodayStartDateTime() {
    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day, 0, 1, 0); // 12:01 AM
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(todayStart);
  }

  String getYesterdayEndTime() {
    DateTime now = DateTime.now();
    DateTime yesterdayEndTime = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(yesterdayEndTime);
  }
  String replaceTaggedIdByNameInMassage(
      {required String inputString, required List? mentionsUserList}) {
    // print("inputString 01 $inputString");
    if (mentionsUserList != null && mentionsUserList.isNotEmpty) {
      try {
        Map<String, String> replacements = {
          // mentionsUserList.map((user)=>{"${user.id}": "@${user.name}"});
          for (var user in mentionsUserList) "${user.id}": "@${user.name}"
        };
        // Function to replace the placeholders
        inputString = inputString.replaceAllMapped(
          RegExp(r'\{\{(\d+)\}\}'), // Matches patterns like {{3}}, {{13}}, etc.
          (Match match) {
            String key = match.group(1)!;

            // Extract the number from {{number}}
            if (replacements[key] != null) {
              String? value = replacements[key];

              // return """<b>$value</b>""";
              return '''
      <!DOCTYPE html>
      <html>
      <body>
          <span 
    style="color: #077FC8; font-family: verdana; font-size: 11px; font-weight: bold; cursor: pointer;" 
    onclick="yourFunction()"
    >
    $value
</span>
      </body>
      </html>
    ''';
            } else {
              return match.group(0)!;
            }
            // return replacements[key] ?? match.group(0)!;  // Replace with the corresponding value, or keep the original if not found
          },
        );
      } catch (e) {
        print(e);
      }
    }
    // print("inputString 02 $inputString");
    return inputString;
  }
  String formatVisitingType(String? visitorType) {
    if (visitorType == null || visitorType.isEmpty) {
      return '';
    }
    String formatted = visitorType.replaceAll('_', ' ').toLowerCase();
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  String removeUnderScore(String? key) {
    if (key == null || key.isEmpty) {
      return '';
    }
    String formatted = key.replaceAll('_', ' ').toLowerCase();
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  String capitalizeFirstLetter(String? sentence) {
    if (sentence == null || sentence.isEmpty) {
      return '';
    }
    return sentence[0].toUpperCase() + sentence.substring(1);
  }

  String formatVisitingTypeForSubmission(String visitorType) {
    return visitorType.toLowerCase().replaceAll(' ', '_');
  }

  String formatTo12Hour(String time24) {
    try {
      final date = DateFormat("HH:mm").parse(time24);
      return DateFormat("h:mm a").format(date); // Example: 4:00 PM
    } catch (e) {
      return time24; // fallback
    }
  }


  String convertTo24HourFormat(String time) {
    try {
      // Check if time contains AM/PM (12-hour format)
      if (time.contains(RegExp(r'AM|PM', caseSensitive: false))) {
        // Parse the 12-hour format time
        DateFormat format12 = DateFormat("hh:mm a");
        DateTime dateTime = format12.parse(time);

        // Convert to 24-hour format
        DateFormat format24 = DateFormat("HH:mm");
        time = format24.format(dateTime);
        if(!time.contains(":")){
          time = "$time:00";
        }
        return time;
      } else {
        // Already in 24-hour format
        if(!time.contains(":")){
          time = "$time:00";
        }
        return time;
      }
    } catch (e) {
      return "Invalid time format";
    }
  }


  bool is24HourFormat(String time) {
    // Regular expression to match 24-hour format HH:mm
    RegExp regex = RegExp(r'^(?:[01]\d|2[0-3]):[0-5]\d$');
    return regex.hasMatch(time);
  }

  Future<void> vibrationOnLongClick() async {
    try {
      if (await Vibration.hasCustomVibrationsSupport()) {
        Vibration.vibrate(duration: 1000);
      }
      else {
        Vibration.vibrate();
        await Future.delayed(const Duration(milliseconds: 500));
        Vibration.vibrate();
      }
    } catch (e) {
      print(e);
    }
  }



  int maxFileSizeInBytes = 9 * 1024 * 1024; //  MB in bytes
 // Check file size
  bool isFileSizeValid(File file) {
    int sizeInBytes = file.lengthSync();
    double sizeInMB = sizeInBytes / (1024 * 1024);
    return file.lengthSync() <= maxFileSizeInBytes;
  }
  String formatStartDateTime(DateTime date) {
    // Start time is 12:01 AM
    DateTime formattedDate = DateTime(date.year, date.month, date.day, 0, 1, 0);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(formattedDate);
  }

  String formatEndDateTime(DateTime date) {
    // End time is 11:59:59 PM
    DateTime formattedDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(formattedDate);
  }

  String formatDate(DateTime? date) {
    return DateFormat('dd/MM/yyyy').format(date!);
  }

  String uiShowDateFormat(DateTime date) {
    return DateFormat('d MMM, yyyy').format(date);
  }

// For submission: e.g., 2025-05-05
  String submitDateFormat(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  //  DateTime? parseDisplayDate(String dateStr) {
  //   try {
  //     return DateFormat('dd MMM, yyyy').parse(dateStr);
  //   } catch (_) {
  //     return null; // handle invalid format gracefully
  //   }
  // }
  DateTime? parseDisplayDate(String dateStr) {
    try {
      // First try: "11 Sep, 2025"
      return DateFormat('dd MMM, yyyy').parse(dateStr);
    } catch (_) {
      try {
        // Second try: "September 11, 2025"
        return DateFormat('MMMM dd, yyyy').parse(dateStr);
      } catch (_) {
        return null; // fallback
      }
    }
  }



   DateTime? parseSubmitDate(String dateStr) {
    try {
      return DateFormat('yyyy-MM-dd').parse(dateStr);
    } catch (_) {
      return null;
    }
  }





  String capitalize(String? text) => (text?.isNotEmpty == true) ? '${text![0].toUpperCase()}${text.substring(1).toLowerCase()}' : '';

  String capitalizeFullName(String? text) {
    if (text == null || text.isEmpty) return '';
    return text
        .split(' ')
        .map((word) => word.isNotEmpty
        ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
        : '')
        .join(' ');
  }

  String formatForDisplay(String value) {
    if (value.isEmpty) return ""; // handle empty string early

    return value
        .split('_')
        .where((word) => word.isNotEmpty) // remove empty segments
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }


  /// ✅ Function 2: For API (convert back to original form with underscores)
  String formatForApi(String value) {
    return value
        .split(' ')
        .map((word) => word.toLowerCase())
        .join('_');
  }




  makingPhoneCall({String phoneNumber = ''}) async {
    // Format phone number to include country code (+91)
    String formattedPhoneNumber = phoneNumber;

    var url = Uri.parse('tel:$formattedPhoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  /// utils/phone_utils.dart

  String formatPhoneNumberWithCountryCode({
    required String phoneNumber,
    required String countryCode,
    bool withCountryCode = true,
  }) {
    String cleanedCountryCode = countryCode.replaceAll('+', '');

    String formattedNumber;
    if (phoneNumber.length == 10) {
      formattedNumber = '${phoneNumber.substring(0, 5)} ${phoneNumber.substring(5)}';
    } else if (phoneNumber.length == 9) {
      formattedNumber = '${phoneNumber.substring(0, 4)} ${phoneNumber.substring(4)}';
    } else {
      formattedNumber = phoneNumber;
    }

    return withCountryCode ? '+$cleanedCountryCode $formattedNumber' : formattedNumber;
  }




}

ProjectUtil projectUtil = ProjectUtil();

extension SafeOpacity on Color {
  Color safeOpacity(double opacity) {
    final alpha = (opacity.clamp(0.0, 1.0) * 255).round();
    return withAlpha(alpha);
  }
}