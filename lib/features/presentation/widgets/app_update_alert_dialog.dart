import 'package:flutter/material.dart';
import 'package:flutter_in_store_app_version_checker/flutter_in_store_app_version_checker.dart';
// import 'package:flutter_app_version_checker/flutter_app_version_checker.dart';
import 'package:http/http.dart' as http;
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../imports.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppUpdateAlertDialog extends StatefulWidget {
  final BuildContext contextOfPopUp;
  final String? updatedAppUrl;
  final Function? onAfterUpdate;

  const AppUpdateAlertDialog({
    super.key,
    required this.contextOfPopUp,
    this.updatedAppUrl,
    this.onAfterUpdate,
  });

  @override
  State<AppUpdateAlertDialog> createState() => _AppUpdateAlertDialogState();
}

class _AppUpdateAlertDialogState extends State<AppUpdateAlertDialog>
    with TickerProviderStateMixin {
  bool loading = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();

    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          color: Colors.white,
          margin: const EdgeInsets.symmetric(horizontal: 20),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.5, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  WorkplaceIcons.appLogoImage,
                  width: MediaQuery.of(context).size.shortestSide * 0.50,
                  height: MediaQuery.of(context).size.shortestSide * 0.50,
                ),
                const Text(
                  AppString.newVersionReady,
                  style:  TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  AppString.updateContent,
                  textAlign: TextAlign.center,
                  style:  TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                updateNowBtn(),
                const SizedBox(height: 10),
                laterText(),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget laterText() {
    return InkWell(
      onTap: () {
        if (!loading) {
          _controller.reverse().then((_) => Navigator.pop(context));
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          AppString.capitalSkip,
          style: TextStyle(
            color: AppColors.appBlue,
            fontWeight: FontWeight.w600,
            fontFamily: appFonts.defaultFont,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget updateNowBtn() {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return OutlinedButton(
          onPressed: () {
            if (!loading) {
              launchUrl(Uri.parse(widget.updatedAppUrl!)).then((value) {
                widget.onAfterUpdate?.call();
                setState(() {
                  loading = true;
                });
              });
            }
          },
          style: OutlinedButton.styleFrom(
            backgroundColor: Color.lerp(AppColors.appBlue, Colors.lightBlueAccent, _shimmerController.value),
            side: const BorderSide(color: Colors.white), // Set border color to white
          ),
          child: Text(
            AppString.updateNow,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontFamily: appFonts.defaultFont,
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }

}

class AppUpdateChecker{
  final _checker = InStoreAppVersionChecker();



  /// Update app by new release version on google play store
  void checkVersion(BuildContext context,{bool? isRefreshing = false}) async {
    // _checker.checkUpdate().then((value) {
    //   debugPrint('${{value.canUpdate}}'); //return true if update is available
    //   debugPrint(value.currentVersion); //return current app version
    //   debugPrint(value.newVersion); //return the new app version
    //   debugPrint(value.appURL); //return the app url
    //   debugPrint(value
    //       .errorMessage); //return error message if found else it will return null
    //   if (value.canUpdate) {
    //     if (isRefreshing!) {
    //       Navigator.of(context).pop();
    //     }
    //     Navigator.of(context).push(DialogRoute(
    //       barrierDismissible: false,
    //       builder: (context) => AppUpdateAlertDialog(
    //           contextOfPopUp: context,
    //           updatedAppUrl: value.appURL,
    //           onAfterUpdate: () {
    //             checkVersion(context,isRefreshing: true);
    //           }),
    //       context: context,
    //     ));
    //   }
    // });
    Future.delayed(Duration.zero, () {
      if (Platform.isAndroid) {
        checkForAndroidUpdate();
      } else if (Platform.isIOS) {
        checkForiOSUpdate();
      }
    });
  }

  static Future<void> checkForAndroidUpdate() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // Replace with your package's ID in the URL
      final response = await http.get(Uri.parse("https://play.google.com/store/apps/details?id=com.dexbytes.asetize"));

      if (response.statusCode == 200) {
        // You can use a regular expression to extract the latest version from the HTML page (Play Store)
        final regex = RegExp(r'"versionName":"([0-9\.]+)"');
        final match = regex.firstMatch(response.body);

        if (match != null) {
          String latestVersion = match.group(1)!;

          Version currentV = Version.parse(currentVersion);
          Version storeV = Version.parse(latestVersion);

          // Test if the current version is less than the store version
          if (currentV < storeV) {
            _promptUserToUpdate();
          }
        }
      }
    } catch (e) {
      print("Error checking Android update: $e");
    }
  }


  static Future<void> checkForiOSUpdate() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      final response = await http.get(Uri.parse("https://itunes.apple.com/lookup?bundleId=com.dexbytes.asetize&country=IN"));

      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        String latestVersion = jsonData["results"][0]["version"];

        Version currentV = Version.parse(currentVersion);
        Version storeV = Version.parse(latestVersion);
        // Test version  < play store version
        if (currentV < storeV) {
          _promptUserToUpdate();
        }
      }
    } catch (e) {
      print("Error checking iOS update: $e");
    }
  }

  static void _promptUserToUpdate() async {
    String appStoreUrl = "https://apps.apple.com/app/6740532436";
    if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
      await launchUrl(Uri.parse(appStoreUrl));
    }
  }
}