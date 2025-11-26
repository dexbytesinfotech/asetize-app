import 'package:asetize/imports.dart';

import '../../otp/pages/otp_verification_screen.dart';


class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({
    Key? key,
  }) : super(key: key);
  @override
  State createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  Map<String, TextEditingController> controllers = {
    'email': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'email': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'email': "",
  };

  String errorMessage = '';
  bool isHeight = true;

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

    bool validateFields({isButtonClicked = false}) {
      if (controllers['email']?.text == null ||
          controllers['email']?.text == '') {
        setState(() {
          if (isButtonClicked) {
            FocusScope.of(context).requestFocus(focusNodes['email']);
            errorMessages['email'] =
                AppString.trans(context, AppString.emailHintError);
          }
        });
        return false;
      } else if (!Validation.validateEmail(controllers['email']?.text ?? '')) {
        setState(() {
          if (isButtonClicked) {
            FocusScope.of(context).requestFocus(focusNodes['email']);
            errorMessages['email'] =
                AppString.trans(context, AppString.emailHintError1);
          }
        });
        return false;
      } else {
        return true;
      }
    }

    emailField() {
      return Container(
        margin: const EdgeInsets.only(left: 22, right: 22, top: 0, bottom: 0),
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
          capitalization: CapitalizationText.sentences,
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
          textInputAction: TextInputAction.done,
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

    Widget topText() {
      return Container(
        margin: const EdgeInsets.only(left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Forgot Password",
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
              "Enter the email address associated with your account to reset your password.",
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

    // continue button
    continueButton() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        child: AppButton(
          buttonName: AppString.trans(context, AppString.continueBt),
          backCallback: () {
            if (validateFields(isButtonClicked: true)) {
              Navigator.push(
                  context,
                  SlideRightRoute(
                    widget: OtpVerificationScreen(
                      email: controllers['email']!.text.trim(),
                    ),
                  ));
            }
          },
        ),
      );
    }

    return ContainerFirst(
      reverse: false,
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: true,
      appBarHeight: 56,
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
          const SizedBox(height: 30),
          emailField(),
          const SizedBox(
            height: 10,
          ),
          continueButton(),
        ],
      ),
    );
  }
}
