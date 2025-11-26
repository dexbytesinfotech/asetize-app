import '../../../imports.dart';
import '../bloc/sign_up_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late SignUpBloc bloc;
  Map<String, TextEditingController> controllers = {
    'email': TextEditingController(),
    'name': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'email': FocusNode(),
    'name': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'email': "",
    'name': "",
  };
  
  Widget emailField() {
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
          child: Text("Email*",
              textAlign: TextAlign.start,
              style: appStyles.texFieldPlaceHolderStyle()),
        ),
        enabledBorderColor: AppColors.textFiledBorderColor,
        focusedBorderColor: AppColors.textFiledBorderColor,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.done,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.email,
        hintText: "Enter your email *",
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
          FocusScope.of(context).requestFocus();
         // FocusScope.of(context).requestFocus(focusNodes['name']);
        },
      ),
    );
  }


  Widget nameField() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
      width: MediaQuery.of(context).size.width,
      child: CommonTextFieldWithError(
        focusNode: focusNodes['name'],
        isShowBottomErrorMsg: true,
        errorMessages: errorMessages['name']?.toString() ?? '',
        controllerT: controllers['name'],
        borderRadius: 8,
        inputHeight: 50,
        errorLeftRightMargin: 0,
        maxCharLength: 50,
        errorMsgHeight: 24,
        autoFocus: false,
        showError: true,
        capitalization: CapitalizationText.none,
        cursorColor: Colors.grey,
        inputFormatter: [
          FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
        ],
        placeHolderTextWidget: Padding(
          padding: const EdgeInsets.only(left: 6.0, bottom: 3),
          child: Text("Full Name*",
              textAlign: TextAlign.start,
              style: appStyles.texFieldPlaceHolderStyle()),
        ),
        enabledBorderColor: AppColors.textFiledBorderColor,
        focusedBorderColor: AppColors.textFiledBorderColor,
        backgroundColor: AppColors.white,
        textInputAction: TextInputAction.next,
        borderStyle: BorderStyle.solid,
        inputKeyboardType: InputKeyboardTypeWithError.email,
        hintText: "Enter your full Name *" ,
        hintStyle: appStyles.hintTextStyle(),
        textStyle: appStyles.textFieldTextStyle(),
        inputFieldSuffixIcon: Padding(
          padding: const EdgeInsets.only(right: 18, left: 10),
          child: WorkplaceIcons.iconImage(
              imageUrl: WorkplaceIcons.personIcon,
              imageColor: controllers['name']!.text.isEmpty
                  ? const Color(0xFF575757)
                  : AppColors.textBlueColor),
        ),
        contentPadding: const EdgeInsets.only(left: 15, right: 15),
        onTextChange: (value) {
          checkName(value, 'name', onchange: true);
        },
        onEndEditing: (value) {
          checkName(value, 'name');
          //FocusScope.of(context).requestFocus();
          FocusScope.of(context).requestFocus(focusNodes['email']);
        },
      ),
    );
  }

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

  checkName(value, name, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      setState(() {
        if (Validation.isNotEmpty(value.trim())) {
          errorMessages[name] = "";
        } else {
          if (!onchange) {
            errorMessages[name] = AppString.trans(context, AppString.nameError);
          }
        }
      });
    } else {
      setState(() {
        if (!onchange) {
          if (name == 'name') {
            errorMessages[name] =
                AppString.trans(context, AppString.nameError);
          }
        }
      });
    }
  }

  bool validateFields({isButtonClicked = false}) {
    if (controllers['name']?.text == null ||
    controllers['name']?.text == '') {
    setState(() {
    if (isButtonClicked) {
    FocusScope.of(context).requestFocus(focusNodes['reason']);
    errorMessages['name'] = AppString.nameError;
    }
    });
    return false;
    }else if (controllers['email']!.text.isEmpty || controllers['email']!.text == '') {
      setState(() {
        if (isButtonClicked) {
          errorMessages['email'] = AppString.trans(context, AppString.emailHintError);
        }
      });
      return false;
    } else if (!Validation.validateEmail(controllers['email']!.text)) {
      setState(() {
        if (isButtonClicked) {
          errorMessages['email'] = AppString.trans(context, AppString.emailHintError1);
        }
      });
      return false;
    } else {
      return true;
    }
  }

  // login button
  submitButton() {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: AppButton(
        buttonName: 'Next',
        buttonColor: AppColors.textBlueColor,
        buttonBorderColor: AppColors.textBlueColor,
        textStyle: appStyles.buttonTextStyle1(
          texColor: AppColors.white,
        ),
        backCallback: () {
          String email = controllers['email']!.text.trim();
          String name = controllers['name']!.text.trim();
         // Navigator.push(context, MaterialPageRoute(builder: (context) =>  OtpVerificationScreen(email: email )));
          if (validateFields(isButtonClicked: true)) {
            bloc.add(SignUpUserEvent(email: email, name: name, context: context));
          }
        },
      ),
    );
  }

  @override
  void initState() {
   bloc = BlocProvider.of<SignUpBloc>(context);
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    controllers['email']?.dispose();
    controllers['name']?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: true,
        isFixedDeviceHeight: true,
        isListScrollingNeed: false,
        statusBarColor: AppColors.white,
        appBarHeight: 50,
        appBar: const DetailsScreenAppBar(
          title: 'Guest login',
        ),
        containChild: BlocConsumer<SignUpBloc,SignUpState >(
           bloc: bloc,
          listener:  (BuildContext context, state) {

          },
          builder: (BuildContext context, state) {
            return Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 40,),
                    nameField(),
                    const SizedBox(height: 8),
                    emailField(),
                    const SizedBox(height: 8,
                    ),
                    submitButton()
                  ],
                ),
                if(state is SignUpLoadingState) WorkplaceWidgets.progressLoader(context)

              ],
            );
          },
        )
    );
  }
}
