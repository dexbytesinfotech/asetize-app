// ignore_for_file: prefer_const_constructors
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:asetize/features/presentation/widgets/settings_list_view.dart';
import 'package:asetize/imports.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/util/app_theme/text_style.dart';
import '../../change_password/pages/change_password_screen.dart';
import '../../data/models/settings_data_model.dart';
import '../../login/pages/sign_in_new_screen.dart';
import '../../new_sign_up/pages/new_login_with_email_screen.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late UserProfileBloc bloc;
  bool isFingerprintEnabled = false;
  final LocalAuthentication auth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<UserProfileBloc>(context);
    _loadFingerprintPreference();
  }

  Future<void> _loadFingerprintPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFingerprintEnabled = prefs.getBool('isFingerprintEnabled') ?? false;
    });
  }

  Future<void> _setFingerprintPreference(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFingerprintEnabled', value);
    setState(() {
      isFingerprintEnabled = value;
    });
  }

  void _toggleFingerprint(bool value) async {
    if (value) {
      bool authenticated = await PrefUtils.authenticateWithBiometrics();
      if (authenticated) {
        _setFingerprintPreference(true);

        WorkplaceWidgets.successToast(
             AppString.fingerprintEnabled);
      } else {
        setState(() {
          isFingerprintEnabled = false;
        });


        WorkplaceWidgets.successToast(AppString.fingerprintFailed);
      }
    } else {
      bool authenticated = await PrefUtils.authenticateWithBiometrics();
      if (authenticated) {
        _setFingerprintPreference(false);
        WorkplaceWidgets.successToast( AppString.fingerprintDisabled);
      } else {
        setState(() {
          isFingerprintEnabled = true;
        });
        WorkplaceWidgets.successToast(AppString.fingerprintFailed);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserProfileBloc, UserProfileState>(
      listener: (context, state) {
        if (state is CancelState) {
          Navigator.of(context).pop();
        }

        if (state is DeleteUserState) {
          Navigator.of(context).push(
            SlideLeftRoute(widget: const NewLoginWithEmail()),
          );

          WorkplaceWidgets.errorSnackBar(context,"User deleted successfully");
        }
        if(state is UpdateNotificationErrorState)
        {

          WorkplaceWidgets.errorSnackBar(context,state!.errorMessage ?? "");
        }
        if (state is DeleteUserErrorState) {
          Navigator.of(context).pop();
          WorkplaceWidgets.errorSnackBar(context,state.errorMessage);
        }
      },
      builder: (context, state) {
        return PopScope(
          onPopInvoked: null,
          child: ContainerFirst(
            contextCurrentView: context,
            isSingleChildScrollViewNeed: true,
            isFixedDeviceHeight: true,
            appBarHeight: 56,
            appBar: CommonAppBar(
              title: 'Settings',
            ),
            containChild: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                NotificationToggle(),
                Divider(
                  indent: 18,
                  endIndent: 18,
                  height: 12,
                  thickness: 0.29,
                ),
                ContactDisplayToggle(),
                Divider(
                  indent: 18,
                  endIndent: 18,
                  height: 12,
                  thickness: 0.29,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 9),
                  child: ListTile(
                    leading: Icon(
                      Icons.fingerprint,
                      color: Colors.black,
                    ),
                    title: Text(AppString.biometricLogin),
                    trailing: CupertinoSwitch(
                      activeColor: AppColors.textBlueColor,
                      trackColor: AppColors.grey,
                      value: isFingerprintEnabled,
                      onChanged: _toggleFingerprint,
                    ),
                  ),
                ),
                if(bloc.user.enableDelete == true)  Divider(
                  indent: 18,
                  endIndent: 18,
                  height: 12,
                  thickness: 0.29,
                ),
                const SizedBox(height: 15,),
                if(bloc.user.enableDelete == true) Padding(
                  padding: const EdgeInsets.only(left: 28),
                  child: InkWell(
                    onTap: (){
                      showDialog(
                          context: context,
                          builder: (context) => WorkplaceWidgets.titleContentPopup(
                            buttonName1: "Cancel",
                            buttonName2: "Delete",
                            title: AppString.trans(context, AppString.deletePopupTitle),
                            content: AppString.trans(context, AppString.deletePopupContent),
                            onPressedButton1: () {
                              Navigator.pop(context);
                            },
                            onPressedButton2: () {
                              BlocProvider.of<UserProfileBloc>(context).add(DeleteUserEvent(mContext: context));
                            },
                          ));
                    },
                    child: Row(
                      children: [
                        WorkplaceIcons.iconImage(
                          imageUrl: 'assets/images/trash.svg', // Directly providing the icon path
                          iconSize: const Size(22, 22),
                          imageColor: AppColors.red, // Set your desired default color
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Delete Account", // Directly providing the title
                                textAlign: TextAlign.start,
                                style: appStyles.onBoardingTitleStyle(
                                  fontSize: 14.5,
                                  height: 1.1,
                                  fontWeight: FontWeight.w400,
                                  texColor:  AppColors.red,  // Set your desired text color
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> redirectTo(String title, BuildContext context) async {
    if (title == "Change Password") {
      Navigator.push(
        MainAppBloc.getDashboardContext,
        SlideRightRoute(widget: const ChangePasswordScreen()),
      );
    }
    /* else if (title == "Notifications") {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      NotificationSettings settings = await messaging.getNotificationSettings();
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        if (bloc.notification == false) {
          showAdaptiveDialog(
              context: context,
              barrierDismissible: true,
              builder: (context) => AlertDialog.adaptive(
                title: Text(
                  "\"Team Diary\" would like to send you notifications ",
                  style: TextStyle(color: Colors.black),
                ),
                content: Text(
                  'Notifications may include alert sound and icon badges. This can be configured in settings.',
                  style: TextStyle(color: Colors.black),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Don't allow",
                        style: TextStyle(color: AppColors.appBlueColor),
                      )),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        openAppSettings();
                      },
                      child: Text(
                        "OK",
                        style: TextStyle(color: AppColors.appBlueColor),
                      )),
                ],
              ));
        } else {
          BlocProvider.of<UserProfileBloc>(context)
              .add(UpdateNotificationEvent(mContext: context));
        }
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.authorized) {
        BlocProvider.of<UserProfileBloc>(context)
            .add(UpdateNotificationEvent(mContext: context));
      } else {
        BlocProvider.of<UserProfileBloc>(context)
            .add(UpdateNotificationEvent(mContext: context));
      }
    }*/
    // else if (title == "Delete Account") {
    //   showDialog(
    //     context: context,
    //     builder: (context) => WorkplaceWidgets.titleContentPopup(
    //       buttonName1: "Cancel",
    //       buttonName2: "Delete",
    //       title: AppString.trans(context, AppString.deletePopupTitle),
    //       content: AppString.trans(context, AppString.deletePopupContent),
    //       onPressedButton1: () {
    //         Navigator.pop(context);
    //       },
    //       onPressedButton2: () {
    //         BlocProvider.of<UserProfileBloc>(context).add(DeleteUserEvent(mContext: context));
    //       },
    //     ),
    //   );
    // }
  }
}


class NotificationToggle extends StatefulWidget {
  const NotificationToggle({super.key});

  @override
  State<NotificationToggle> createState() => _NotificationToggleState();
}

class _NotificationToggleState extends State<NotificationToggle> with SingleTickerProviderStateMixin {
  bool isEnabled = true;
  bool isLoading = true;
  late UserProfileBloc bloc;
  late AnimationController _controller;
  // We know the typical CupertinoSwitch has a fixed size.
  // For iOS style, the switch is roughly 59 x 31.
  Size switchSize = Size(59, 31);

  @override
  void initState() {
    // TODO: implement initState
    bloc = BlocProvider.of<UserProfileBloc>(context);
    isEnabled = bloc.notification;
    // The controller will run continuously so that our loader border rotates.
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 1));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
    bloc: bloc,
        builder: (context, state) {
      if(state is UpdateNotificationState  || state is UpdateNotificationErrorState){
        isEnabled = bloc.notification;
        isLoading = true;
      }

      if(state is NotificationLoadingState){
        isLoading = true;
      }

      return
        Padding(
          padding: const EdgeInsets.only(left: 9),
          child: ListTile(
            leading:  WorkplaceIcons.iconImage(
              imageUrl: 'assets/images/notification_icon.svg',
              iconSize: const Size(22, 22),
              imageColor: Color(0xFF252525),
            ),
            title: const Text(AppString.notifications),
            titleTextStyle: TextStyle(
                color: Color(0xFF252525),
                fontSize: 15
            ),
            trailing: SizedBox(
              width: switchSize.width,
              height: switchSize.height,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CupertinoSwitch(
                    activeColor: AppColors.appBlueColor,
                    trackColor: AppColors.grey,
                    value: isEnabled,
                    onChanged: (value) async {
                      // print("Notification enabled: $value");
                      setState(() => isEnabled = value);

                      try {
                        PermissionStatus status = await Permission.notification.status;

                        if ((status.isDenied || status.isPermanentlyDenied) && isEnabled) {
                          _showNotificationDialog(context);
                        }
                        else if (status.isGranted) {
                          BlocProvider.of<UserProfileBloc>(context)
                              .add(UpdateNotificationEvent(mContext: context, notifications: isEnabled));
                        } else {
                          setState(() => isEnabled = !isEnabled);
                        }
                      } catch (e) {
                        print("Error checking notification permission: $e");
                        setState(() => isEnabled = !isEnabled);
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        );
    });
  }

  void _showNotificationDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog.adaptive(
        title: Text(AppString.notificationsTitle, style: appTextStyle.appNormalSmallTextStyle()),
        content: Text(AppString.notificationsContent, style: appTextStyle.appNormalSmallTextStyle()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => isEnabled = false);
            },
            child: Text(AppString.donNotAllow, style: appTextStyle.appNormalSmallTextStyle(color: AppColors.appBlueColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings().then((value) {
                if (!value) {
                  setState(() => isEnabled = false);
                } else {
                  BlocProvider.of<MainAppBloc>(context).add(UpdateTokenEvent(mContext : context));
                  BlocProvider.of<UserProfileBloc>(context)
                      .add(UpdateNotificationEvent(mContext: context));
                }
              });
            },
            child: Text(AppString.ok, style: TextStyle(color: AppColors.appBlueColor)),
          ),
        ],
      ),
    );
  }

}


class ContactDisplayToggle extends StatefulWidget {
  const ContactDisplayToggle({super.key});

  @override
  State<ContactDisplayToggle> createState() => _ContactDisplayToggleState();
}

class _ContactDisplayToggleState extends State<ContactDisplayToggle> with SingleTickerProviderStateMixin {
  bool isEnabled = false;
  bool isLoading = true;
  late UserProfileBloc bloc;
  late AnimationController _controller;
  // We know the typical CupertinoSwitch has a fixed size.
  // For iOS style, the switch is roughly 59 x 31.
  Size switchSize = Size(59, 31);

  @override
  void initState() {
    // TODO: implement initState
    bloc = BlocProvider.of<UserProfileBloc>(context);
    isEnabled = bloc.selfContactDisplayStatus;
    // The controller will run continuously so that our loader border rotates.
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 1));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileBloc, UserProfileState>(
    bloc: bloc,
        builder: (context, state) {
      if(state is ContactShowStatusChangeDoneState  || state is ContactShowStatusChangeErrorState){
        isEnabled = bloc.selfContactDisplayStatus;
        isLoading = true;
      }

      if(state is ContactShowStatusChangeLoadingState){
        isLoading = true;
      }

      return
        Padding(
          padding: const EdgeInsets.only(left: 9),
          child: ListTile(
            leading:  WorkplaceIcons.iconImage(
              imageUrl: 'assets/images/contact_show_setting_icon.svg',
              iconSize: const Size(22, 22),
              imageColor: Color(0xFF252525),
            ),
            title: Text(AppString.enableContactDetailLabel),
            titleTextStyle: TextStyle(
                color: Color(0xFF252525),
                fontSize: 15
            ),
            trailing: SizedBox(
              width: switchSize.width,
              height: switchSize.height,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CupertinoSwitch(
                    activeColor: AppColors.appBlueColor,
                    trackColor: AppColors.grey,
                    value: isEnabled,
                    onChanged: (value) async {
                      print("Notification enabled: $value");
                      // setState(() => isEnabled = value);
                      setState(() => isEnabled = !isEnabled);
                      BlocProvider.of<UserProfileBloc>(context)
                              .add(OnContactShowStatusChangeEvent(mContext: context, notifications: isEnabled));
                    },
                  )
                ],
              ),
            ),
          ),
        );
    });
  }

  void _showNotificationDialog(BuildContext context) {
    showAdaptiveDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog.adaptive(
        title: Text(AppString.notificationsTitle, style: appTextStyle.appNormalSmallTextStyle()),
        content: Text(AppString.notificationsContent, style: appTextStyle.appNormalSmallTextStyle()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => isEnabled = false);
            },
            child: Text(AppString.donNotAllow, style: appTextStyle.appNormalSmallTextStyle(color: AppColors.appBlueColor)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              openAppSettings().then((value) {
                if (!value) {
                  setState(() => isEnabled = false);
                } else {
                  BlocProvider.of<UserProfileBloc>(context)
                      .add(UpdateNotificationEvent(mContext: context));
                }
              });
            },
            child: Text(AppString.ok, style: TextStyle(color: AppColors.appBlueColor)),
          ),
        ],
      ),
    );
  }

}


