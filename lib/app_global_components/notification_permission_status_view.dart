import 'package:flutter/gestures.dart';
import 'package:permission_handler/permission_handler.dart';
import '../core/util/app_navigator/app_navigator.dart';
import '../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../features/presentation/pages/profile_settings_screen.dart';
import '../imports.dart';

class NotificationPermissionStatusView extends StatefulWidget {
  const NotificationPermissionStatusView({super.key});

  @override
  State<NotificationPermissionStatusView> createState() => _NotificationPermissionStatusViewState();
}

class _NotificationPermissionStatusViewState extends State<NotificationPermissionStatusView> with WidgetsBindingObserver{
  NotificationPermissionService? permissionService;
  bool isNotificationPermissionGranted = true;
  String appSettingNotificationMessage = "";
  bool isTurnOnClicked = false;
  bool isAppSettingTurnOnClicked = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App has resumed
      permissionService = NotificationPermissionService();
      permissionService!.isNotificationPermissionGranted(context).then((value){
        onStatusResponse(value);
      });
    }
    else if (state == AppLifecycleState.paused) {
      // App is paused (background)
    }
    else if (state == AppLifecycleState.inactive) {
      // App is inactive (e.g., receiving a call)
    }
    else if (state == AppLifecycleState.detached) {
      // App is closing
      debugPrint("App Detached!");
    }
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    permissionService = NotificationPermissionService();
    permissionService!.isNotificationPermissionGranted(context).then((value){
      onStatusResponse(value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    if(isNotificationPermissionGranted && appSettingNotificationMessage.isEmpty){
      return const SizedBox();
    }
    else{
      return Container(
        width: MediaQuery.of(context).size.width,height: 90,
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          // color: Colors.green.shade100,
          color: AppColors.notificationPermissionBgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Icon(Icons.notifications, color: Colors.green, size: 28),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Get notifications",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: appSettingNotificationMessage.isNotEmpty
                              ? appSettingNotificationMessage
                              : "App notifications are disabled. Enable notifications to stay updated! ",
                          style: const TextStyle(fontSize: 14, color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Turn on",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  if (appSettingNotificationMessage.isEmpty) {
                                    await openAppSettings().then((value) {
                                      setState(() {
                                        isTurnOnClicked = true;
                                      });
                                    });
                                  } else if (appSettingNotificationMessage.isNotEmpty) {
                                    setState(() {
                                      isAppSettingTurnOnClicked = true;
                                    });
                                    Navigator.push(
                                      context,
                                      SlideLeftRoute(
                                        widget:  const ProfileSettingsScreen(),
                                      ),
                                    ).then((value) {
                                      setState(() {
                                        isAppSettingTurnOnClicked = false;
                                      });
                                      permissionService!
                                          .isNotificationPermissionGranted(context)
                                          .then((value) {
                                        onStatusResponse(value);
                                      });
                                    });
                                  }
                                },
                            ),
                          ],
                        ),
                      ],
                    ),

                  ),
                ],
              ),
            ),
            // InkWell(child: Container(color: Colors.transparent,child: const Icon(Icons.close, color: Colors.black54, size: 28))),
          ],
        ),
      );
    }
  }

  void onStatusResponse(value) {
    /// APi calling
    if(isTurnOnClicked && value == true){
      OneSignalNotificationsHandler.instance.refreshToken().then((String? newToken){
        BlocProvider.of<MainAppBloc>(context).add(UpdateTokenEvent(mContext : context));
      });
    }

    /// Check App notification enabled from app setting if not then we will change message and redirect on app setting page
    if(value && BlocProvider.of<UserProfileBloc>(context).notification == false){
      appSettingNotificationMessage = "Notifications are turned off. You may miss important updates and alerts.";
    }
    else{
      appSettingNotificationMessage = "";
    }

    setState(() {
      isTurnOnClicked = false;
      isNotificationPermissionGranted = value;
    });
  }
}



class NotificationPermissionService {
  PermissionStatus? _previousStatus;

  Future<void> checkNotificationPermission(BuildContext context) async {
    PermissionStatus currentStatus = await Permission.notification.status;
    if (_previousStatus != null && _previousStatus != currentStatus) {
      if (currentStatus.isGranted) {
        // _showPopup(context, "Notification permission granted.");
      } else if (currentStatus.isDenied) {
        // _showPopup(context, "Notification permission denied.");
      } else if (currentStatus.isPermanentlyDenied) {
        // _showPopup(context, "Notification permission permanently denied.\nGo to settings to enable.");
      }
    }

    _previousStatus = currentStatus;
  }

  Future<bool> isNotificationPermissionGranted(BuildContext context) async {
    PermissionStatus currentStatus = await Permission.notification.status;
    if (currentStatus.isGranted) {
      return true;
    }
    else if (currentStatus.isDenied) {
      return false;
    }
    else if (currentStatus.isPermanentlyDenied) {
      return false;
    }
    // if (_previousStatus != null && _previousStatus != currentStatus) {
    //   if (currentStatus.isGranted) {
    //     return true;
    //   }
    //   else if (currentStatus.isDenied) {
    //     return false;
    //   }
    //   else if (currentStatus.isPermanentlyDenied) {
    //     return false;
    //   }
    //   else {
    //     return false;
    //   }
    // }
    return false;
  }
}