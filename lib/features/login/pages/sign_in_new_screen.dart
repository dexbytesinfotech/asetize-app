import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:asetize/core/util/app_navigator/app_navigator.dart';
import 'package:asetize/imports.dart';
import 'package:local_auth/local_auth.dart';


import '../../new_sign_up/pages/new_login_with_email_screen.dart';

import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';

import '../../new_sign_up/pages/request_for_add_new_society.dart';
import '../bloc/sign_in_bloc/sign_in_bloc.dart';
import '../bloc/sign_in_bloc/sign_in_event.dart';
import '../bloc/sign_in_bloc/sign_in_state.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  String selectedAction = ""; // Keeps track of the selected action

  final LocalAuthentication auth = LocalAuthentication();
  Map<String, TextEditingController> controllers = {
    'email': TextEditingController(),
    'password': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'email': FocusNode(),
    'password': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'email': "",
    'password': "",
  };

  String countryCode = '';
  OverlayEntry? overlayEntry;
  Color? statusBarColor;
  String phoneNumber = '';
  bool hideNewPassword = true;

  void togglePasswordVisibility1() =>
      setState(() => hideNewPassword = !hideNewPassword);

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text(
          AppString.select,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87),
        ),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            onPressed: () {
              setState(() {
                selectedAction = "asASociety";
              });
              Navigator.pop(context);
              Navigator.push(
                context,
                SlideLeftRoute(widget: const RequestForAddNewSociety()),
              );
            },
            child: Text(
              AppString.asASociety,
              style: TextStyle(
                color: selectedAction == "asASociety"
                    ? Colors.blue
                    : Colors.black,
                fontWeight: selectedAction == "asASociety"
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              setState(() {
                selectedAction = "asAMember";
              });

              Navigator.pop(context);
              Navigator.push(
                context,
                SlideLeftRoute(widget: const NewLoginWithEmail()),
              );
            },
            child: Text(
              AppString.asAMember,
              style: TextStyle(
                color: selectedAction == "asAMember"
                    ? Colors.blue
                    : Colors.black,
                fontWeight: selectedAction == "asAMember"
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
// TODO: implement initState
    focusNodes['email']!.addListener(() {
      if (Platform.isIOS) {
        bool hasFocus = focusNodes['email']!.hasFocus;
        if (hasFocus) {
          showOverlay(context);
        } else {
          removeOverlay();
        }
      }
    });
    // FirebaseMessaging.instance.requestPermission().then((value) async {
    //   await FirebaseMessaging.instance.getToken().then((value) {
    //     if (value != null) {
    //       PrefUtils().saveStr(WorkplaceNotificationConst.deviceTokenC, value);
    //     }
    //   });
    // });

    MainAppBloc.dashboardContext = context;
    String? token = OneSignalNotificationsHandler.instance.getToken();
    OneSignalNotificationsHandler.instance.setAppContext(MainAppBloc.getDashboardContext);
    projectUtil.deviceInfo();
    super.initState();
  }

  @override
  void dispose() {
    controllers['p'
            'hone']
        ?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SignInBloc signInBloc = BlocProvider.of<SignInBloc>(context);

    AppDimens appDimens = AppDimens();
    appDimens.appDimensFind(context: context);

    checkEmail(value, fieldEmail, {onchange = false}) {
      if (Validation.isNotEmpty(value.trim())) {
        setState(() {
          if (Validation.validateEmail(value.trim())) {
            errorMessages[fieldEmail] = "";
          } else {
            if (!onchange) {
              errorMessages[fieldEmail] =
                  AppString.trans(context, AppString.emailHintError1);
            }
          }
        });
      } else {
        setState(() {
          if (!onchange) {
            if (fieldEmail == 'email') {
              errorMessages[fieldEmail] =
                  AppString.trans(context, AppString.emailHintError);
            }
          }
        });
      }
    }

    //Check password field
    checkPassword(value, fieldEmail, {onchange = false}) {
      if (Validation.isNotEmpty(value.trim())) {
        setState(() {
          if (Validation.passwordLength(value.trim())) {
            if (!onchange) {
              errorMessages[fieldEmail] = "";

              // AppString.trans(
              // context, AppString.invalidPassword);
            }
          } else {
            if (!onchange) {
              errorMessages[fieldEmail] = "";

              // AppString.trans(
              // context, AppString.invalidPassword);
            }
          }
        });
      } else {
        setState(() {
          if (!onchange) {
            if (fieldEmail == 'password') {
              errorMessages[fieldEmail] =
                  AppString.trans(context, AppString.pleaseEnterPassword);
            } else if (fieldEmail == 'last_name') {
              errorMessages[fieldEmail] =
                  AppString.trans(context, AppString.enterLastName);
            }
          }
        });
      }
    }

    bool validateFields({isButtonClicked = false}) {
      if (controllers['email']!.text.isEmpty ||
          controllers['email']!.text == '') {
        setState(() {
          if (isButtonClicked) {
            errorMessages['email'] =
                AppString.trans(context, AppString.emailHintError);
          }
        });
        return false;
      } else if (!Validation.validateEmail(controllers['email']!.text)) {
        setState(() {
          if (isButtonClicked) {
            errorMessages['email'] =
                AppString.trans(context, AppString.emailHintError1);
          }
        });
        return false;
      } else if (controllers['password']?.text == null ||
          controllers['password']?.text == '') {
        setState(() {
          if (isButtonClicked) {
            errorMessages['password'] =
                AppString.trans(context, AppString.pleaseEnterPassword);
          }
        });
        return false;
      } else {
        return true;
      }
    }

    emailField() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['email'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['email']?.toString() ?? '',
          controllerT: controllers['email'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 50,
          errorMsgHeight: 24,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.none,
          cursorColor: Colors.grey,
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 6.0, bottom: 3),
            child: Text("Work Email",
                textAlign: TextAlign.start,
                style: appStyles.texFieldPlaceHolderStyle()),
          ),
          enabledBorderColor: AppColors.textFiledBorderColor,
          focusedBorderColor: AppColors.textFiledBorderColor,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.email,
          hintText: "name@company.com",
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          inputFieldSuffixIcon: Padding(
            padding: const EdgeInsets.only(right: 18, left: 10),
            child: WorkplaceIcons.iconImage(
                imageUrl: WorkplaceIcons.emailIcon,
                imageColor: controllers['email']!.text.isEmpty
                    ? const Color(0xFF575757)
                    : AppColors.textBlueColor),
          ),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            checkEmail(value, 'email', onchange: true);
          },
          onEndEditing: (value) {
            checkEmail(value, 'email');
            FocusScope.of(context).requestFocus(focusNodes['password']);
          },
        ),
      );
    }

    Widget visibilityOffIcon = Icon(
      Icons.visibility_off,
      color: controllers['password']!.text.isEmpty
          ? const Color(0xFF575757)
          : AppColors.textBlueColor,
      size: 23,
    );

    Widget visibilityOnIcon = Icon(
      Icons.visibility,
      color: controllers['password']!.text.isEmpty
          ? const Color(0xFF575757)
          : AppColors.textBlueColor,
      size: 23,
    );

    //Password Field
    passwordField() {
      return Container(
        margin: const EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CommonTextFieldWithError(
              inputFormatter: [
                FilteringTextInputFormatter.deny(RegExp(r'\s')),
              ],
              focusNode: focusNodes['password'],
              isShowBottomErrorMsg: true,
              errorMessages: errorMessages['password']?.toString() ?? '',
              controllerT: controllers['password'],
              borderRadius: 8,
              inputHeight: 50,
              errorMsgHeight: 16,
              autoFocus: false,
              errorLeftRightMargin: 0,
              maxCharLength: 16,
              capitalization: CapitalizationText.none,
              cursorColor: Colors.grey,
              placeHolderTextWidget: Padding(
                padding: const EdgeInsets.only(left: 6.0, bottom: 3),
                child: Text("Password",
                    textAlign: TextAlign.start,
                    style: appStyles.texFieldPlaceHolderStyle()),
              ),
              enabledBorderColor: AppColors.textFiledBorderColor,
              focusedBorderColor: AppColors.textFiledBorderColor,
              backgroundColor: AppColors.white,
              textInputAction: TextInputAction.done,
              borderStyle: BorderStyle.solid,
              inputKeyboardType: InputKeyboardTypeWithError.email,
              obscureText: hideNewPassword,
              hintText: AppString.trans(context, AppString.password),
              errorStyle: appStyles.errorStyle(fontSize: 10),
              errorMessageStyle: appStyles.errorStyle(fontSize: 10),
              hintStyle: appStyles.hintTextStyle(),
              textStyle: appStyles.textFieldTextStyle(),
              contentPadding: const EdgeInsets.only(left: 15, right: 15),
              inputFieldSuffixIcon: controllers['password']!.text.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(right: 15, left: 15),
                      child: WorkplaceIcons.iconImage(
                          iconSize: const Size(16, 16),
                          imageUrl: WorkplaceIcons.passwordIcon,
                          imageColor: const Color(0xFF575757)),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                        right: 2,
                      ),
                      child: IconButton(
                        icon: hideNewPassword
                            ? visibilityOffIcon
                            : visibilityOnIcon,
                        onPressed: togglePasswordVisibility1,
                      ),
                    ),
              onTextChange: (value) {
                checkPassword(value, 'password', onchange: false);
              },
              onEndEditing: (value) {
                checkPassword(value, 'password');
                FocusScope.of(context).requestFocus(FocusNode());
              },
            ),
          ],
        ),
      );
    }

    // login button
    loginButton() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: AppButton(
          buttonName: AppString.trans(context, AppString.loginT),
          backCallback: () {
            String email = controllers['email']!.text.trim();
            String password = controllers['password']!.text.trim();
            if (validateFields(isButtonClicked: true)) {
              Map data = {"email": email, "password": password};
              signInBloc.add(SubmitSignInEvent(requestData: data, mContext: context));
            }
          },
        ),
      );
    }
    Widget biometricLogin() {
      return Column(
        children: [
          FutureBuilder(
            future: PrefUtils()
                .readBool(WorkplaceNotificationConst.isFingerprintEnabledC),
            builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(); // Loading state
              } else if (snapshot.hasData) {
                bool isFingerprintEnabled =
                    snapshot.data ?? false; // Reading the value
                return (!isFingerprintEnabled)
                    ? const SizedBox()
                    : IconButton(
                  icon: const Icon(
                    Icons.fingerprint,
                    size: 55.0,
                    color: Colors.blue,
                  ),
                  onPressed: () async {
                    if (isFingerprintEnabled) {
                      bool authenticated =  await PrefUtils.authenticateWithBiometrics();
                      if (authenticated) {
                        context.go("/dashBoard");
                        // Navigator.pushNamed(context, "/dashBoard");
                      }
                    }
                  },
                ); // Displaying the result
              }
              return const SizedBox(); // Default case
            },
          ),
        ],
      );
    }
    Widget topIcon() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(WorkplaceIcons.appLogoImage, width:  MediaQuery.of(context).size.shortestSide * 0.62)
        ],
      );
    }

    Widget forgotPasswordText() {
      return Padding(
        padding: const EdgeInsets.only(right: 22.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  appNavigator.launchForgotPasswordPage(context);
                },
                child: const Text("Forgot Password?",
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textBlueColor,
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline)

                ),
              ),
            ),
          ],
        ),
      );
    }

    return ContainerFirst(
        reverse: false,
        contextCurrentView: context,
        isSingleChildScrollViewNeed: true,
        isFixedDeviceHeight: true,
        appBarHeight: -1,
        appBar: Container(),
        containChild: BlocListener<SignInBloc, SignInState>(
          bloc: signInBloc,
          listener: (BuildContext context, SignInState state) {
            if (state is SignInDoneState) {
              context.go('/dashBoard');
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(builder: (context) => DashBoardPage()),
              //     (route) => false);
            }
            if (state is SignInErrorState) {
              WorkplaceWidgets.errorPopUp(
                  context: context,
                  content: '${state.errorMessage}',
                  onTap: () {
                    Navigator.of(context).pop();
                  });
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //     content: Text((state.errorMessage != null)
              //         ? '${state.errorMessage}'
              //         : 'Check your login details'),
              //     backgroundColor: Colors.red));
            }
          },
          child: BlocBuilder<SignInBloc, SignInState>(builder: (context, _) {
            return Column(
              children: [
                // const SizedBox(
                //   height: 40,
                // ),
                topIcon(),
                emailField(),
                const SizedBox(height: 8),
                passwordField(),
                //forgotPasswordText(),
                const SizedBox(
                  height: 10,
                ),
                loginButton(),
                const SizedBox(
                  height: 10,
                ),
                biometricLogin(),
                const SizedBox(height: 25,),
                GestureDetector(
                  onTap: ()
                  {
                    Navigator.push(
                      context,
                      SlideLeftRoute(widget:  const NewLoginWithEmail()),
                    );

                  },
                  child: const Text(
                'Don\'t have an account?',
                  style: TextStyle(
                    color: AppColors.black,
                    fontSize: 14,
                  ),
                ),
                )
              ],
            );
          }),
        ));
  }

  //for ios done button callback
  onPressCallback() {
    removeOverlay();
    FocusScope.of(context).requestFocus(FocusNode());
  }

  //for keyboard done button
  showOverlay(BuildContext context) {
    if (overlayEntry != null) return;
    OverlayState overlayState = Overlay.of(context);
    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          right: 0.0,
          left: 0.0,
          child: InputDoneView(
            onPressCallback: onPressCallback,
            buttonName: "Done",
          ));
    });

    overlayState.insert(overlayEntry!);
  }

  removeOverlay() {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }
  }
}
