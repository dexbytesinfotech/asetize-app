import 'package:asetize/imports.dart';

import '../../login/pages/sign_in_new_screen.dart';
import '../../new_sign_up/pages/new_login_with_email_screen.dart';

class NewPasswordScreen extends StatefulWidget {
  final String userName;
  final bool isArabic;
  const NewPasswordScreen(
      {Key? key, this.userName = "Hamid Gul", this.isArabic = false})
      : super(key: key);

  @override
  State createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  late bool isLeftTextAlign;

  double opacity = 1.0;

  GlobalKey key = GlobalKey(); // declare a global key

  Map<String, TextEditingController> controllers = {
    'new_password': TextEditingController(),
    'confirm_password': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'new_password': FocusNode(),
    'confirm_password': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'new_password': "",
    'confirm_password': "",
  };
  Color color = Colors.green;
  bool hideCurrentPassword = true;
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;
  String phoneNumber = '';

  void togglePasswordVisibility() =>
      setState(() => hideCurrentPassword = !hideCurrentPassword);

  void togglePasswordVisibility1() =>
      setState(() => hideNewPassword = !hideNewPassword);

  void togglePasswordVisibility2() =>
      setState(() => hideConfirmPassword = !hideConfirmPassword);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AppDimens().appDimensFind(context: context);

    bool validateFields({isButtonClicked = false}) {
      if (controllers['new_password']?.text.trim() == null ||
          controllers['new_password']?.text.trim() == '') {
        setState(() {
          if (isButtonClicked) {
            errorMessages['new_password'] =
                AppString.trans(context, AppString.pleaseEnterNewPassword);
          }
        });
        return false;
      }
      /*else if (controllers['new_password'].text.trim().length < 6) {
        setState(() {
          if (isButtonClicked) {
            errorMessages['new_password'] =
                AppString.trans(context, AppString.passwordLength);
          }
        });
        return false;
      }*/
      else if (!Validation.onlyNumberAndCharacter(
          controllers['new_password']!.text.trim())) {
        setState(() {
          if (isButtonClicked) {
            errorMessages['new_password'] =
                AppString.trans(context, AppString.mustContain1LetterAndNumber);
          }
        });
        return false;
      } else if (controllers['confirm_password']?.text.trim() == null ||
          controllers['confirm_password']?.text.trim() == '') {
        setState(() {
          if (isButtonClicked) {
            errorMessages['confirm_password'] = AppString.trans(
                context, AppString.pleaseReEnterConfirmPassword);
          }
        });
        return false;
      } else {
        return true;
      }
    }

    //Check password on change
    checkPassword(value, fieldName, {onchange = false}) {
      if (Validation.isNotEmpty(value)) {
        setState(() {
          if (value.length >= 6) {
            errorMessages['new_password'] = "";
            errorMessages['confirm_password'] = "";
            if (Validation.onlyNumberAndCharacter(
                controllers[fieldName]!.text.trim())) {
              if ((controllers['confirm_password']?.text != null &&
                      controllers['confirm_password']?.text != "") &&
                  controllers['new_password']?.text !=
                      controllers['confirm_password']?.text) {
                errorMessages['confirm_password'] =
                    "Password and confirm password must be same";
              } else {
                errorMessages['new_password'] = "";
                errorMessages['confirm_password'] = "";
              }
            } else {
              if (!onchange) {
                errorMessages[fieldName] = AppString.trans(
                    context, AppString.mustContain1LetterAndNumber);
              }
            }
          } else {
            if (!onchange) {
              errorMessages[fieldName] = AppString.trans(
                  context, AppString.mustContain1LetterAndNumber);
            }
          }
        });
      } else {
        setState(() {
          if (!onchange) {
            if (fieldName == 'new_password') {
              errorMessages[fieldName] =
                  AppString.trans(context, AppString.pleaseEnterNewPassword);
            } else if (fieldName == 'confirm_password') {
              errorMessages[fieldName] = AppString.trans(
                  context, AppString.pleaseReEnterConfirmPassword);
            }
          }
        });
      }
    }

    //Check confirm password on change
    checkConfirmPassword(value, fieldName, {onchange = false}) {
      if (Validation.isNotEmpty(value)) {
        setState(() {
          if ((controllers['confirm_password']?.text != null &&
                  controllers['confirm_password']?.text != "") &&
              controllers['new_password']?.text !=
                  controllers['confirm_password']?.text) {
            errorMessages[fieldName] =
                AppString.trans(context, AppString.passwordMustBeSame);
          } else {
            errorMessages[fieldName] = "";
          }
        });
      } else {
        setState(() {
          if (!onchange) {
            if (fieldName == 'confirm_password') {
              errorMessages[fieldName] = AppString.trans(
                  context, AppString.pleaseReEnterConfirmPassword);
            }
          }
        });
      }
    }

    // Ok button widget
    bottomButton() {
      return Container(
        margin: const EdgeInsets.only(
          left: 18,
          right: 18,
        ),
        child: AppButton(
          buttonName: AppString.trans(context, AppString.continueBt),
          backCallback: () {
            if (validateFields(isButtonClicked: true)) {
              Navigator.pushAndRemoveUntil(context,
                  FadeRoute(widget: const NewLoginWithEmail()
              ), (route) => false);


            }
          },
        ),
      );
    }

    Widget visibilityOffIcon = const Icon(
      Icons.visibility_off,
      color: Color(0xFF575757),
      size: 23,
    );

    Widget visibilityOnIcon = const Icon(
      Icons.visibility,
      color: Color(0xFF575757),
      size: 23,
    );

    //new Password Field
    newPasswordField() {
      return Container(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 35, bottom: 5),
        width: AppDimens().widthFullScreen(),
        child: CommonTextFieldWithError(
          focusNode: focusNodes['new_password'],
          showError: true,
          errorText: errorMessages['new_password']?.toString() ?? '',
          errorMessages: errorMessages['new_password']?.toString() ?? '',
          controllerT: controllers['new_password'],
          borderRadius: 8,
          inputHeight: 50,
          errorMsgHeight: 24,
          autoFocus: true,
          errorLeftRightMargin: 0,
          capitalization: CapitalizationText.sentences,
          cursorColor: Colors.grey,
          enabledBorderColor: AppColors.textFiledBorderColor,
          focusedBorderColor: AppColors.textFiledBorderColor,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.password,
          obscureText: hideNewPassword,
          hintText: AppString.trans(context, AppString.newPassword),
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          inputFieldSuffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: hideNewPassword ? visibilityOffIcon : visibilityOnIcon,
              onPressed: togglePasswordVisibility1,
            ),
          ),
          onTextChange: (value) {
            checkPassword(value, 'new_password', onchange: true);
          },
          onEndEditing: (value) {
            checkPassword(value, 'new_password');
            FocusScope.of(context).requestFocus(focusNodes['confirm_password']);
          },
          isShowBottomErrorMsg: true,
          // errorMessages: errorMessages['new_password'],
        ),
      );
    }

    //Confirm password field
    confirmPasswordField() {
      return Container(
        padding: const EdgeInsets.only(left: 18, right: 18),
        width: AppDimens().widthFullScreen(),
        child: CommonTextFieldWithError(
          focusNode: focusNodes['confirm_password'],
          showError: true,
          errorText: errorMessages['confirm_password']?.toString() ?? '',
          errorMessages: errorMessages['confirm_password']?.toString() ?? '',
          controllerT: controllers['confirm_password'],
          borderRadius: 8,
          inputHeight: 50,
          errorMsgHeight: 24,
          autoFocus: true,
          errorLeftRightMargin: 0,
          capitalization: CapitalizationText.sentences,
          cursorColor: Colors.grey,
          enabledBorderColor: AppColors.textFiledBorderColor,
          focusedBorderColor: AppColors.textFiledBorderColor,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.done,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.password,
          obscureText: hideConfirmPassword,
          inputFieldSuffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: hideConfirmPassword ? visibilityOffIcon : visibilityOnIcon,
              onPressed: togglePasswordVisibility2,
            ),
          ),
          hintText: AppString.trans(context, AppString.confirmPassword),
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            checkConfirmPassword(value, 'confirm_password', onchange: true);
          },
          onEndEditing: (value) {
            checkConfirmPassword(value, 'confirm_password');
            // FocusScope.of(context).requestFocus(focusNodes[bottomButton]);
          },
          isShowBottomErrorMsg: true,
          // errorMessages: errorMessages['confirm_password'],
        ),
      );
    }

    //Background view

    Widget topText() {
      return Container(
        margin: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "New Password",
              textAlign: TextAlign.center,
              style: appStyles.onBoardingTitleStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                texColor: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Create a new password for your account",
              textAlign: TextAlign.start,
              style: appStyles.onBoardingTitleStyle(
                fontSize: 16,
                height: 1.3,
                fontWeight: FontWeight.w400,
                texColor: Colors.grey.shade500,
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
      appBarHeight: 50,
      appBar: const CommonAppBar(
        title: "",
        icon: WorkplaceIcons.backArrow,
      ),
      containChild: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          topText(),
          newPasswordField(),
          confirmPasswordField(),
          const SizedBox(height: 25),
          bottomButton(),
        ],
      ),
    );
  }
}
