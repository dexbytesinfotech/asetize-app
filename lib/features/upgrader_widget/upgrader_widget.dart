import 'package:flutter/cupertino.dart';
import 'package:flutter_in_store_app_version_checker/flutter_in_store_app_version_checker.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../imports.dart';

class UpgradeWidget extends StatefulWidget {
  final Widget child;
  const UpgradeWidget({super.key, required this.child});

  @override
  State<UpgradeWidget> createState() => _UpgradeWidgetState();
}

class _UpgradeWidgetState extends State<UpgradeWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVersion();
    });
  }

  Future<void> _checkVersion() async {
    final checker = InStoreAppVersionChecker();
    try {
      final updateInfo = await checker.checkUpdate();
      if (updateInfo.canUpdate && mounted) {
        updateAppPopUI(isShowLaterBt: false,versionNumber: updateInfo.newVersion ?? '');
      }
    } catch (e) {
      print("Error checking app version: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SizedBox(
        child: widget.child,
      ),
    );
  }

  Future updateAppPopUI({bool isShowLaterBt = false, String versionNumber = ''}) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Update Dialog",
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) {
        return PopScope(
          canPop: false,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 25),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            color: AppColors.appBlueColor,
                            shape: BoxShape.circle
                        ),
                        padding: EdgeInsets.all(10),
                        child: Icon(CupertinoIcons.down_arrow,color: Colors.white,)),
                    const SizedBox(height: 20),
                    const Text(
                      'New Version Available',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Please update your app to the latest version $versionNumber for a better experience",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isShowLaterBt)
                          Expanded(
                            flex: 2,
                            child: AppButton(
                              buttonName: 'Later',
                              buttonColor: Colors.transparent,
                              buttonBorderColor: AppColors.textBlueColor,
                              textStyle: appStyles.buttonTextStyle1(texColor: AppColors.textBlueColor),
                              backCallback: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        if (isShowLaterBt) const SizedBox(width: 20),
                        Expanded(
                          flex: 4,
                          child: AppButton(
                            buttonName: 'Update Now',
                            buttonColor: AppColors.textBlueColor,
                            backCallback: () {
                              if (Platform.isAndroid) {
                                _redirectToPlayStore();
                              } else if (Platform.isIOS) {
                                _redirectToAppStore();
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(parent: anim, curve: Curves.easeIn),
          child: child,
        );
      },
    );
  }

  // Redirect to Play Store
  static Future<void> _redirectToPlayStore() async {
    const url =
        'https://play.google.com/store/apps/details?id=com.dexbytes.asetize';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Redirect to App Store
  static Future<void> _redirectToAppStore() async {
    const url = "https://apps.apple.com/app/6740532436";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

}
