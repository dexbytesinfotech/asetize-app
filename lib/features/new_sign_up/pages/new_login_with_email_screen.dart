import 'package:asetize/features/new_sign_up/pages/sign_up_otp_screen.dart';
import 'package:asetize/imports.dart';
import '../../../core/util/app_theme/text_style.dart';
import '../../../core/util/one_signal_notification/one_signal_notification_handler.dart';
import '../../upgrader_widget/upgrader_widget.dart';
import '../bloc/new_signup_bloc.dart';
import '../bloc/new_signup_event.dart';
import '../bloc/new_signup_state.dart';

class NewLoginWithEmail extends StatefulWidget {
  const NewLoginWithEmail({Key? key}) : super(key: key);

  @override
  State createState() => NewLoginWithEmailState();
}

class NewLoginWithEmailState extends State<NewLoginWithEmail> {
  bool isShowLoader = true;
  bool isEmailScreen = false;
  late NewSignupBloc newSignupBloc;

  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  // closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  Map<String, TextEditingController> controllers = {
    'email': TextEditingController(),
    'phoneNumber': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'email': FocusNode(),
    'phoneNumber': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'email': "",
    'phoneNumber': "",
  };
  final RegExp _phoneNumberRegex = RegExp(r'^\d{10}$');

  @override
  void initState() {
    newSignupBloc = BlocProvider.of<NewSignupBloc>(context);
    // controllers['email']!.text = kDebugMode ? "ram@mailinator.com" : "";

    MainAppBloc.dashboardContext = context;
    String? token = OneSignalNotificationsHandler.instance.getToken();
    OneSignalNotificationsHandler.instance
        .setAppContext(MainAppBloc.getDashboardContext);
    projectUtil.deviceInfo();

    super.initState();
  }

  @override
  void dispose() {
    controllers['email']?.dispose();
    controllers['phoneNumber']?.dispose();
    super.dispose();
  }

  // Validate fields when the submit button is clicked
  bool validateFields({bool isButtonClicked = false}) {
    if (isEmailScreen == false) {
      if (controllers['phoneNumber']?.text.length != 10) {
        if (isButtonClicked) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              // FocusScope.of(context).requestFocus(focusNodes['phoneNumber']);
              setState(() {
                errorMessages['phoneNumber'] =
                    AppString.phoneNumberMustBe10Digits;
              });
            }
          });
        }
        return false;
      } else {
        return true;
      }
    } else {
      if (controllers['email']!.text.isEmpty ||
          controllers['email']!.text == '') {
        if (isButtonClicked) {
          errorMessages['email'] =
              AppString.trans(context, AppString.emailHintError);
        }
        return false;
      } else if (!Validation.validateEmail(controllers['email']!.text)) {
        if (isButtonClicked) {
          errorMessages['email'] =
              AppString.trans(context, AppString.emailHintError1);
        }
        return false;
      } else {
        return true;
      }
    }
  }

  void checkEmail(String value, String fieldEmail, {bool onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      setState(() {
        if (Validation.validateEmail(value.trim())) {
          errorMessages[fieldEmail] = ""; // Valid email, clear error
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

  void checkPhoneNumber(String value, String fieldMobile,
      {bool onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (_phoneNumberRegex.hasMatch(value.trim())) {
            errorMessages[fieldMobile] = "";
          } else {
            if (!onchange) {
              errorMessages[fieldMobile] = AppString.phoneNumberMustBe10Digits;
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages[fieldMobile] = AppString.phoneNumberRequired;
          }
        });
      });
    }
  }

  Widget topIcon() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(WorkplaceIcons.appLogoImage,
            width: MediaQuery.of(context).size.shortestSide * 0.62)
      ],
    );
  }

  Widget emailField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: focusNodes['email'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['email'] ?? '',
        // Ensure error message is passed here
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
            padding: const EdgeInsets.only(
              left: 3.0,
              bottom: 10,
              top: 5,
            ),
            child: Text.rich(
              TextSpan(
                text: AppString.pleaseEnterYourEmailAddress,
                // Normal text
                style: appStyles.texFieldPlaceHolderStyle(),
                // Default style for the main text
                children: [
                  TextSpan(
                    text: ' *', // Asterisk
                    style: appStyles
                        .texFieldPlaceHolderStyle()
                        .copyWith(color: Colors.red), // Red color for asterisk
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            )),
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.email,
        hintText: AppString.pleaseEnterYourEmailAddressSmall,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        onTextChange: (value) {
          checkEmail(value, 'email', onchange: true);
        },
        onEndEditing: (value) {
          checkEmail(value, 'email');
          FocusScope.of(context).requestFocus();
        },
      ),
    );
  }

  Widget mobileField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: focusNodes['phoneNumber'],
        isShowBottomErrorMsg: false,
        errorMessages: errorMessages['phoneNumber'] ?? '',
        // Ensure error message is passed here
        controllerT: controllers['phoneNumber'],
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        maxCharLength: 10,
        errorMsgHeight: 24,
        autoFocus: false,
        showError: false,
        capitalization: CapitalizationText.none,
        cursorColor: Colors.grey,
        inputFormatter: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(
              left: 3.0,
              bottom: 10,
              top: 5,
            ),
            child: Text.rich(
              TextSpan(
                text: AppString.pleaseEnterYourPhoneNumber,
                // Normal text
                style: appStyles.texFieldPlaceHolderStyle(),
                // Default style for the main text
                children: [
                  TextSpan(
                    text: ' *', // Asterisk
                    style: appStyles
                        .texFieldPlaceHolderStyle()
                        .copyWith(color: Colors.red), // Red color for asterisk
                  ),
                ],
              ),
              textAlign: TextAlign.start,
            )),
        enabledBorderColor: AppColors.white,
        focusedBorderColor: AppColors.white,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.phone,
        hintText: AppString.enterYourPhoneNumber,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        inputFieldPrefixIcon: CountryCodePicker(
          showFlag: false,
          enabled: false,
          textStyle: appStyles.textFieldTextStyle(),
          padding: const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 10),
          initialSelection: 'IN',
          onChanged: (value) {
            // countryCode = value.dialCode!.trim();
          },
          onInit: (value) {
            // countryCode = value!.dialCode!.trim();
          },
        ),
        onTextChange: (value) {
          checkPhoneNumber(value, 'phoneNumber', onchange: true);
        },
        onEndEditing: (value) {
          checkPhoneNumber(value, 'phoneNumber');
          FocusScope.of(context).requestFocus();
        },
      ),
    );
  }

  Widget divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        color: Colors.transparent,
        child: Row(
          children: [
            const Expanded(
                child: Divider(
              thickness: 0,
            )),
            const SizedBox(
              width: 6,
            ),
            Text(
              AppString.or,
              style: appTextStyle.appSubTitleStyle(
                  color: Colors.black.withOpacity(0.6),
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 6,
            ),
            const Expanded(
                child: Divider(
              thickness: 0,
            )),
          ],
        ),
      ),
    );
  }

  Widget nextButton(state) {
    final isValid = isEmailScreen
        ? Validation.validateEmail(controllers['email']?.text ?? "")
        : controllers['phoneNumber']?.text.length == 10;

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: AppButton(
        buttonName: AppString.sendOtp,
        buttonColor: isValid ? AppColors.textBlueColor : Colors.grey.shade400,
        textStyle: appStyles.buttonTextStyle1(
          texColor: AppColors.white,
        ),
        isLoader: state is SignupLoadingState ? true : false,
        backCallback: () {
          if (validateFields(isButtonClicked: true)) {
            if (isEmailScreen == true) {
              newSignupBloc.add(OnGuestLoginByEmail(
                  guestEmail: controllers['email']!.text.toString(),
                  mContext: context));
            } else {
              newSignupBloc.add(LoginUsingMobileEvent(
                    mobileNumber: controllers['phoneNumber']!.text.toString(),
                  mContext: context,
                  countryCode: "91"));
            }
          }

          closeKeyboard();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewSignupBloc, NewSignupState>(
      bloc: newSignupBloc,
      builder: (context, state) {

    return UpgradeWidget(
      child: AbsorbPointer(
        absorbing: state is SignupLoadingState, // Block interactions when loading
        child: ContainerFirst(
          appBackgroundColor: AppColors.white,
          contextCurrentView: context,
          isSingleChildScrollViewNeed: true,
          isFixedDeviceHeight: false,
          appBarHeight: -1,
          containChild: BlocListener<NewSignupBloc, NewSignupState>(
              listener: (context, state) {
                if (state is GuestSignupDoneState) {
                  Navigator.push(
                    context,
                    SlideLeftRoute(
                        widget:OtpScreen(
                              isEmailScreen: isEmailScreen,
                              state.token,
                              emailID: controllers['email']!.text.toString(),
                            )),
                  );
                }
                if (state is GuestSignupErrorState) {

                  WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
                }
                if (state is LoginUsingMobileDoneState) {
                  String mobileNumber =
                      '+91 ${controllers['phoneNumber']?.text.toString()}';
                  Navigator.push(
                    context,
                    SlideLeftRoute(
                        widget: OtpScreen(
                              isEmailScreen: isEmailScreen,
                              state.token,
                              isSocietyNotFound: true,
                              mobileNumber: mobileNumber,
                            )),
                  );
                }
                if (state is LoginUsingMobileErrorState) {

                  WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
                }
              },
              child: BlocBuilder<NewSignupBloc, NewSignupState>(
                bloc: newSignupBloc,
                builder: (context, state) {
                  return SingleChildScrollView(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            topIcon(),
                            const SizedBox(
                              height: 20,
                            ),
                              Visibility(
                              visible: isEmailScreen == true ? true : false,
                              child: emailField(),
                            ),
                            Visibility(
                              visible: isEmailScreen == true ? false : true,
                              child: mobileField(),
                            ),
                            SizedBox(
                              height: isEmailScreen == false ? 50 : 25,
                            ),
                            nextButton(state),
                            const SizedBox(
                              height: 38,
                            ),
                            divider(),
                            const SizedBox(
                              height: 25,
                            ),
                            InkWell(
                                onTap: () {
                                  FocusScope.of(context).unfocus();
                                  setState(() {
                                    if (isEmailScreen == false) {
                                      isEmailScreen = true;
                                    } else {
                                      isEmailScreen = false;
                                    }
                                  });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 10),
                                  child: Text(
                                    isEmailScreen == true
                                        ? AppString.loginWithNumber
                                        : AppString.loginWithEmail,
                                    style: appStyles.highlightTextStyle(),
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              )),
        ),
      ),
    );
  },
);
  }
}
