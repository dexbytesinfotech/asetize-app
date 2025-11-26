import 'package:asetize/imports.dart';
import '../../../core/util/app_theme/text_style.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final double _leftRightMargin = 24;

  GlobalKey key = GlobalKey(); // declare a global key

  Map<String, TextEditingController> controllers = {
    'new_password': TextEditingController(),
    'confirm_password': TextEditingController(),
    'old_password': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'new_password': FocusNode(),
    'confirm_password': FocusNode(),
    'old_password': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'new_password': "",
    'confirm_password': "",
    'old_password': "",
  };
  Color color = Colors.green;
  bool hideCurrentPassword = true;
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;

  void togglePasswordVisibility() =>
      setState(() => hideCurrentPassword = !hideCurrentPassword);

  void togglePasswordVisibility1() =>
      setState(() => hideNewPassword = !hideNewPassword);

  void togglePasswordVisibility2() =>
      setState(() => hideConfirmPassword = !hideConfirmPassword);
  late UserProfileBloc bloc;
  @override
  void initState() {
    bloc = BlocProvider.of<UserProfileBloc>(context);
    controllers['old_password']?.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    controllers['old_password']?.dispose();
    super.dispose();
  }

  String phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    AppDimens().appDimensFind(context: context);

    bool validateFields({isButtonClicked = false}) {
      if (controllers['old_password']?.text.trim() == null ||
          controllers['old_password']?.text.trim() == '') {
        setState(() {
          if (isButtonClicked) {
            errorMessages['old_password'] =
                AppString.trans(context, AppString.pleaseEnterCurrentPassword);
          }
        });
        return false;
      } else if (controllers['new_password']?.text.trim() == null ||
          controllers['new_password']?.text.trim() == '') {
        setState(() {
          if (isButtonClicked) {
            errorMessages['new_password'] =
                AppString.trans(context, AppString.pleaseEnterNewPassword);
          }
        });
        return false;
      } else if (controllers['confirm_password']?.text.trim() == null ||
          controllers['confirm_password']?.text.trim() == '') {
        setState(() {
          if (isButtonClicked) {
            errorMessages['confirm_password'] =
                AppString.trans(context, AppString.pleaseReEnterPassword);
          }
        });
        return false;
      } else if (controllers['new_password']?.text.trim() !=
          controllers['confirm_password']?.text.trim()) {
        setState(() {
          if (isButtonClicked) {
            errorMessages['new_password'] =
                AppString.trans(context, AppString.enterValidEmail);
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
          if (value.length >= 8) {
            errorMessages['new_password'] = "";
            errorMessages['confirm_password'] = "";
            errorMessages['old_password'] = "";
            if (Validation.isNotEmpty(controllers[fieldName]!.text.trim())) {
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
                errorMessages[fieldName] =
                    AppString.trans(context, AppString.invalidCurrentPassword);
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
            if (fieldName == 'old_password') {
              errorMessages[fieldName] = AppString.trans(
                  context, AppString.pleaseEnterCurrentPassword);
            }
            if (fieldName == 'new_password') {
              errorMessages[fieldName] =
                  AppString.trans(context, AppString.pleaseEnterNewPassword);
            } else if (fieldName == 'confirm_password') {
              errorMessages[fieldName] =
                  AppString.trans(context, AppString.pleaseEnterNewCPassword);
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
              errorMessages[fieldName] =
                  AppString.trans(context, AppString.pleaseEnterNewCPassword);
            }
          }
        });
      }
    }

    bottomButton() {
      return Container(
        margin: const EdgeInsets.only(
          left: 22,
          right: 22,
        ),
        child: AppButton(
          buttonName: AppString.trans(context, AppString.buttonUpdate),
          backCallback: () {
            if (validateFields(isButtonClicked: true)) {
              bloc.add(ChangePasswordEvent(
                  oldPassword: controllers['old_password']!.text.trim(),
                  newPassword: controllers['new_password']!.text.trim(),
                  confirmPassword: controllers['confirm_password']!.text.trim(),
                  mContext: context));
            }
          },
        ),
      );
    }

    //Visibility icons
    Widget visibilityOffIcon = const Icon(
      Icons.visibility_off,
      color: AppColors.grey,
      size: 20,
    );
    Widget visibilityOnIcon = const Icon(
      Icons.visibility,
      color: AppColors.grey,
      size: 20,
    );

    //old Password Field
    oldPasswordField() {
      return Container(
        padding: EdgeInsets.only(
          right: _leftRightMargin,
          left: _leftRightMargin,
          top: 30,
          bottom: 8,
        ),
        width: AppDimens().widthFullScreen(),
        child: CommonTextFieldWithError(
          focusNode: focusNodes['old_password'],
          showError: true,
          errorText: errorMessages['old_password']?.toString() ?? '',
          errorMessages: errorMessages['old_password']?.toString() ?? '',
          controllerT: controllers['old_password'],
          borderRadius: 8,
          inputHeight: 50,
          //maxCharLength: 15,
          errorMsgHeight: 30,
          autoFocus: false,
          errorLeftRightMargin: 0,
          capitalization: CapitalizationText.sentences,
          cursorColor: Colors.grey,
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 6.0, bottom: 3),
            child: Text("Old Password",
                textAlign: TextAlign.start,
                style: appStyles.texFieldPlaceHolderStyle()),
          ),
          enabledBorderColor: AppColors.textFiledBorderColor,
          focusedBorderColor: AppColors.textFiledBorderColor,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.password,
          obscureText: hideCurrentPassword,
          hintText: AppString.trans(context, AppString.currentPassword),
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          inputFieldSuffixIcon: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              icon: hideCurrentPassword ? visibilityOffIcon : visibilityOnIcon,
              onPressed: togglePasswordVisibility,
            ),
          ),
          onTextChange: (value) {
            checkPassword(value, 'old_password', onchange: false);
          },
          isShowBottomErrorMsg: true,
          // errorMessages: errorMessages['old_password'],
          onEndEditing: (value) {
            checkPassword(value, 'old_password');
            FocusScope.of(context).requestFocus(focusNodes['new_password']);
          },
        ),
      );
    }

    //new Password Field
    newPasswordField() {
      return Container(
        padding: EdgeInsets.only(
            right: _leftRightMargin, left: _leftRightMargin, top: 5, bottom: 8),
        width: AppDimens().widthFullScreen(),
        child: CommonTextFieldWithError(
          focusNode: focusNodes['new_password'],
          showError: true,
          //maxCharLength: 12,
          errorText: errorMessages['new_password']?.toString() ?? '',
          errorMessages: errorMessages['new_password']?.toString() ?? '',
          controllerT: controllers['new_password'],
          borderRadius: 8,
          inputHeight: 50,
          errorMsgHeight: 31,
          autoFocus: false,
          errorLeftRightMargin: 0,
          capitalization: CapitalizationText.sentences,
          cursorColor: Colors.grey,
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 6.0, bottom: 3),
            child: Text("New Password",
                textAlign: TextAlign.start,
                style: appStyles.texFieldPlaceHolderStyle()),
          ),
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
            padding: const EdgeInsets.only(right: 6),
            child: IconButton(
              icon: hideNewPassword ? visibilityOffIcon : visibilityOnIcon,
              onPressed: togglePasswordVisibility1,
            ),
          ),
          onTextChange: (value) {
            checkPassword(value, 'new_password');
          },
          onEndEditing: (value) {
            checkPassword(value, 'new_password');
            FocusScope.of(context).requestFocus(focusNodes['confirm_password']);
          },
          isShowBottomErrorMsg: true,
        ),
      );
    }

    //Confirm password field
    confirmPasswordField() {
      return Container(
        padding: EdgeInsets.only(
          right: _leftRightMargin,
          left: _leftRightMargin,
        ),
        width: AppDimens().widthFullScreen(),
        child: CommonTextFieldWithError(
          focusNode: focusNodes['confirm_password'],
          showError: true,
          //maxCharLength: 12,
          errorText: errorMessages['confirm_password']?.toString() ?? '',
          errorMessages: errorMessages['confirm_password']?.toString() ?? '',
          controllerT: controllers['confirm_password'],
          borderRadius: 8,
          inputHeight: 50,
          errorMsgHeight: 24,
          autoFocus: false,
          errorLeftRightMargin: 0,
          capitalization: CapitalizationText.sentences,
          cursorColor: Colors.grey,
          placeHolderTextWidget: Padding(
            padding: const EdgeInsets.only(left: 6.0, bottom: 3),
            child: Text("Confirm Password",
                textAlign: TextAlign.start,
                style: appStyles.texFieldPlaceHolderStyle()),
          ),
          enabledBorderColor: AppColors.textFiledBorderColor,
          focusedBorderColor: AppColors.textFiledBorderColor,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.done,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.password,
          obscureText: hideConfirmPassword,
          inputFieldSuffixIcon: Padding(
            padding: const EdgeInsets.only(right: 5.5),
            child: IconButton(
              icon: hideConfirmPassword ? visibilityOffIcon : visibilityOnIcon,
              onPressed: togglePasswordVisibility2,
            ),
          ),
          hintText: AppString.trans(context, AppString.confirmPasswordName),
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

    //Return main Ui view
    return BlocConsumer<UserProfileBloc, UserProfileState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is ChangePasswordState) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    contentPadding: const EdgeInsets.symmetric(vertical: 25),
                    content:  Text(
                      AppString.passwordUpdated,
                      textAlign: TextAlign.center,
                      style: appTextStyle.appNormalSmallTextStyle(),
                    ),
                    contentTextStyle: appStyles.subTitleStyle(
                      fontSize: AppDimens().fontSize(value: 16),
                      fontWeight: FontWeight.w200,
                      texColor: AppColors.black,
                      fontFamily: AppFonts().defaultFont,
                    ),
                    actionsPadding: const EdgeInsets.only(bottom: 20),
                    actions: [
                      GestureDetector(
                        onTap: () {
                          //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>const ProfileSettingsScreen()));
                          Navigator.of(context)
                            ..pop()
                            ..pop();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                color: AppColors.appBlue,
                              ),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Text(
                                  AppString.ok,
                                  style: appStyles.subTitleStyle(
                                    fontSize: AppDimens().fontSize(value: 15),
                                    fontWeight: FontWeight.w500,
                                    texColor: AppColors.appWhite,
                                    fontFamily: AppFonts().defaultFont,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ));
        }
        if (state is ChangePasswordErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('${state.errorMessage}')));
        }
      },
      builder: (context, state) {
        return ContainerFirst(
            reverse: false,
            contextCurrentView: context,
            isSingleChildScrollViewNeed: false,
            isFixedDeviceHeight: false,
            appBarHeight: 55.sp,
            appBar: const CommonAppBar(
              title: AppString.changePasswordTitle,
            ),
            containChild: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    oldPasswordField(),
                    const SizedBox(
                      height: 5,
                    ),
                    newPasswordField(),
                    confirmPasswordField(),
                    const SizedBox(
                      height: 20,
                    ),
                    bottomButton(),
                  ],
                ),
                if (state is UserProfileLoading)
                  WorkplaceWidgets.progressLoader(context),
              ],
            ));
      },
    );
  }
}
