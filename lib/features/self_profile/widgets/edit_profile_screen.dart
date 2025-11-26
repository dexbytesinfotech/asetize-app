import '../../../imports.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late UserProfileBloc userProfileBloc;
   String? email;
   String? phoneNumber;
   String? firstName;
   String? lastName;

  final RegExp _phoneNumberRegex = RegExp(r'^\d{10}$');
  final RegExp _nameRegex = RegExp(r'^[a-zA-Z\s]+$');

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

  @override
  void initState() {
    userProfileBloc = BlocProvider.of<UserProfileBloc>(context);
    if (userProfileBloc.user.firstName?.isNotEmpty == true) {
      controllers['firstName']?.text = userProfileBloc.user.firstName ?? "";
      firstName = userProfileBloc.user.firstName ?? "";
    }
    if (userProfileBloc.user.lastName?.isNotEmpty == true) {
      controllers['lastName']?.text = userProfileBloc.user.lastName ?? "";
      lastName = userProfileBloc.user.lastName ?? "";
    }
    if (userProfileBloc.user.phone?.isNotEmpty == true) {
      controllers['phoneNumber']?.text = userProfileBloc.user.phone ?? "";
      phoneNumber = userProfileBloc.user.phone ?? "";
    }
    if (userProfileBloc.user.email?.isNotEmpty == true) {
      controllers['email']?.text = userProfileBloc.user.email ?? "";
      email = userProfileBloc.user.email ?? "";
    }
    super.initState();
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
            errorMessages['firstName'] = AppString.pleaseEnterYourFirstName;
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
            errorMessages['lastName'] = AppString.pleaseEnterYourLastName;
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
              errorMessages['phoneNumber'] =
                  AppString.phoneNumberMustBe10Digits;
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages['phoneNumber'] =
                AppString.pleaseEnterYoursPhoneNumber;
          }
        });
      });
    }
  }

  checkEmail(value, fieldEmail, {onchange = false}) {
    if (Validation.isNotEmpty(value.trim())) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (Validation.validateEmail(value.trim())) {
            errorMessages['email'] = "";
          } else {
            if (!onchange) {
              errorMessages['email'] = AppString.emailHintError;
            }
          }
        });
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          if (!onchange) {
            errorMessages['email'] = AppString.pleaseEnterYoursEmailAddress;
          }
        });
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
              errorMessages['firstName'] = AppString.pleaseEnterYourFirstName;
            });
          }
        });
      }
      return false;
    }
    else if (controllers['lastName']?.text.isEmpty ?? true) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['lastName']);
            setState(() {
              errorMessages['lastName'] = AppString.pleaseEnterYourLastName;
            });
          }
        });
      }
      return false;
    }
    else if (controllers['phoneNumber']!.text.length < 10) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            if (_phoneNumberRegex
                .hasMatch(controllers['phoneNumber']!.text.trim())) {
              errorMessages['phoneNumber'] = "";
            } else {
              errorMessages['phoneNumber'] =
                  AppString.phoneNumberMustBe10Digits;
            }
          });
        });
      }
      return false;
    } else if (Validation.validateEmail(controllers['email']!.text) == false) {
      if (isButtonClicked) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            FocusScope.of(context).requestFocus(focusNodes['email']);
            setState(() {
              errorMessages['email'] = AppString.emailHintError;
            });
          }
        });
      }
      return false;
    }
    // else if(controllers['firstName']?.text == firstName || controllers['lastName']?.text == lastName)
    // {
    //   return false;
    // }
    // else if (controllers['firstName']?.text.trim() == firstName?.trim()) {
    //   return false;
    // }
    // else if (controllers['lastName']?.text.trim() == lastName?.trim()) {
    //   return false;
    // }
    else if (controllers['firstName']?.text.trim() == firstName?.trim() && controllers['lastName']?.text.trim() == lastName?.trim()) {
      return false;
    }
    else {
      return true;
    }
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
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.characters,
          cursorColor: Colors.grey,
          // inputFormatter: [
          //   FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z]+$')), // Allow only alphabets
          // ],
          placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.firstNameCapital,
                  style: appStyles.texFieldPlaceHolderStyle(),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: appStyles
                          .texFieldPlaceHolderStyle()
                          .copyWith(color: Colors.red),
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
          hintText: AppString.enterYourFirstName,
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
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.characters,
          cursorColor: Colors.grey,
          // inputFormatter: [
          //   FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z]+$')), // Allow only alphabets
          // ],
          placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.lastName,
                  style: appStyles.texFieldPlaceHolderStyle(),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: appStyles
                          .texFieldPlaceHolderStyle()
                          .copyWith(color: Colors.red),
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
          hintText: AppString.enterYourLastName,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          onTextChange: (value) {
            checkLastName(value, onchange: true);
          },
          onEndEditing: (value) {
            checkLastName(value);
            FocusScope.of(context).requestFocus(focusNodes['phoneNumber']);
          },
        ),
      );
    }

    phoneNumberField() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
        width: MediaQuery.of(context).size.width,
        child: CommonTextFieldWithError(
          onTapCallBack: ()
          {
            if (phoneNumber != null ) {
              WorkplaceWidgets.errorPopUp(
                              context: context,
                              content: AppString.updatePhoneNumberMsg,
                              onTap: () {
                                Navigator.of(context).pop();
                              });
            }
          },
          focusNode: focusNodes['phoneNumber'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['phoneNumber']?.toString() ?? '',
        //  readOnly: controllers['phoneNumber']?.text.isEmpty == true ? false : true,
          readOnly : phoneNumber != null ? true : false,
          controllerT: controllers['phoneNumber'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 10,
          errorMsgHeight: 20,
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
                  children: [
                    TextSpan(
                      text: ' *',
                      style: appStyles
                          .texFieldPlaceHolderStyle()
                          .copyWith(color: Colors.red),
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
          inputKeyboardType: InputKeyboardTypeWithError.phone,
          hintText: AppString.enterYoursPhoneNumber,
          hintStyle: appStyles.hintTextStyle(),
          textStyle: appStyles.textFieldTextStyle(texColor: phoneNumber != null ? Colors.grey : Colors.black),
          contentPadding: const EdgeInsets.only(left: 15, right: 15),
          inputFieldPrefixIcon: CountryCodePicker(
            showFlag: false,
            enabled: false,
            textStyle: appStyles.textFieldTextStyle(),
            padding:
                const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 10),
            initialSelection: 'IN',
            onChanged: (value) {
              // countryCode = value.dialCode!.trim();
            },
            onInit: (value) {
              //countryCode = value!.dialCode!.trim();
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
          onTapCallBack: ()
          {
            if (email != null ) {
              WorkplaceWidgets.errorPopUp(
                  context: context,
                  content: AppString.updateEmailMsg,
                  onTap: () {
                    Navigator.of(context).pop();
                  });
            }
          },
          focusNode: focusNodes['email'],
          isShowBottomErrorMsg: true,
          errorMessages: errorMessages['email'] ?? '',
        //  readOnly: controllers['email']?.text.isEmpty == true ? false : true,
          readOnly : email != null ? true : false,
          controllerT: controllers['email'],
          borderRadius: 8,
          inputHeight: 50,
          errorLeftRightMargin: 0,
          maxCharLength: 50,
          errorMsgHeight: 20,
          autoFocus: false,
          showError: true,
          capitalization: CapitalizationText.none,
          cursorColor: Colors.grey,
          placeHolderTextWidget: Padding(
              padding: const EdgeInsets.only(left: 3.0, bottom: 3),
              child: Text.rich(
                TextSpan(
                  text: AppString.emailAddress,
                  style: appStyles.texFieldPlaceHolderStyle(),
                  children: [
                    TextSpan(
                      text: ' *',
                      style: appStyles
                          .texFieldPlaceHolderStyle()
                          .copyWith(color: Colors.red),
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
          textStyle: appStyles.textFieldTextStyle(texColor: email != null ? Colors.grey : Colors.black),
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

    submitButton() {
      return Container(
        margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
        child: AppButton(
          buttonName: AppString.submit,
          buttonColor:
              (validateFields()) ? AppColors.textBlueColor : Colors.grey,
          textStyle: appStyles.buttonTextStyle1(
            texColor: AppColors.white,
          ),
          backCallback: () {
            if (validateFields(isButtonClicked: true)) {
              userProfileBloc.add(StoreMediaEvent(
                mContext: context,
                firstName: controllers['firstName']?.text,
                lastName: controllers['lastName']?.text,
              ));
            }
          },
        ),
      );
    }

    return ContainerFirst(
        contextCurrentView: context,
        isSingleChildScrollViewNeed: true,
        isFixedDeviceHeight: true,
        isListScrollingNeed: false,
        isOverLayStatusBar: false,
        bottomSafeArea: true,
        appBarHeight: 50,
        appBar: const CommonAppBar(
          title: AppString.updateProfile,
          icon: WorkplaceIcons.backArrow,
        ),
        containChild: BlocListener<UserProfileBloc, UserProfileState>(
          bloc: userProfileBloc,
          listener: (context, state) {
            if(state is StoreMediaState)
            {
              Navigator.pop(context);
              WorkplaceWidgets.successToast(AppString.profileUpdatedSuccessfully);

            }
            if(state is UpdateProfilePhotoErrorState)
              {

                WorkplaceWidgets.errorSnackBar(context,state.errorMessage);
              }
          },

          child: BlocBuilder<UserProfileBloc, UserProfileState>(
              bloc: userProfileBloc,
              builder: (context, state) {
                return Column(
                  children: [
                    const SizedBox(height: 5),
                    firstNameField(),
                    lastNameField(),
                    phoneNumberField(),
                    emailField(),
                    submitButton(),
                    const SizedBox(height: 8),
                  ],
                );
              }),
        ));
  }
}
