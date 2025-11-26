                    import 'package:go_router/go_router.dart';
import 'package:asetize/features/new_sign_up/bloc/new_signup_state.dart';
import '../../../imports.dart';
import '../bloc/new_signup_bloc.dart';
import '../bloc/new_signup_event.dart';
import 'package:asetize/features/new_sign_up/pages/add_home_form.dart';

class CompleteProfileScreen extends StatefulWidget {

  final bool? isSocietyNotFound;

  const CompleteProfileScreen({super.key, this.isSocietyNotFound});

  @override
  State<CompleteProfileScreen> createState() => CompleteProfileScreenState();
}

class CompleteProfileScreenState extends State<CompleteProfileScreen> {
  late NewSignupBloc newSignupBloc;

  final TextEditingController _vehicleTypeController = TextEditingController();
  String countryCode = "";
  String? _vehicleType;
  bool isChecked = false;
  bool isShowLoader = true;
  bool? isEmailScreen;

  Map<String, TextEditingController> controllers = {
    'firstName': TextEditingController(),
    'lastName': TextEditingController(),
    'phoneNumber': TextEditingController(),
    'email': TextEditingController(),
  };

  Map<String, FocusNode> focusNodes = {
    'firstName': FocusNode(),
    'lastName': FocusNode(),
    'phoneNumber': FocusNode(),
    'email': FocusNode(),
  };

  Map<String, String> errorMessages = {
    'firstName': "",
    'lastName': "",
    'phoneNumber': "",
    'email': "",
  };

  final RegExp _phoneNumberRegex = RegExp(r'^\d{10}$');
  final RegExp _nameRegex = RegExp(r'^[a-zA-Z\s]+$');

  closeKeyboard() => FocusScope.of(context).requestFocus(FocusNode());

  void _showBottomSheet(BuildContext context, List<String> options,
      ValueSetter<String> onSelect) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(10.0).copyWith(top: 8, bottom: 7),
          child: ListView.separated(
            itemCount: options.length,
            separatorBuilder: (context, index) => const Divider(
              color: Colors.grey,
              thickness: 0.4,
            ),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(options[index]),
                onTap: () {
                  onSelect(options[index]);
                  errorMessages['propertyType'] = "";
                  Navigator.pop(context);
                },
              );
            },
          ),
        );
      },
    );
  }

  checkFirstName(value, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (_nameRegex.hasMatch(value.trim())) {
            errorMessages['firstName'] = "";
          } else {
            if (!onchange) {
              errorMessages['firstName'] = AppString.invalidFirstName;
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages['firstName'] = AppString.firstNameRequired;
          }
        });
      });
    }
  }

  checkLastName(value, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (_nameRegex.hasMatch(value.trim())) {
            errorMessages['lastName'] = "";
          } else {
            if (!onchange) {
              errorMessages['lastName'] = AppString.invalidLastName;
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages['lastName'] = AppString.lastNameRequired;
          }
        });
      });
    }
  }

  checkPhoneNumber(value, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (_phoneNumberRegex.hasMatch(value.trim())) {
            errorMessages['phoneNumber'] = "";
          } else {
            if (!onchange) {
              errorMessages['phoneNumber'] = AppString.phoneNumberMustBe10Digits;
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages['phoneNumber'] = AppString.phoneNumberRequired;
          }
        });
      });
    }
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

  bool validateFields({isButtonClicked = false}) {
    if (controllers['firstName']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['firstName']);
            setState(() {
              errorMessages['firstName'] = AppString.firstNameRequired;
            });
          }
        });
      }
      return false;
    } else if (controllers['lastName']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['lastName']);
            setState(() {
              errorMessages['lastName'] = AppString.lastNameRequired;
            });
          }
        });
      }
      return false;
    }
    //
    // else if (isEmailScreen == true && controllers['phoneNumber']!.text.length < 10) {
    //   if (isButtonClicked) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       setState(() {
    //         if (_phoneNumberRegex.hasMatch(controllers['phoneNumber']!.text.trim())) {
    //           errorMessages['phoneNumber'] = "";
    //         } else {
    //             errorMessages['phoneNumber'] = AppString.phoneNumberMustBe10Digits;
    //         }
    //       });
    //     });
    //   }
    //   return false;
    // }
    // else if (isEmailScreen == false && Validation.validateEmail(controllers['email']!.text) == false) {
    //   if (isButtonClicked) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       if (mounted) {
    //         FocusScope.of(context).requestFocus(focusNodes['email']);
    //         setState(() {
    //           errorMessages['email'] = AppString.emailIsRequired;
    //         });
    //       }
    //     });
    //   }
    //   return false;
    // }
    //

    else {
      return true;
    }
  }

  Future<void> _loadEmailScreenStatus() async {
    isEmailScreen = await PrefUtils().readBool(WorkplaceNotificationConst.isEmailScreen);
    setState(() {}); // Ensure UI updates when the value is loaded
  }

  @override
  void initState()  {
    newSignupBloc = BlocProvider.of<NewSignupBloc>(context);
    _loadEmailScreenStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget firstNameField() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['firstName'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['firstName']?.toString() ?? '',
          controllerT: controllers['firstName'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 50,
          errorMsgHeight: 24,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.characters,
          cursorColor: Colors.grey,
          placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.firstNameCapital,
                  style: appStyles.texFieldPlaceHolderStyle(),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: appStyles.texFieldPlaceHolderStyle().copyWith(
                          color: Colors.red),
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              )),
          enabledBorderColor: AppColors.white,
          focusedBorderColor: AppColors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.text,
          hintText: AppString.enterFirstName,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            checkFirstName(value, onchange: true);
          },
          onEndEditing: (value) {
            checkFirstName(value);
            FocusScope.of(context).requestFocus(focusNodes['lastName']);
          },
        ),
      );
    }

    Widget lastNameField() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['lastName'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['lastName']?.toString() ?? '',
          controllerT: controllers['lastName'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 50,
          errorMsgHeight: 24,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.characters,
          cursorColor: Colors.grey,
          placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.lastName,
                  style: appStyles.texFieldPlaceHolderStyle(),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: appStyles.texFieldPlaceHolderStyle().copyWith(
                          color: Colors.red),
                    ),
                  ],
                ),
                textAlign: TextAlign.start,
              )
          ),
          enabledBorderColor: AppColors.white,
          focusedBorderColor: AppColors.white,
          backgroundColor: AppColors.white,
          textInputAction: TextInputAction.next,
          borderStyle: BorderStyle.solid,
          inputKeyboardType: InputKeyboardTypeWithError.text,
          hintText: AppString.enterLastName,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            checkLastName(value, onchange: true);
          },
          onEndEditing: (value) {
            checkLastName(value);

            FocusScope.of(context).requestFocus(focusNodes[isEmailScreen == true?'phoneNumber':'email']);
          },
        ),
      );
    }


    //Phone field
    phoneNumber() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['phoneNumber'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['phoneNumber']?.toString() ?? '',
          controllerT: controllers['phoneNumber'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 10,
          errorMsgHeight: 24,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.none,
          cursorColor: Colors.grey,
          inputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
          ],
          placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.signUpPhoneNumber,
                  style: appStyles.texFieldPlaceHolderStyle(),
                  children:  const [
                    // TextSpan(
                    //   text: ' *',
                    //   style: appStyles.texFieldPlaceHolderStyle().copyWith(
                    //       color: Colors.red),
                    // ),
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
          hintText: AppString.enterPhoneNumber,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          inputFieldPrefixIcon: CountryCodePicker(
              showFlag : false,
            enabled: false,
            textStyle: appStyles.textFieldTextStyle(),
            padding: const EdgeInsets.only(
                left:  0,
                top: 0,
                bottom: 0,
                right:10
            ),
            initialSelection: 'IN',
            onChanged: (value) {
             // countryCode = value.dialCode!.trim();
            },
            onInit: (value) {
              countryCode = value!.dialCode!.trim();
            },
          ),
          onTextChange: (value) {
            checkPhoneNumber(value, onchange: true);
          },
          onEndEditing: (value) {
            checkPhoneNumber(value);
            FocusScope.of(context).unfocus();
          },
        ),
      );
    }

    Widget emailField() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          focusNode: focusNodes['email'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['email'] ?? '', // Ensure error message is passed here
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
                  text: AppString.pleaseEnterYourEmailAddress, // Normal text
                  style: appStyles
                      .texFieldPlaceHolderStyle(), // Default style for the main text
                  children:  const [
                    // TextSpan(
                    //   text: ' *', // Asterisk
                    //   style: appStyles
                    //       .texFieldPlaceHolderStyle()
                    //       .copyWith(color: Colors.red), // Red color for asterisk
                    // ),
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

    Widget submitButton(state) {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: AppButton(
          buttonName: AppString.submitButton,
          buttonColor: (validateFields())
              ? AppColors.textBlueColor
              : Colors.grey,
          textStyle: appStyles.buttonTextStyle1(
            texColor: AppColors.white,
          ),
          isLoader: state is SignupLoadingState? true: false,
          backCallback: () {
            if (validateFields(isButtonClicked: true)) {

              newSignupBloc.add(OnGuestProfileUpdateEvent(
                firstName: controllers['firstName']!.text.toString(),
                lastName: controllers['lastName']!.text.toString(),
                phone:  controllers['phoneNumber']!.text.toString(),
                guestEmail:  controllers['email']!.text.toString(),
                mContext: context,
              ));

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => AddHomeForm()),
              // );
            }
          },
        ),
      );
    }


    exitConfirmationPopup(){
      return   WorkplaceWidgets.showRequestDialog(
        context: context,
        title:
        AppString.exit ?? AppString.approveRequestTitle,
        content: AppString.leaveThePage,
        buttonName1:
        AppString.buttonConfirm ?? AppString.confirmButton,

        // maxLine: 1,
        hintText: AppString.enterReceiptNumber,
        buttonName2: AppString.cancelButton,
        unableButtonColor: AppColors.appBlueColor,
        disableButtonColor: Colors.green.withOpacity(0.5),
        onPressedButton1: () async {
          // Handle Confirm action
          await PrefUtils().clearAll();
          Navigator.pop(context);
          Navigator.pop(context);
        },
        onPressedButton2: () {
          Navigator.of(context).pop();
        },
        // textController: receiptNumberTextController
      );
    }

    return ContainerFirst(
      contextCurrentView: context,
      isSingleChildScrollViewNeed: true,
      isFixedDeviceHeight: true,
      isListScrollingNeed: true,
      isOverLayStatusBar: false,
      bottomSafeArea: true,
      appBarHeight: 56,
      appBar: CommonAppBar(
        title: AppString.completeProfile,
        icon: WorkplaceIcons.backArrow,
        onLeftIconClickCallBack: () {
          exitConfirmationPopup();
        },
      ),


      containChild: BlocListener<NewSignupBloc, NewSignupState>(
        listener: (context, state) {
          if (state is GuestProfileUpdateErrorState) {

            WorkplaceWidgets.errorSnackBar(context, state.errorMessage);
          }
          if (state is GuestProfileUpdateDoneState) {
            if (state.companyIdSaved == true) {
              context.go('/dashBoard');
            } else{
              print(widget.isSocietyNotFound);
              Navigator.push(
                context,
                SlideLeftRoute(
                  widget: SearchYourSocietyForm(
                    isSocietyNotFound: widget.isSocietyNotFound
                  ),
                ),
              );
            };

            // Fluttertoast.showToast(
            //   backgroundColor: Colors.green.shade500,
            //   msg: AppString.otpVerifiedSuccessfully,
            // );

            return;
          }

          // if (state is GuestProfileUpdateDoneState) {
          //   Fluttertoast.showToast(
          //       backgroundColor: Colors.green.shade500,
          //       msg: AppString.newSignUp);
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (context) => SignupSuccessScreen()),
          //   );
          // }
        },
        child: BlocBuilder<NewSignupBloc, NewSignupState>(
          bloc: newSignupBloc,
          builder: (context, state) {
            return SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      firstNameField(),
                      const SizedBox(height: 8),
                      lastNameField(),
                      const SizedBox(height: 8),
                      if (isEmailScreen ?? false)
                        phoneNumber(),
                      if (isEmailScreen == false)
                        emailField(),
                      const SizedBox(height: 8),
                      submitButton(state),
                      const SizedBox(height: 20),
                    ],
                  ),
                  // if (state is SignupLoadingState)
                  //   Center(
                  //     child: WorkplaceWidgets.progressLoader(context),
                  //   ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}